data "aws_iam_policy_document" "srt_assume_role" {
  count = var.force_enable_shield_srt_access || local.shield_advanced_is_enabled_via_policy ? 1 : 0

  statement {
    principals {
      type        = "Service"
      identifiers = ["drt.shield.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "srt" {
  count = var.force_enable_shield_srt_access || local.shield_advanced_is_enabled_via_policy ? 1 : 0

  name = "ShieldSRTRole"

  assume_role_policy = data.aws_iam_policy_document.srt_assume_role[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "srt_access" {
  count = var.force_enable_shield_srt_access || local.shield_advanced_is_enabled_via_policy ? 1 : 0

  role       = aws_iam_role.srt[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSShieldDRTAccessPolicy"
}

resource "aws_shield_drt_access_role_arn_association" "srt" {
  count = var.force_enable_shield_srt_access || local.shield_advanced_is_enabled_via_policy ? 1 : 0

  role_arn = aws_iam_role.srt[0].arn
}

module "srt_bucket_key" {
  #checkov:skip=CKV_AWS_356:Skip alert for resource-based policy in submodule
  source = "../kms"

  alias       = "${var.account_name}-shield-srt"
  description = "Bucket key for the SRT data bucket"

  common_decryption_roles = flatten([
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SecurityRole",
    aws_iam_role.srt[*].arn
  ])

  common_encryption_roles = flatten([
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SecurityRole",
    aws_iam_role.srt[*].arn
  ])

  tags = var.tags
}

locals {
  srt_bucket_names = toset([for name in var.srt_bucket_names : "powise-${var.account_name}-shield-srt-${name}"])
}

data "aws_iam_policy_document" "srt_bucket_access_policy" {
  for_each = local.srt_bucket_names

  statement {
    principals {
      type = "Service"
      identifiers = [
        "drt.shield.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = [
      each.value,
      "${each.value}/*"
    ]
  }
}

module "srt_bucket" {
  source = "../s3/bucket"

  for_each = local.srt_bucket_names

  bucket_name = each.value

  encryption_at_rest = {
    bucket_key_enabled = true
    encryption_settings = {
      sse_algorithm     = "AES256"
      kms_master_key_id = module.srt_bucket_key.key_id
    }
  }

  bucket_policy = data.aws_iam_policy_document.srt_bucket_access_policy[each.value].json

  tags = var.tags
}

# Proactive engagement
resource "aws_shield_proactive_engagement" "contacts" {
  count = var.force_enable_shield_srt_access || local.shield_advanced_is_enabled_via_policy ? 1 : 0

  enabled = var.enable_proactive_engagement

  dynamic "emergency_contact" {
    for_each = local.combined_proactive_engagement_contacts

    content {
      email_address = emergency_contact.key
      contact_notes = try(emergency_contact.value.contact_notes, null)
      phone_number  = try(emergency_contact.value.phone_number, null)
    }
  }

  lifecycle {
    precondition {
      condition     = length(compact([for contact, data in local.combined_proactive_engagement_contacts : try(data.phone_number, "")])) > 0
      error_message = "Proactive engagement requires at least one phone number."
    }
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  #checkov:skip=CKV2_AWS_6: Public Access Blocks are an optional feature for bucket
  #checkov:skip=CKV_AWS_18: Access logs are disabled.
  #checkov:skip=CKV_AWS_19: Encryption at rest enabled. Checkov just doesn't acknowledge yet it is no longer enabled in this resource
  #checkov:skip=CKV_AWS_20: Bucket does not have ACL with public READ access
  #checkov:skip=CKV_AWS_21: Versioning is optionally enabled in this module
  #checkov:skip=CKV_AWS_57: Bucket does not have ACL with public WRITE access
  #checkov:skip=CKV_AWS_144: Disable cross-region replication check. Replication handled by module
  #checkov:skip=CKV_AWS_145: Disable KMS encryption check
  #checkov:skip=CKV2_AWS_62: Disable event notifications check
  #checkov:skip=CKV_AWS_300: Disable period for aborting failed uploads check

  bucket = local.bucket_name

  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_config != null ? true : false

  # Warn users if they attempt to enable backups without versioning
  lifecycle {
    precondition {
      condition     = !(var.aws_backup_enabled && !var.enable_versioning)
      error_message = "Backups require versioning. Set `enable_versioning = true` when `enable_backup = true`."
    }
  }

  tags = local.tags
}

# Cors
resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  count = var.cors_configuration != null ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.bucket

  dynamic "cors_rule" {
    for_each = var.cors_configuration
    content {
      id              = cors_rule.key
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

# Versioning
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ACL
resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  #checkov:skip=CKV2_AWS_65:Optional

  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = var.object_ownership_setting
  }
}

resource "aws_s3_bucket_acl" "canned_s3_bucket_acl" {
  count  = var.object_ownership_setting != "BucketOwnerEnforced" && var.acl != null ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = var.acl
}


resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  count  = var.object_ownership_setting != "BucketOwnerEnforced" && var.acl_policy_grants != null ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  dynamic "access_control_policy" {
    for_each = var.acl_policy_grants
    content {
      dynamic "grant" {
        for_each = access_control_policy.value.grants
        content {
          grantee {
            id   = grant.value.id
            type = grant.value.type
            uri  = grant.value.uri
          }
          permission = grant.value.permission
        }
      }
      owner {
        id = access_control_policy.value.owner_id
      }
    }
  }
}

# Public Access
resource "aws_s3_bucket_public_access_block" "block_public_acls" {
  #checkov:skip=CKV_AWS_53:Optional
  #checkov:skip=CKV_AWS_56:Optional

  count                   = var.public_access_block != null ? 1 : 0
  bucket                  = aws_s3_bucket.s3_bucket.id
  ignore_public_acls      = var.public_access_block.ignore_public_acls
  block_public_policy     = var.public_access_block.block_public_policy
  block_public_acls       = var.public_access_block.block_public_acls
  restrict_public_buckets = var.public_access_block.restrict_public_buckets
}

# Bucket Policy
module "bucket_policy" {
  count = local.enable_bucket_policy ? 1 : 0

  source = "../bucket_policy"

  bucket_id  = aws_s3_bucket.s3_bucket.id
  bucket_arn = aws_s3_bucket.s3_bucket.arn

  bucket_policy                 = var.bucket_policy
  bucket_policy_template        = var.bucket_policy_template
  deny_insecure_transport       = var.deny_insecure_transport
  require_latest_tls            = var.require_latest_tls
  require_encrypted_uploads     = var.require_encrypted_uploads
  attach_lb_log_delivery_policy = var.attach_lb_log_delivery_policy

  cloudfront_distribution_arns = var.enable_cloudfront ? [aws_cloudfront_distribution.readonly[0].arn] : []
}

moved {
  from = aws_s3_bucket_policy.bucket_policy_att
  to   = module.bucket_policy[0].aws_s3_bucket_policy.policy
}

moved {
  from = module.bucket_policy[0].aws_s3_bucket_policy.policy[0]
  to   = module.bucket_policy[0].aws_s3_bucket_policy.policy
}

# Website
resource "aws_s3_bucket_website_configuration" "website_config" {
  count  = var.website_configuration != null ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.bucket

  routing_rules = var.website_configuration.routing_rules != null ? jsonencode(var.website_configuration.routing_rules) : null

  dynamic "redirect_all_requests_to" {
    for_each = var.website_configuration.redirect != null ? [1] : []
    content {
      host_name = var.website_configuration.redirect.domain
      protocol  = var.website_configuration.redirect.protocol
    }
  }

  dynamic "index_document" {
    for_each = var.website_configuration.index_document != null ? [1] : []
    content {
      suffix = var.website_configuration.index_document
    }
  }

  dynamic "error_document" {
    for_each = var.website_configuration.error_document != null ? [1] : []
    content {
      key = var.website_configuration.error_document
    }
  }
}

#Encryption at Rest
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  #checkov:skip=CKV2_AWS_67: We don't want to use CMK here
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    bucket_key_enabled = var.encryption_at_rest.bucket_key_enabled
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.encryption_at_rest.encryption_settings.kms_master_key_id
      sse_algorithm     = var.encryption_at_rest.encryption_settings.sse_algorithm
    }
  }
}

#Logging
locals {
  logging_target_bucket = coalesce(var.logging_bucket, "${data.aws_caller_identity.current.account_id}-s3-access-logs-${aws_s3_bucket.s3_bucket.region}")
  logging_target_prefix = coalesce(var.logging_prefix, "${data.aws_caller_identity.current.account_id}/${aws_s3_bucket.s3_bucket.id}/")
}

resource "aws_s3_bucket_logging" "bucket_logging" {
  count         = var.logging_enabled ? 1 : 0
  bucket        = aws_s3_bucket.s3_bucket.id
  target_bucket = local.logging_target_bucket
  target_prefix = local.logging_target_prefix
}

# Lifecycle
locals {
  # Variables with type `any` should be jsonencode()'d when value is coming from Terragrunt
  lifecycle_rules = try(jsondecode(var.lifecycle_rules), var.lifecycle_rules)
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  #checkov:skip=CKV_AWS_300: Disable period for aborting failed uploads check

  count = length(local.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.id

  transition_default_minimum_object_size = var.transition_default_minimum_object_size

  dynamic "rule" {
    for_each = local.lifecycle_rules

    content {
      id     = try(rule.value.id, null)
      status = try(rule.value.enabled ? "Enabled" : "Disabled", tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)))

      # Max 1 block - abort_incomplete_multipart_upload
      dynamic "abort_incomplete_multipart_upload" {
        for_each = try([rule.value.abort_incomplete_multipart_upload_days], [])

        content {
          days_after_initiation = try(rule.value.abort_incomplete_multipart_upload_days, null)
        }
      }


      # Max 1 block - expiration
      dynamic "expiration" {
        for_each = try(flatten([rule.value.expiration]), [])

        content {
          date                         = try(expiration.value.date, null)
          days                         = try(expiration.value.days, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      # Several blocks - transition
      dynamic "transition" {
        for_each = try(flatten([rule.value.transition]), [])

        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }

      # Max 1 block - noncurrent_version_expiration
      dynamic "noncurrent_version_expiration" {
        for_each = try(flatten([rule.value.noncurrent_version_expiration]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.days, noncurrent_version_expiration.value.noncurrent_days, null)
        }
      }

      # Several blocks - noncurrent_version_transition
      dynamic "noncurrent_version_transition" {
        for_each = try(flatten([rule.value.noncurrent_version_transition]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.days, noncurrent_version_transition.value.noncurrent_days, null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      # Max 1 block - filter - without any key arguments or tags, to match all
      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []

        content {}
      }

      # Max 1 block - filter - with one key argument or a single tag
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]

        content {
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)
          prefix                   = try(filter.value.prefix, null)

          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      # Max 1 block - filter - with more than one key arguments or multiple tags
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]

        content {
          and {
            object_size_greater_than = try(filter.value.object_size_greater_than, null)
            object_size_less_than    = try(filter.value.object_size_less_than, null)
            prefix                   = try(filter.value.prefix, null)
            tags                     = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }

  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.s3_bucket_versioning]
}


#Object Lock
resource "aws_s3_bucket_object_lock_configuration" "bucket_object_lock" {
  count                 = var.object_lock_config != null ? 1 : 0
  bucket                = aws_s3_bucket.s3_bucket.id
  expected_bucket_owner = var.object_lock_config.expected_bucket_owner
  token                 = var.object_lock_config.token

  rule {
    default_retention {
      mode  = var.object_lock_config.default_retention.mode
      days  = var.object_lock_config.default_retention.days
      years = var.object_lock_config.default_retention.years
    }
  }
}

#Metrics
resource "aws_s3_bucket_metric" "bucket_metric" {
  for_each = var.metric_config

  name   = each.key
  bucket = aws_s3_bucket.s3_bucket.id

  dynamic "filter" { # Extra filter(s) for specific objects or folders
    for_each = [each.value]
    content {
      prefix = each.value.prefix
      tags   = each.value.tags
    }
  }
}

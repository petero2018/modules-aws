resource "aws_s3_bucket_policy" "policy" {
  bucket = var.bucket_id
  policy = data.aws_iam_policy_document.combined_policy.json
}

data "aws_iam_policy_document" "combined_policy" {
  source_policy_documents = compact([
    var.require_latest_tls ? data.aws_iam_policy_document.require_latest_tls.json : "",
    var.deny_insecure_transport ? data.aws_iam_policy_document.deny_insecure_transport.json : "",
    var.require_encrypted_uploads ? data.aws_iam_policy_document.require_encrypted_uploads.json : "",
    var.attach_lb_log_delivery_policy ? data.aws_iam_policy_document.lb_log_delivery.json : "",
    length(var.cloudfront_distribution_arns) > 0 ? data.aws_iam_policy_document.cloudfront_readonly[0].json : "",
    var.replication_role_arn != null ? data.aws_iam_policy_document.replication_destination_bucket_policy[0].json : "",
    length(var.bucket_policy_template) > 0 ? data.aws_iam_policy_document.template_policy.json : "",
    var.bucket_policy != null ? var.bucket_policy : "",
  ])
}

data "aws_iam_policy_document" "deny_insecure_transport" {
  statement {
    sid    = "denyInsecureTransport"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      var.bucket_arn,
      "${var.bucket_arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}

data "aws_iam_policy_document" "require_latest_tls" {
  statement {
    sid    = "denyOutdatedTLS"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      var.bucket_arn,
      "${var.bucket_arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values = [
        "1.2"
      ]
    }
  }
}

data "aws_iam_policy_document" "require_encrypted_uploads" {
  statement {
    sid    = "DenyIncorrectEncryptionHeader"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${var.bucket_arn}/*"]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms", "AES256"]
    }
  }

  statement {
    sid    = "DenyUnEncryptedObjectUploads"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:PutObject"]

    resources = ["${var.bucket_arn}/*"]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "lb_log_delivery" {
  statement {
    # Policy needed for ALB
    # https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy
    sid = "AWSStoreALBLogs"

    principals {
      identifiers = [data.aws_elb_service_account.current.arn]
      type        = "AWS"
    }

    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${var.bucket_arn}/*",
    ]
  }

  statement {
    sid = "AWSLogDeliveryWrite"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${var.bucket_arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      var.bucket_arn,
    ]

  }
}

data "aws_iam_policy_document" "cloudfront_readonly" {
  count = length(var.cloudfront_distribution_arns) > 0 ? 1 : 0

  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${var.bucket_arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = var.cloudfront_distribution_arns
    }
  }
}

data "aws_iam_policy_document" "template_policy" {
  dynamic "statement" {
    for_each = var.bucket_policy_template
    content {
      sid    = statement.key
      effect = statement.value.effect != null ? statement.value.effect : "Allow"
      principals {
        identifiers = statement.value.principals
        type        = statement.value.principal_type != null ? statement.value.principal_type : "AWS"
      }
      actions = statement.value.actions
      resources = concat([var.bucket_arn], [
        for path in statement.value.paths != null ? statement.value.paths : ["*"] :
        "${var.bucket_arn}/${path}"
      ])
      dynamic "condition" {
        for_each = toset(coalesce(statement.value.conditions, []))
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

data "aws_iam_policy_document" "replication_destination_bucket_policy" {
  count = var.replication_role_arn != null ? 1 : 0

  statement {
    principals {
      type        = "AWS"
      identifiers = [var.replication_role_arn]
    }

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]

    resources = [
      "${var.bucket_arn}/*",
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [var.replication_role_arn]
    }

    actions = [
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning"
    ]

    resources = [
      var.bucket_arn,
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [var.replication_role_arn]
    }

    actions = [
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]

    resources = [
      "${var.bucket_arn}/*",
    ]
  }

  dynamic "statement" {
    for_each = var.allow_read_from_account_ids
    content {
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${statement.value}:root"]
      }

      actions = [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:GetObjectTagging"
      ]

      resources = [
        var.bucket_arn,
        "${var.bucket_arn}/*"
      ]
    }
  }
}

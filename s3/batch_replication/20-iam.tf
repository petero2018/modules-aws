data "aws_caller_identity" "current" {}

# Batch replication role
resource "aws_iam_role" "s3_batch_replication" {
  name               = "S3BatchReplicationRole"
  assume_role_policy = data.aws_iam_policy_document.allow_batch_operations.json

  inline_policy {
    name   = "S3BatchReplicationPolicy"
    policy = data.aws_iam_policy_document.s3_batch_replication.json
  }

  tags = var.tags
}

# Trust policy
data "aws_iam_policy_document" "allow_batch_operations" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["batchoperations.s3.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CiCdRole"]
    }

  }
}

# Permission policies
data "aws_iam_policy_document" "s3_batch_replication" {
  # This policy allows starting a batch replication from existing replication settings
  statement {
    actions = [
      "s3:InitiateReplication",
    ]
    resources = [
      "arn:aws:s3:::*/*",
    ]
  }

  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:PutInventoryConfiguration",
    ]
    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]
    resources = ["${var.manifests_bucket_arn}/*"]
  }

  statement {
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${var.reports_bucket_arn}/*",
      "${var.manifests_bucket_arn}/*",
    ]
  }
}

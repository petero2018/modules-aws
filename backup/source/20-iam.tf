# Data sources
data "aws_iam_policy_document" "allow_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lambda role
resource "aws_iam_role" "lambda_rds_copy" {
  name               = "lambda-rds-backup-copy-${var.environment}-${data.aws_region.current.name}"
  assume_role_policy = data.aws_iam_policy_document.allow_lambda.json

  tags = var.tags
}

resource "aws_iam_role_policy" "lambda_rds_copy_policy" {
  name   = "rds-backup-copy-permissions-${var.environment}-${data.aws_region.current.name}"
  policy = data.aws_iam_policy_document.lambda_rds_copy.json
  role   = aws_iam_role.lambda_rds_copy.name
}

data "aws_iam_policy_document" "lambda_rds_copy" {
  #checkov:skip=CKV_AWS_111:Cannot constrain permissions more than this
  #checkov:skip=CKV_AWS_356:Same
  statement {
    actions = [
      "backup:StartCopyJob",
      "backup:DescribeRecoveryPoint",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["${aws_cloudwatch_log_group.lambda_rds_copy.arn}:*"]
  }
  statement {
    actions = [
      "iam:PassRole",
    ]
    resources = [var.backup_role_arn]
  }
}

# Snapshot export role
resource "aws_iam_role" "snapshot_export" {
  name               = "aws-backup-export-snapshot-${var.environment}-${data.aws_region.current.name}"
  assume_role_policy = data.aws_iam_policy_document.allow_backup.json

  tags = var.tags
}

resource "aws_iam_role_policy" "export_snapshots_to_s3_policy" {
  name   = "export-snapshots-s3-${var.environment}-${data.aws_region.current.name}"
  policy = data.aws_iam_policy_document.export_snapshots_to_s3.json
  role   = aws_iam_role.snapshot_export.name
}

data "aws_iam_policy_document" "allow_backup" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["export.rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "export_snapshots_to_s3" {
  statement {
    actions = [
      "s3:PutObject*",
      "s3:ListBucket",
      "s3:GetObject*",
      "s3:DeleteObject*",
      "s3:GetBucketLocation",
    ]
    resources = [
      module.db_export_bucket.bucket_arn,
      "${module.db_export_bucket.bucket_arn}/*"
    ]
  }
}

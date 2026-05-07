resource "aws_iam_role" "replication" {
  name = local.replication_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

  tags = local.tags
}

resource "aws_iam_policy" "replication" {
  name   = local.replication_policy_name
  policy = data.aws_iam_policy_document.replication_policy.json
  tags   = local.tags
}

data "aws_iam_policy_document" "replication_policy" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]
    resources = [
      var.bucket_arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]
    resources = [
      "${var.bucket_arn}/*",
    ]
  }

  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]
    resources = formatlist("%s/*", local.target_bucket_arns)
  }

  statement {
    actions = [
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
    resources = formatlist("%s/*", local.target_bucket_arns)
  }

  dynamic "statement" {
    for_each = local.source_kms_keys
    content {
      actions = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey*",
        "kms:ReEncrypt*",
        "kms:DescribeKey"
      ]
      resources = local.source_kms_keys

    }
  }

  dynamic "statement" {
    for_each = local.target_kms_keys
    content {
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey*",
        "kms:ReEncrypt*",
        "kms:DescribeKey"
      ]
      resources = local.target_kms_keys
    }
  }
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

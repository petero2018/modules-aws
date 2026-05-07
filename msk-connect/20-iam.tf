resource "aws_iam_role" "msk_connect" {
  name = "msk-connect-${var.name}-${data.aws_region.current.name}"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.msk_connect_assume_role_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy" "msk_connect" {
  count = var.connector_mode == "s3" ? 1 : 0

  name   = "MSKConnectS3Policy"
  role   = aws_iam_role.msk_connect.name
  policy = data.aws_iam_policy_document.msk_connect[0].json
}

data "aws_iam_policy_document" "msk_connect_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["kafkaconnect.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "msk_connect" {
  count = var.connector_mode == "s3" ? 1 : 0

  statement {
    sid = "WriteToS3"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]
    resources = [
      var.output_bucket_arn,
      "${var.output_bucket_arn}/*"
    ]
  }

  lifecycle {
    precondition {
      condition     = var.output_bucket_arn != null
      error_message = "The output bucket ARN cannot be null in 's3' mode."
    }
  }
}

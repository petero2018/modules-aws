resource "aws_ssm_parameter" "arn" {
  #checkov:skip=CKV_AWS_337: No need to encrypt using KMS CMK

  count = var.ssm_identifier != null ? 1 : 0

  name        = "/s3/bucket/${var.ssm_identifier}/arn"
  description = "Stores the ARN of the S3 bucket ${local.bucket_name}."
  type        = "SecureString"
  value       = aws_s3_bucket.s3_bucket.arn

  tags = local.tags
}

resource "aws_ssm_parameter" "id" {
  #checkov:skip=CKV_AWS_337: No need to encrypt using KMS CMK

  count = var.ssm_identifier != null ? 1 : 0

  name        = "/s3/bucket/${var.ssm_identifier}/id"
  description = "Stores the ARN of the S3 bucket ${local.bucket_name}."
  type        = "SecureString"
  value       = aws_s3_bucket.s3_bucket.id

  tags = local.tags
}

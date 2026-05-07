output "bucket_arn" {
  value       = aws_s3_bucket.s3_bucket.arn
  description = "ARN of newly created bucket."
}

output "bucket_id" {
  value       = aws_s3_bucket.s3_bucket.id
  description = "ID of newly created bucket."
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.s3_bucket.bucket_domain_name
  description = "The bucket domain namein the format <bucketname>.s3.amazonaws.com"
}

output "hosted_zone_id" {
  value       = aws_s3_bucket.s3_bucket.hosted_zone_id
  description = "The Route 53 Hosted Zone ID for this bucket's region."
}

output "bucket_region" {
  value       = aws_s3_bucket.s3_bucket.region
  description = "Region in which the S3 bucket is deployed."
}

output "bucket_account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS account ID owning the bucket."
}

output "ssm_parameters_arns" {
  value = var.ssm_identifier != null ? [
    aws_ssm_parameter.arn[0].arn,
    aws_ssm_parameter.id[0].arn,
  ] : []
  description = "List of SSM parameter ARNs created, useful to build IAM policies."
}

output "cloudfront_distribution_arn" {
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.readonly[0].arn : null
  description = "CloudFront distribution ARN, if any."
}

output "cloudfront_origin_access_control_id" {
  value       = var.enable_cloudfront ? aws_cloudfront_origin_access_control.s3[0].id : null
  description = "CloudFront Origin Access Control (OAC) ID."
}

output "tags" {
  value       = var.tags
  description = "The user-supplied tags applied to the S3 bucket and its resources."
}

output "all_tags" {
  value       = local.tags
  description = "All tags applied to the S3 bucket and its resources, including tags created by this module."
}

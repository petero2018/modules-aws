output "bucket_arn" {
  value       = aws_s3_bucket.s3_bucket.arn
  description = "Access Logs S3 bucket arn"
}

output "bucket_id" {
  value       = aws_s3_bucket.s3_bucket.id
  description = "Access Logs S3 bucket id"
}

output "bucket_region" {
  value       = aws_s3_bucket.s3_bucket.region
  description = "Region in which the S3 bucket is deployed."
}

output "replication_role" {
  value       = aws_iam_role.replication.arn
  description = "Role for the bucket to replicate objects into another bucket."
}

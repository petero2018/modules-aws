output "bucket_id" {
  description = "ID of S3 bucket"
  value       = aws_s3_bucket_notification.bucket_notification[0].bucket
}

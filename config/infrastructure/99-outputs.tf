output "bucket_name" {
  value       = module.config_bucket.bucket_id
  description = "The name of the S3 bucket to which config recordings are sent"
}

output "sns_topic_arn" {
  value       = try(aws_sns_topic.config_notifications[0].arn, null)
  description = "The ARN of the SNS topic to which config notifications are sent"
}

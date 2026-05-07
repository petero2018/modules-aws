output "bucket_id" {
  value       = module.backup_bucket.bucket_id
  description = "Backup bucket ID."
}

output "bucket_arn" {
  value       = module.backup_bucket.bucket_arn
  description = "Backup bucket ARN."
}

output "bucket_account_id" {
  value       = module.backup_bucket.bucket_account_id
  description = "Backup bucket AWS account ID."
}

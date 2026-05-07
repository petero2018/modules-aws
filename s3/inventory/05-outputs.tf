output "inventory_bucket_id" {
  value       = module.inventory_bucket.bucket_id
  description = "Name of the bucket that will store the s3 inventory data."
}

output "athena_workgroup_name" {
  value       = var.enable_athena ? aws_athena_workgroup.workgroup[0].id : null
  description = "Name of the aws athena workgroup to use for qurying the bucket inventory data."
}

output "address" {
  value       = aws_db_instance.primary.address
  description = "Address of the RDS instance."
}

output "replica_address" {
  value       = length(var.replica_configurations) > 0 ? [for replica in aws_db_instance.replica : replica.address] : null
  description = "Address of the replicas."
}

output "username" {
  value       = aws_db_instance.primary.username
  description = "Username for the RDS instance."
}

output "password" {
  value       = aws_db_instance.primary.password
  description = "Password for the RDS instance."
  sensitive   = true
}

output "identifier" {
  value       = aws_db_instance.primary.identifier
  description = "Identifier of the RDS instance."
}

output "iam_full_access_policy_arn" {
  value       = var.iam_database_authentication_enabled ? aws_iam_policy.rds_iam_full_access_authentication[0].arn : null
  description = "IAM policy ARN for IAM auth with full access to the database."
}

output "iam_read_only_policy_arn" {
  value       = var.iam_database_authentication_enabled ? aws_iam_policy.rds_iam_read_only_authentication[0].arn : null
  description = "IAM policy ARN for IAM auth with read only access to the database."
}

output "proxy_address" {
  value       = var.enable_proxy ? aws_db_proxy.proxy[0].endpoint : null
  description = "Address of the RDS Proxy endpoint, if enabled."
}

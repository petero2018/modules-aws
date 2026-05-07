output "security_group_id" {
  description = "Security group id for MemoryDB Cluster."
  value       = aws_security_group.memorydb_security_group.id
}

output "cluster_endpoint_address" {
  description = "DNS hostname of the cluster configuration endpoint"
  value       = aws_memorydb_cluster.memorydb_cluster.cluster_endpoint[0].address
}

output "iam_full_access_policy_arn" {
  value       = var.iam_authentication_enabled ? aws_iam_policy.memorydb_iam_full_access_authentication[0].arn : null
  description = "IAM policy ARN for IAM auth with full access to the database."
}

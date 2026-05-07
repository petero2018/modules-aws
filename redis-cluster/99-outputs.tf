output "security_group_id" {
  value       = aws_security_group.redis_security_group.id
  description = "Security group id for Redis Cluster."
}

output "cluster_address" {
  value       = aws_elasticache_cluster.redis_cluster.cache_nodes[0].address
  description = "Address of the first cache node."
}

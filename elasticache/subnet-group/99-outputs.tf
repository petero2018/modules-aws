output "subnet_group_name" {
  value       = aws_elasticache_subnet_group.subnet_group.name
  description = "Name of the subnet group."
}

output "vpc_id" {
  value       = var.vpc_id
  description = "VPC ID."
}

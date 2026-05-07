resource "aws_elasticache_subnet_group" "clusters" {
  name        = coalesce(var.subnet_group_name, "${var.environment}-redis-subnet")
  description = coalesce(var.subnet_group_name, "${var.environment}-redis-subnet")
  subnet_ids  = var.private_subnets_ids

  tags = var.tags
}

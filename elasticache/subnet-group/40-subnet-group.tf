resource "aws_elasticache_subnet_group" "subnet_group" {
  name        = var.name
  description = var.name
  subnet_ids  = var.subnet_ids

  tags = var.tags
}

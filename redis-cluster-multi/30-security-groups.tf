resource "aws_security_group_rule" "redis_ingress_from_eks" {
  for_each = var.create_resources ? var.clusters : tomap({})

  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = module.elasticache[each.key].security_group_id
  cidr_blocks       = var.open_cidr_blocks

  description = "Managed by Terraform"
}

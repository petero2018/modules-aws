resource "aws_vpc_endpoint" "endpoint" {
  service_name        = var.service_name
  vpc_id              = var.vpc_id
  policy              = var.policy
  private_dns_enabled = var.private_dns_enabled
  route_table_ids     = local.vpc_tables
  subnet_ids          = local.vpc_subnets
  security_group_ids  = local.vpc_sg
  vpc_endpoint_type   = var.endpoint_type
  tags                = merge(var.tags, { Name = var.name })
}

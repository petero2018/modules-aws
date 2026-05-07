module "elasticache" {
  for_each = var.create_resources ? var.clusters : tomap({})

  source                     = "../redis-cluster"
  redis_name                 = each.key
  redis_version              = each.value.version
  node_type                  = each.value.instance_type
  upgrade_old_instance_types = var.upgrade_old_instance_types
  subnet_group_name          = aws_elasticache_subnet_group.clusters.name
  vpc_id                     = var.vpc_id
  parameter_group_name       = each.value.parameter_group
  security_group_name        = coalesce(each.value.security_group_name, "redis-${each.key}")
  route53_zone_id            = var.route53_zone_id
  dns_name                   = each.value.dns_name

  tags = { "team" = each.value.tag_team, "service" = each.value.tag_service, "impact" = each.value.tag_impact }
}

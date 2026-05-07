resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = var.redis_name
  engine               = "redis"
  engine_version       = var.redis_version
  node_type            = local.instance_type
  port                 = 6379
  num_cache_nodes      = 1
  parameter_group_name = var.parameter_group_name == "default" ? var.default_parameter_group[var.redis_version] : var.parameter_group_name
  security_group_ids   = [aws_security_group.redis_security_group.id]
  subnet_group_name    = var.subnet_group_name
  apply_immediately    = true

  #checkov:skip=CKV_AWS_134:Snapshots are not supported on t1.micro
  snapshot_retention_limit = local.instance_type == "cache.t1.micro" ? 0 : 5

  tags = local.tags
}

resource "aws_security_group" "redis_security_group" {
  name        = local.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  lifecycle { # Allows replacing security groups
    create_before_destroy = true
  }

  tags = merge(local.tags, {
    Name = local.security_group_name
  })
}

resource "aws_security_group_rule" "ingress" {
  for_each = toset(var.open_cidr_blocks)

  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = aws_security_group.redis_security_group.id
  cidr_blocks       = [each.key]

  description = "Redis ingress."
}

resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  count  = var.parameter_group_name == "default" ? 0 : 1
  name   = var.parameter_group_name
  family = "redis2.8"
  tags   = local.tags
}

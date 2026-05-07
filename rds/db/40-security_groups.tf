resource "aws_security_group" "primary" {
  #checkov:skip=CKV_AWS_23:security group description is passed by parameter
  #checkov:skip=CKV_AWS_382:We'll need to restrict this later on
  count       = var.create_security_group ? 1 : 0
  name        = "${var.environment}-${var.name}-database"
  vpc_id      = var.vpc_id
  description = var.security_group_description

  # We're using block level syntax in order to allow terraform to manage all security group rules.
  # Using aws_security_group_rule allows external additions to go unnoticed.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow CIDRs"
    from_port   = local.ports[var.engine]
    to_port     = local.ports[var.engine]
    protocol    = "tcp"
    cidr_blocks = local.allowed_cidrs
  }

  dynamic "ingress" {
    for_each = concat(
      local.allowed_security_groups,
      var.enable_proxy ? [aws_security_group.proxy[0]] : [],
    )
    content {
      description     = "Allow ${ingress.value.name} security group"
      from_port       = local.ports[var.engine]
      to_port         = local.ports[var.engine]
      protocol        = "tcp"
      security_groups = [ingress.value.id]
    }
  }

  tags = merge({
    Env  = var.environment
    Role = "${var.name}-database"
  }, local.base_tags)

  lifecycle {
    # This is needed when disabling RDS Proxy to remove the ingress rule before the proxy security group
    # The other option would be to use aws_security_group_rule resources instead of inline rules
    create_before_destroy = true
  }
}

resource "aws_security_group" "proxy" {
  count = var.enable_proxy ? 1 : 0

  name = "${var.environment}-${var.name}-proxy"

  vpc_id      = var.vpc_id
  description = "RDS Proxy security group for ${local.identifier}"

  # Same ingress rules as the database itself
  ingress {
    description = "Allow CIDRs"
    from_port   = local.ports[var.engine]
    to_port     = local.ports[var.engine]
    protocol    = "tcp"
    cidr_blocks = local.allowed_cidrs
  }

  dynamic "ingress" {
    for_each = local.allowed_security_groups
    content {
      description     = "Allow ${ingress.value.name} security group"
      from_port       = local.ports[var.engine]
      to_port         = local.ports[var.engine]
      protocol        = "tcp"
      security_groups = [ingress.value.id]
    }
  }

  tags = local.base_tags
}

resource "aws_vpc_security_group_egress_rule" "proxy" {
  # We must create the egress rule in its own resource to avoid a cyclic dependency
  count = var.enable_proxy ? 1 : 0

  security_group_id            = aws_security_group.proxy[0].id
  referenced_security_group_id = aws_security_group.primary[0].id
  from_port                    = local.ports[var.engine]
  to_port                      = local.ports[var.engine]
  ip_protocol                  = "tcp"
}

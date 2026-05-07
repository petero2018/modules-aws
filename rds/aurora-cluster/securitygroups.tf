locals {
  ports = {
    aurora-mysql = 3306
  }
}

resource "aws_security_group" "primary" {
  #checkov:skip=CKV_AWS_23:security group description is passed by parameter
  name   = "${var.environment}-${var.name}-database"
  vpc_id = var.vpc_id

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
    cidr_blocks = var.allowed_cidrs
  }

  dynamic "ingress" {
    for_each = var.allowed_security_groups
    content {
      description     = "Allow ${ingress.value.name} security group"
      from_port       = local.ports[var.engine]
      to_port         = local.ports[var.engine]
      protocol        = "tcp"
      security_groups = [ingress.value.id]
    }
  }

  tags = {
    Env     = var.environment
    Role    = "${var.name}-database"
    service = "${var.name}-database"
    team    = var.team_tag
    impact  = var.impact_tag
  }
}

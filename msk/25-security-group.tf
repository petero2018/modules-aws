locals {
  security_group_name = coalesce(var.security_group_name, local.full_name)
}

#
# Security Group
#

resource "aws_security_group" "security_group" {
  name        = local.security_group_name
  description = coalesce(var.security_group_description, "Security Group for Kafka Cluster ${local.full_name}")
  vpc_id      = var.vpc_id

  tags = merge(local.tags, {
    Name = local.security_group_name
  })
}

# Allow all egress
resource "aws_security_group_rule" "security_group_egress" {
  description       = "Allow all egress"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
}

# Ingress rules
resource "aws_security_group_rule" "ingress_cidr" {
  for_each = local.cidr_ingress_rules

  security_group_id = aws_security_group.security_group.id

  description = each.value.protocol.name
  type        = "ingress"
  from_port   = each.value.protocol.port
  to_port     = each.value.protocol.port
  protocol    = "tcp"

  cidr_blocks = [each.value.cidr]
}

resource "aws_security_group_rule" "ingress_sg" {
  for_each = local.sg_ingress_rules

  security_group_id = aws_security_group.security_group.id

  description = each.value.protocol.name
  type        = "ingress"
  from_port   = each.value.protocol.port
  to_port     = each.value.protocol.port
  protocol    = "tcp"

  source_security_group_id = each.value.sg
}

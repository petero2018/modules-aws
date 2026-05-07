resource "aws_security_group" "security_group" {
  name        = var.domain
  description = "Security Group for Opensearch Cluster ${var.domain}"
  vpc_id      = local.vpc_id

  tags = merge(var.tags, { Name = var.domain })
}

resource "aws_security_group_rule" "security_group_egress" {
  #checkov:skip=CKV_AWS_382:We need the egress rule

  description       = "Allow all egress"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
}

locals {
  vpc_cidr_block = try(data.aws_vpc.vpc_from_id[0].cidr_block, data.aws_vpc.vpc_from_name[0].cidr_block)
}

resource "aws_security_group_rule" "security_group_vpc_https" {
  description       = "Allow HTTPS access for VPC"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  cidr_blocks       = [local.vpc_cidr_block]
}

# CIDR Blocks

resource "aws_security_group_rule" "security_group_cidr_https" {
  count = length(var.enable_access_from_cidrs) > 0 ? 1 : 0

  description       = "Allow HTTPS access for extra CIDRs"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  cidr_blocks       = var.enable_access_from_cidrs
}

# VPC

locals {
  vpc_cidrs = [for vpc in data.aws_vpc.sg_vpcs : vpc.cidr_block]
}

resource "aws_security_group_rule" "security_group_vpcs_https" {
  count = length(local.vpc_cidrs) > 0 ? 1 : 0

  description       = "Allow HTTPS access for extra VPCs"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  cidr_blocks       = local.vpc_cidrs
}

# Dashboard Users

resource "aws_security_group_rule" "dashboard_https" {
  description       = "Allow HTTPS access to dashboard users"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  cidr_blocks       = var.dashboard_users_cidrs
}

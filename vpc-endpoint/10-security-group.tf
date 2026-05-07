locals {
  allowed_cidrs = concat([data.aws_vpc.endpoint_vpc.cidr_block], var.extra_cidr)
  vpc_sg = var.endpoint_type == "Gateway" ? null : var.security_group_ids == null ? [
    aws_security_group.default[0].id
  ] : var.security_group_ids
}

resource "aws_security_group" "default" {
  #checkov:skip=CKV_AWS_382:We need the egress rule

  count = var.endpoint_type != "Gateway" && var.security_group_ids == null ? 1 : 0

  name        = "${var.vpc_id} / ${var.service_name} Security Group"
  description = "Allows traffic from ${var.vpc_id} into the ${var.service_name} vpc endpoint."
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.allowed_cidrs
  }

  egress {
    description      = "Allow all egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}

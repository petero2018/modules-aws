resource "aws_security_group" "allow_ingress" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    description = "Allow all outbound traffic"
  }

  tags = local.tags
}

resource "aws_security_group_rule" "allow_ingress_rule" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = var.protocol
  cidr_blocks       = var.cidr_blocks
  ipv6_cidr_blocks  = var.ipv6_cidr_blocks
  security_group_id = aws_security_group.allow_ingress.id

  description = var.description
}

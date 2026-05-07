resource "aws_security_group" "memorydb_security_group" {
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
  security_group_id = aws_security_group.memorydb_security_group.id
  cidr_blocks       = [each.key]

  description = "MemoryDB ingress."
}

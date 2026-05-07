resource "aws_security_group" "cloudfront_sg" {
  count       = local.num_groups
  name        = "${var.name}_${count.index + 1}"
  description = "Security group for CloudFront - Group ${count.index + 1}"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  for_each = local.ingress_rules

  description = var.description

  security_group_id = each.value.sg_id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value.ip

  tags = var.tags
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = var.private_subnet_tags
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  vpc_dns_server = cidrhost(data.aws_vpc.vpc.cidr_block, 2)
  dns_servers    = length(var.dns_servers) > 0 ? var.dns_servers : [local.vpc_dns_server]
}

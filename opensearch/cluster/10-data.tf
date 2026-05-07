data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_vpc" "sg_vpcs" {
  for_each = toset(var.enable_access_from_vpc)

  id = each.key
}

data "aws_vpc" "vpc_from_id" {
  count = var.vpc_id != null ? 1 : 0

  id = var.vpc_id
}

data "aws_vpc" "vpc_from_name" {
  count = var.vpc_name != null ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

locals {
  vpc_id = try(data.aws_vpc.vpc_from_id[0].id, data.aws_vpc.vpc_from_name[0].id)
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  tags = var.subnet_tags
}

data "aws_route53_zone" "zone" {
  count = var.custom_endpoint_enabled ? 1 : 0

  name = var.custom_endpoint_zone
}

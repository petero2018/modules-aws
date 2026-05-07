data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = var.subnet_tags
}

locals {
  subnet_ids = coalesce(var.subnet_ids, data.aws_subnets.subnets.ids)
}

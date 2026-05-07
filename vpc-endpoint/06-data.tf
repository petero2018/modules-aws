################################################################################
# VPC Tables
################################################################################

data "aws_vpc" "endpoint_vpc" {
  id = var.vpc_id
}

data "aws_route_tables" "tables" {
  count = var.route_table_ids == null && var.endpoint_type == "Gateway" ? 1 : 0

  vpc_id = var.vpc_id
}

locals {
  vpc_tables = var.endpoint_type != "Gateway" ? null : var.route_table_ids == null ? data.aws_route_tables.tables[0].ids : var.route_table_ids
}

################################################################################
# Subnets
################################################################################

data "aws_subnets" "private" {
  count = var.endpoint_type != "Gateway" && var.subnet_ids == null ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = { tier = "private" }
}

locals {
  vpc_subnets = var.endpoint_type == "Gateway" ? null : var.subnet_ids != null ? var.subnet_ids : data.aws_subnets.private[0].ids
}

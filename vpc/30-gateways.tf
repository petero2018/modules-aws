## Gateways
resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = var.vpc_name
  }, var.tags)
}

resource "aws_eip" "nat_ip" {
  for_each = local.public_azs
  domain   = "vpc"

  tags = merge({
    Name = "${var.vpc_name} ${each.key} NAT IP"
  }, var.tags)
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each      = local.public_azs
  allocation_id = aws_eip.nat_ip[each.key].id
  subnet_id     = aws_subnet.subnet[each.value[0]].id

  tags = merge({
    Name = "${var.vpc_name} ${each.key}"
  }, var.tags)
}

# Service Gateways

locals {
  route_tables = concat(values(aws_route_table.private)[*].id, values(aws_route_table.public)[*].id)
}

resource "aws_vpc_endpoint" "s3_gateway" {
  count = var.enable_service_gateways ? 1 : 0

  vpc_id            = aws_vpc.vpc.id
  vpc_endpoint_type = "Gateway"

  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  route_table_ids = local.route_tables

  tags = merge(var.tags, {
    Name = "s3-gateway"
  })
}

resource "aws_vpc_endpoint" "dynamodb_gateway" {
  count = var.enable_service_gateways ? 1 : 0

  vpc_id            = aws_vpc.vpc.id
  vpc_endpoint_type = "Gateway"

  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"

  route_table_ids = local.route_tables

  tags = merge(var.tags, {
    Name = "dynamodb-gateway"
  })
}

locals {
  single_public_route_map = tomap({ "single" = "single" })
}

## Route tables
resource "aws_route_table" "public" {
  for_each = var.single_public_route_table ? local.single_public_route_map : local.public_subnets
  vpc_id   = aws_vpc.vpc.id

  tags = merge({
    Name = "${var.vpc_name} public ${each.value}"
  }, var.tags)
}

resource "aws_route_table" "private" {
  for_each = local.private_subnets
  vpc_id   = aws_vpc.vpc.id

  tags = merge({
    Name = "${var.vpc_name} private ${each.value}"
  }, var.tags)
}

resource "aws_route_table_association" "public" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.public[var.single_public_route_table ? "single" : each.key].id
}

resource "aws_route_table_association" "private" {
  for_each       = local.private_subnets
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

## Gateway routes
resource "aws_route" "nat_public" {
  for_each               = var.single_public_route_table ? local.single_public_route_map : local.public_subnets
  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc.id
}

resource "aws_route" "nat_private" {
  for_each               = local.private_subnets
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[each.value].id
}

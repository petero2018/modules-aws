# Peering connection
resource "aws_vpc_peering_connection_accepter" "peering" {
  auto_accept = true

  vpc_peering_connection_id = var.peering_connection_id

  tags = {
    Name = var.peering_name
    Side = var.side_tag
  }
}

data "aws_route_tables" "accepter_vpc_route_tables" {
  vpc_id = var.accepter_vpc_id

  filter {
    name   = "association.main"
    values = [false]
  }
}

# Peering routes
resource "aws_route" "accepter_vpc" {
  for_each = toset(data.aws_route_tables.accepter_vpc_route_tables.ids)

  route_table_id            = each.key
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id
}

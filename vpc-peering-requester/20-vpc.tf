# Get Caller identity in case owner id is not defined
data "aws_caller_identity" "current" {}

# Get Caller region in case region is not defined
data "aws_region" "current" {}

# Data source is only used to output the VPC CIDR
data "aws_vpc" "requester" {
  id = var.requester_vpc_id
}

# Peering connection
resource "aws_vpc_peering_connection" "peering" {
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  peer_owner_id = coalesce(var.accepter_owner_id, data.aws_caller_identity.current.account_id)
  peer_region   = coalesce(var.accepter_region, data.aws_region.current.name)

  tags = {
    Name = var.peering_name
    Side = var.side_tag
  }
}

data "aws_route_tables" "requester_vpc_route_tables" {
  vpc_id = var.requester_vpc_id

  filter {
    name   = "association.main"
    values = [false]
  }
}

# Peering routes
resource "aws_route" "requester_vpc" {
  for_each = toset(data.aws_route_tables.requester_vpc_route_tables.ids)

  route_table_id            = each.key
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

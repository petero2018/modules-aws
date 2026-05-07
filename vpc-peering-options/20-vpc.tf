resource "aws_vpc_peering_connection_options" "accepter" {
  count = var.side == "accepter" || var.side == "both" ? 1 : 0

  vpc_peering_connection_id = var.vpc_peering_id

  accepter {
    allow_remote_vpc_dns_resolution = var.allow_remote_vpc_dns_resolution
  }
}

resource "aws_vpc_peering_connection_options" "requester" {
  count = var.side == "requester" || var.side == "both" ? 1 : 0

  vpc_peering_connection_id = var.vpc_peering_id

  requester {
    allow_remote_vpc_dns_resolution = var.allow_remote_vpc_dns_resolution
  }
}

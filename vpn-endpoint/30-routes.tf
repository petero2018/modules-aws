resource "aws_ec2_client_vpn_route" "powise_client_vpn_route_subnet_1" {
  for_each = var.vpn_routes

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.powise_client_vpn.id
  destination_cidr_block = each.value.cidr
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.powise_client_vpn[0].subnet_id
  description            = each.value.description
}

resource "aws_ec2_client_vpn_route" "powise_client_vpn_route_subnet_2" {
  for_each = var.vpn_routes

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.powise_client_vpn.id
  destination_cidr_block = each.value.cidr
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.powise_client_vpn[1].subnet_id
  description            = each.value.description
}

resource "aws_ec2_client_vpn_route" "powise_client_vpn_route_subnet_3" {
  for_each = var.vpn_routes

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.powise_client_vpn.id
  destination_cidr_block = each.value.cidr
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.powise_client_vpn[2].subnet_id
  description            = each.value.description
}

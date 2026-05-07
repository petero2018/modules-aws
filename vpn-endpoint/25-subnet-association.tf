resource "aws_ec2_client_vpn_network_association" "powise_client_vpn" {
  count = length(data.aws_subnets.private.ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.powise_client_vpn.id
  subnet_id              = data.aws_subnets.private.ids[count.index]
}

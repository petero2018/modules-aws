resource "aws_ec2_client_vpn_authorization_rule" "authorization_route_all" {
  for_each = var.authorization_rules_all

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.powise_client_vpn.id
  target_network_cidr    = each.value
  authorize_all_groups   = true
  description            = "All users authorized to ${each.key}"
}

resource "aws_ec2_client_vpn_authorization_rule" "authorization_route" {
  for_each = {
    for rule in flatten([
      for name, peering in var.authorization_rules : [
        for group in peering.groups : {
          name : "${name}-${replace(group, " ", "-")}"
          cidr : peering.cidr,
          group : group
        }
      ]
    ]) : rule.name => rule
  }

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.powise_client_vpn.id
  target_network_cidr    = each.value.cidr
  access_group_id        = each.value.group
  description            = "${each.value.group} authorized to ${each.key}"
}

# Requester
module "requester" {
  source = "../vpc-peering-requester"

  peering_name      = var.peering_name
  requester_vpc_id  = var.requester_vpc_id
  accepter_vpc_id   = var.accepter_vpc_id
  accepter_vpc_cidr = data.aws_vpc.to.cidr_block

  side_tag = var.side_tag
}

module "requester_options" {
  source = "../vpc-peering-options"

  side                            = "requester"
  vpc_peering_id                  = module.requester.peering_connection_id
  allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution

  depends_on = [module.accepter]
}

# Accepter
module "accepter" {
  source = "../vpc-peering-accepter"

  peering_name          = var.peering_name
  accepter_vpc_id       = var.accepter_vpc_id
  requester_vpc_cidr    = data.aws_vpc.from.cidr_block
  peering_connection_id = module.requester.peering_connection_id

  side_tag = var.side_tag
}

module "accepter_options" {
  source = "../vpc-peering-options"

  side                            = "accepter"
  vpc_peering_id                  = module.requester.peering_connection_id
  allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution

  depends_on = [module.accepter]
}

# Data sources
data "aws_vpc" "from" {
  id = var.requester_vpc_id
}

data "aws_vpc" "to" {
  id = var.accepter_vpc_id
}

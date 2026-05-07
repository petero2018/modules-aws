output "peering_connection_id" {
  value       = aws_vpc_peering_connection.peering.id
  description = "VPC peering connection ID."
}

# Output requester VPC CIDR blocks as a shortcut for Terragrunt dependencies
output "requester_vpc_cidr_blocks" {
  value       = [for association in data.aws_vpc.requester.cidr_block_associations : association.cidr_block]
  description = "Requester VPC associated CIDR blocks."
}

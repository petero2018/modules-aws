# Output the peering connection ID from the accepter side, useful for Terragrunt dependencies
output "vpc_peering_connection_id" {
  value       = aws_vpc_peering_connection_accepter.peering.id
  description = "VPC peering connection ID"
}

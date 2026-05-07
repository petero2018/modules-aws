output "id" {
  value       = aws_vpc_endpoint.endpoint.id
  description = "The ID of the VPC endpoint."
}

output "arn" {
  value       = aws_vpc_endpoint.endpoint.arn
  description = "The Amazon Resource Name (ARN) of the VPC endpoint."
}

output "dns_entry" {
  value       = aws_vpc_endpoint.endpoint.dns_entry
  description = "The DNS entries for the VPC Endpoint. Applicable for endpoints of type Interface."
}

output "network_interface_ids" {
  value       = aws_vpc_endpoint.endpoint.network_interface_ids
  description = "One or more network interfaces for the VPC Endpoint. Applicable for endpoints of type Interface."
}

output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of created VPC network."
}

output "cidr_block" {
  value       = aws_vpc.vpc.cidr_block
  description = "CIDR block of the VPC."
}

output "private_subnets_ids" {
  value       = [for cidr, az in local.private_subnets : aws_subnet.subnet[cidr].id if contains(keys(aws_subnet.subnet), cidr)]
  description = "List of private subnet IDs."
}

output "private_extended_subnets_ids" {
  value       = [for cidr, az in local.private_extended_subnets : aws_subnet.subnet[cidr].id if contains(keys(aws_subnet.subnet), cidr)]
  description = "List of private extended subnet IDs."
}

output "public_subnets_ids" {
  value       = [for cidr, az in local.public_subnets : aws_subnet.subnet[cidr].id if contains(keys(aws_subnet.subnet), cidr)]
  description = "List of public subnet IDs."
}

output "nat_gateway_public_ips" {
  value       = [for cidr, az in local.public_azs : aws_nat_gateway.nat_gateway[cidr].public_ip if contains(keys(aws_nat_gateway.nat_gateway), cidr)]
  description = "List of NAT gateways public IPs."
}

output "nat_gateway_public_ips_cidr" {
  value       = [for cidr, az in local.public_azs : "${aws_nat_gateway.nat_gateway[cidr].public_ip}/32" if contains(keys(aws_nat_gateway.nat_gateway), cidr)]
  description = "List of NAT gateways public IPs as CIDR (/32)."
}

output "nat_gateway_private_ips" {
  value       = [for cidr, az in local.public_azs : aws_nat_gateway.nat_gateway[cidr].private_ip if contains(keys(aws_nat_gateway.nat_gateway), cidr)]
  description = "List of NAT gateways private IPs."
}

# Provide the AWS account ID as a shortcut when the module is used as a Terragrunt dependency
# E.g. for a cross-account VPC peering we can use: accepter_owner_id = dependency.other_vpc.outputs.aws_account_id
data "aws_caller_identity" "current" {}
output "aws_account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS account ID where the VPC is created."
}

# Provide the AWS region as a shortcut when the module is used as a Terragrunt dependency
# E.g. for a cross-region VPC peering we can use: accepter_region = dependency.accepter_vpc.outputs.aws_region
data "aws_region" "current" {}
output "aws_region" {
  value       = data.aws_region.current.name
  description = "AWS region name where the VPC is created."
}

output "vpc_cidr_policy_arn" {
  value       = one(aws_iam_policy.vpc_cidr_restriction[*].arn)
  description = "ARN of created VPC policy. If create_vpc_policy not set, defaults to null."
}

output "private_subnets" {
  value = { for cidr, az in local.private_subnets : cidr => merge(var.subnets[cidr], {
    subnet_id = aws_subnet.subnet[cidr].id
    arn       = aws_subnet.subnet[cidr].arn
  }) if contains(keys(aws_subnet.subnet), cidr) }
  description = "Full private subnets data."
}

output "private_extended_subnets" {
  value = { for cidr, az in local.private_extended_subnets : cidr => merge(var.subnets[cidr], {
    subnet_id = aws_subnet.subnet[cidr].id
    arn       = aws_subnet.subnet[cidr].arn
  }) if contains(keys(aws_subnet.subnet), cidr) }
  description = "Full private extended subnets data."
}

output "public_subnets" {
  value = { for cidr, az in local.public_subnets : cidr => merge(var.subnets[cidr], {
    subnet_id = aws_subnet.subnet[cidr].id
    arn       = aws_subnet.subnet[cidr].arn
  }) if contains(keys(aws_subnet.subnet), cidr) }
  description = "Full public subnet data."
}

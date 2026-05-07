locals {
  endpoint_subnets_by_az_id = { for subnet in aws_subnet.subnet : subnet.availability_zone_id => subnet.id... if contains(local.endpoint_subnet_ids, subnet.id) }
  # This is a pretty ugly hack to ensure that in us-east-1 we only create mappings in subnets that share a common AZ ID as the security account
  use1_endpoint_subnet_ids = [for az_id, id in local.endpoint_subnets_by_az_id : id if contains(["use1-az1", "use1-az2", "use1-az4"], az_id)]
  # The strange use of the ternary operator is to avoid Terraform from complaining about differing length tuples for the true/false results
  wazuh_endpoint_subnet_ids = flatten([local.use1_endpoint_subnet_ids, local.endpoint_subnet_ids][data.aws_region.current.name == "us-east-1" ? 0 : 1])
}

module "agent_endpoint" {
  count = var.enable_wazuh_endpoint ? 1 : 0

  source = "../../security/wazuh-endpoint"

  environment = "prod"

  vpc_id      = aws_vpc.vpc.id
  subnet_ids  = local.wazuh_endpoint_subnet_ids
  cidr_blocks = [aws_vpc.vpc.cidr_block]

  endpoint_service_name = var.wazuh_endpoint_service_name

  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet
  ]
}

# AWS Service endpoints
module "aws_service_endpoint" {
  for_each = var.aws_service_endpoints

  source = "../vpc-endpoint"

  name = "${var.vpc_name}-${each.key}"

  subnet_ids = local.endpoint_subnet_ids

  private_dns_enabled = true

  service_name = each.value
  vpc_id       = aws_vpc.vpc.id
  tags         = var.tags
}

# Datadog private endpoints
module "datadog_endpoint" {
  # Datadog endpoints can only be enabled this way in us-east-1
  for_each = var.enable_datadog_endpoints && data.aws_region.current.name == "us-east-1" ? local.datadog_endpoints : {}

  source = "../../aws/vpc-endpoint"

  name         = "${var.vpc_name}-datadog-${each.key}"
  service_name = each.value

  vpc_id     = aws_vpc.vpc.id
  subnet_ids = local.endpoint_subnet_ids

  private_dns_enabled = true

  endpoint_type = "Interface"

  tags = var.tags
}

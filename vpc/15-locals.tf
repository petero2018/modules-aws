locals {
  public_subnets           = { for cidr_range, subnet in var.subnets : cidr_range => subnet.az if subnet.is_public }
  private_extended_subnets = { for cidr_range, subnet in var.subnets : cidr_range => subnet.az if !subnet.is_public && try(subnet.extra_tags.extended, "false") == "true" }
  private_subnets          = { for cidr_range, subnet in var.subnets : cidr_range => subnet.az if !subnet.is_public }

  public_azs = { for cidr_range, subnet in var.subnets : subnet.az => cidr_range... if subnet.is_public }

  endpoint_subnet_ids = [for cidr_range, subnet in var.subnets : aws_subnet.subnet[cidr_range].id if subnet.use_for_endpoints]

  datadog_endpoints = {
    "logs-agent-intake" = "com.amazonaws.vpce.us-east-1.vpce-svc-025a56b9187ac1f63"
    "logs-user-intake"  = "com.amazonaws.vpce.us-east-1.vpce-svc-0e36256cb6172439d"
    "api"               = "com.amazonaws.vpce.us-east-1.vpce-svc-064ea718f8d0ead77"
    "metrics"           = "com.amazonaws.vpce.us-east-1.vpce-svc-09a8006e245d1e7b8"
    "containers"        = "com.amazonaws.vpce.us-east-1.vpce-svc-0ad5fb9e71f85fe99"
    "process"           = "com.amazonaws.vpce.us-east-1.vpce-svc-0ed1f789ac6b0bde1"
    "profiling"         = "com.amazonaws.vpce.us-east-1.vpce-svc-022ae36a7b2472029"
    "traces"            = "com.amazonaws.vpce.us-east-1.vpce-svc-0355bb1880dfa09c2"
  }
}

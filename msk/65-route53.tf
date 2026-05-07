data "aws_msk_broker_nodes" "nodes" {
  cluster_arn = aws_msk_cluster.cluster.arn
}

data "aws_route53_zone" "zone" {
  count = var.custom_broker_endpoint_enabled ? 1 : 0

  name = var.custom_broker_endpoint_zone
}

locals {
  broker_endpoints = flatten([for node_info in data.aws_msk_broker_nodes.nodes.node_info_list : node_info.endpoints])
}

resource "aws_route53_record" "broker_endpoint" {
  count = var.custom_broker_endpoint_enabled ? var.broker_per_zone * length(local.subnet_ids) : 0

  zone_id = data.aws_route53_zone.zone[0].id
  name    = "broker-${count.index + 1}.${var.custom_broker_endpoint}"
  type    = "CNAME"
  ttl     = 300
  records = [local.broker_endpoints[count.index]]
}

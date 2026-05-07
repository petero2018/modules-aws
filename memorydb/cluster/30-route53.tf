resource "aws_route53_record" "record" {
  count = var.route53_zone_id != null ? 1 : 0

  name    = var.memorydb_name
  records = [aws_memorydb_cluster.memorydb_cluster.cluster_endpoint[0].address]
  ttl     = 300
  type    = "CNAME"
  zone_id = var.route53_zone_id
}

resource "aws_route53_record" "custom" {
  count = var.dns_name != null && var.route53_zone_id != null ? 1 : 0

  name    = var.memorydb_name
  records = [aws_memorydb_cluster.memorydb_cluster.cluster_endpoint[0].address]
  ttl     = 300
  type    = "CNAME"
  zone_id = var.route53_zone_id
}

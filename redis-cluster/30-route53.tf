resource "aws_route53_record" "record" {
  count = var.route53_zone_id != null ? 1 : 0

  name    = var.redis_name
  records = [aws_elasticache_cluster.redis_cluster.cache_nodes[0].address]
  ttl     = 300
  type    = "CNAME"
  zone_id = var.route53_zone_id
}

resource "aws_route53_record" "custom" {
  count = var.dns_name != null && var.route53_zone_id != null ? 1 : 0

  name    = var.dns_name
  records = [aws_elasticache_cluster.redis_cluster.cache_nodes[0].address]
  ttl     = 300
  type    = "CNAME"
  zone_id = var.route53_zone_id
}

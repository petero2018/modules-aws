resource "aws_route53_record" "custom_endpoint" {
  count = var.custom_endpoint_enabled ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].id
  name    = var.custom_endpoint
  type    = "CNAME"
  ttl     = 300
  records = [aws_opensearch_domain.es.endpoint]
}

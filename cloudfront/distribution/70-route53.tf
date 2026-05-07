resource "aws_route53_record" "cloudfront_readonly" {
  for_each = var.route53_zone_id != null ? toset(var.domain_names) : toset([])

  name    = each.key
  type    = "A"
  zone_id = var.route53_zone_id

  alias {
    evaluate_target_health = true

    name    = aws_cloudfront_distribution.distribution.domain_name
    zone_id = aws_cloudfront_distribution.distribution.hosted_zone_id
  }
}

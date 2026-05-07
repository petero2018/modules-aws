output "zone_arn" {
  value       = aws_route53_zone.zone.arn
  description = "ARN of the Route53 zone."
}

output "zone_id" {
  value       = aws_route53_zone.zone.zone_id
  description = "Route53 zone ID."
}

output "name_servers" {
  value       = aws_route53_zone.zone.name_servers
  description = "List of the zone name servers."
}

output "domain_name" {
  value       = var.name
  description = "Zone domain name (for convenience)."
}

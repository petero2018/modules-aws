output "route53_zone_id" {
  value       = data.aws_route53_zone.selected.zone_id
  description = "ID of the Route53 zone used to valudate certificates."
}

output "hostnames" {
  value       = var.hostnames
  description = "<namespace>:<hostname> records to issue ACM certificates for."
}

output "acm_certificate_arns" {
  value       = { for k, _ in var.hostnames : k => module.certificate[k].arn }
  description = "A map of <hostname>:<ACM certificate> values."
}

locals {
  custom_endpoint_certificate_not_defined = var.custom_endpoint_certificate_arn == null || var.custom_endpoint_certificate_arn == ""
  create_acm_certificate                  = var.custom_endpoint_enabled && local.custom_endpoint_certificate_not_defined
}

module "certificate" {
  source = "git@github.com:powise/terraform-modules//aws/acm?ref=aws-acm-0.0.2"

  count = local.create_acm_certificate ? 1 : 0

  dns_zone_id = data.aws_route53_zone.zone[0].zone_id

  domain_name = var.custom_endpoint

  tags = var.tags
}

locals {
  certificate_arn = var.custom_endpoint_enabled ? coalesce(var.custom_endpoint_certificate_arn, try(module.certificate[0].arn, null)) : null
}

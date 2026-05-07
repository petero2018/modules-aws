data "aws_route53_zone" "selected" {
  name = var.route53_zone
}

module "certificate" {
  for_each = var.hostnames

  source  = "jpamies/certificate/aws"
  version = "~>1.0"

  dns_zone_id = data.aws_route53_zone.selected.zone_id

  domain_name               = contains(var.main_namespaces, each.key) ? "main.${each.value}" : each.value
  subject_alternative_names = contains(var.main_namespaces, each.key) ? null : ["*.${each.value}"]

  tags = {
    "Environment" = var.environment
    "Namespace"   = each.key
  }
}

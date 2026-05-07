locals {
  tags = {
    impact  = "high"
    service = "wafv2"
    team    = "security"
  }

  regional_suffix   = var.create_regional_ip_lists ? "-regional-${data.aws_region.current.name}" : ""
  cloudfront_suffix = var.create_cloudfront_ip_lists ? "-cloudfront" : ""
  name_suffix       = "${local.regional_suffix}${local.cloudfront_suffix}"

  lambda_function_name = "WAF-Search-Engines${local.name_suffix}"
}

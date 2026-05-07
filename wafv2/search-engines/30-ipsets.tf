resource "aws_wafv2_ip_set" "search_engines_ipv4_regional" {
  count = var.create_regional_ip_lists ? 1 : 0

  name        = "known-search-engines-ipv4"
  description = "A list of IPv4 addresses of known search engines"

  ip_address_version = "IPV4"
  scope              = "REGIONAL"

  # Addresses are populated by the lambda function
  addresses = []

  tags = local.tags

  lifecycle {
    ignore_changes = [
      addresses
    ]
  }
}

resource "aws_wafv2_ip_set" "search_engines_ipv6_regional" {
  count = var.create_regional_ip_lists ? 1 : 0

  name        = "known-search-engines-ipv6"
  description = "A list of IPv6 addresses of known search engines"

  ip_address_version = "IPV6"
  scope              = "REGIONAL"

  # Addresses are populated by the lambda function
  addresses = []

  tags = local.tags

  lifecycle {
    ignore_changes = [
      addresses
    ]
  }
}

resource "aws_wafv2_ip_set" "search_engines_ipv4_cloudfront" {
  count = var.create_cloudfront_ip_lists ? 1 : 0

  name        = "known-search-engines-ipv4"
  description = "A list of IPv4 addresses of known search engines"

  ip_address_version = "IPV4"
  scope              = "CLOUDFRONT"

  # Addresses are populated by the lambda function
  addresses = []

  tags = local.tags

  lifecycle {
    ignore_changes = [
      addresses
    ]

    precondition {
      condition     = data.aws_region.current.name == "us-east-1"
      error_message = "Cloudfront resources must be created in us-east-1."
    }
  }
}

resource "aws_wafv2_ip_set" "search_engines_ipv6_cloudfront" {
  count = var.create_cloudfront_ip_lists ? 1 : 0

  name        = "known-search-engines-ipv6"
  description = "A list of IPv6 addresses of known search engines"

  ip_address_version = "IPV6"
  scope              = "CLOUDFRONT"

  # Addresses are populated by the lambda function
  addresses = []

  tags = local.tags

  lifecycle {
    ignore_changes = [
      addresses
    ]

    precondition {
      condition     = data.aws_region.current.name == "us-east-1"
      error_message = "Cloudfront resources must be created in us-east-1."
    }
  }
}

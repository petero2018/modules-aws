resource "aws_cloudfront_cache_policy" "custom" {
  for_each = var.custom_cache_policies

  name = each.key

  comment     = each.value.comment
  default_ttl = each.value.default_ttl
  max_ttl     = each.value.max_ttl
  min_ttl     = each.value.min_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = each.value.cookies.behavior
      dynamic "cookies" {
        for_each = each.value.cookies.list != null ? toset([1]) : toset([])
        content {
          items = each.value.cookies.list
        }
      }
    }

    headers_config {
      header_behavior = each.value.headers.behavior
      dynamic "headers" {
        for_each = each.value.headers.list != null ? toset([1]) : toset([])
        content {
          items = each.value.headers.list
        }
      }
    }

    query_strings_config {
      query_string_behavior = each.value.query_strings.behavior
      dynamic "query_strings" {
        for_each = each.value.query_strings.list != null ? toset([1]) : toset([])
        content {
          items = each.value.query_strings.list
        }
      }
    }
  }
}

resource "aws_cloudfront_distribution" "distribution" {
  #checkov:skip=CKV_AWS_310: Origin failover is overkill for simple distributions
  #checkov:skip=CKV_AWS_305: Default objects don't always make sense for custom origins
  #checkov:skip=CKV2_AWS_47: WAF settings must be enforced at the WAF level
  #checkov:skip=CKV2_AWS_32: Response headers policy is not needed for simple cases

  comment = var.description
  aliases = var.domain_names

  http_version = var.http_version

  web_acl_id = var.web_acl_id

  enabled         = true
  is_ipv6_enabled = true

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  dynamic "origin" {
    for_each = var.custom_origins
    content {
      origin_id   = origin.key
      domain_name = origin.value.domain_name
      custom_origin_config {
        http_port                = origin.value.http_port
        https_port               = origin.value.https_port
        origin_protocol_policy   = origin.value.protocol_policy
        origin_ssl_protocols     = origin.value.ssl_protocols
        origin_keepalive_timeout = origin.value.keepalive_timeout
        origin_read_timeout      = origin.value.read_timeout
      }
    }
  }

  default_cache_behavior {
    target_origin_id = var.default_behavior.origin

    allowed_methods = var.default_behavior.allowed_methods
    cached_methods  = var.default_behavior.cached_methods

    compress = var.default_behavior.compress

    cache_policy_id = startswith(var.default_behavior.cache_policy, "Managed-") ? data.aws_cloudfront_cache_policy.managed[var.default_behavior.cache_policy].id : aws_cloudfront_cache_policy.custom[var.default_behavior.cache_policy].id

    viewer_protocol_policy = var.default_behavior.viewer_protocol_policy
  }

  logging_config { # Access logging is mandatory
    bucket = var.logging_bucket_fqdn
    prefix = var.logging_prefix
  }

  tags = var.tags
}

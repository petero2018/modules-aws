locals {
  s3_origin_id = "S3Origin/${var.bucket_name}"
}

resource "aws_cloudfront_origin_access_control" "s3" {
  count = var.enable_cloudfront ? 1 : 0

  name        = "s3-${var.bucket_name}"
  description = "Origin access control for bucket ${var.bucket_name}"

  origin_access_control_origin_type = "s3"

  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "readonly" {
  #checkov:skip=CKV2_AWS_47: WAF is managed in a different module
  #checkov:skip=CKV2_AWS_32: Response headers policy is not needed for simple cases
  #checkov:skip=CKV2_AWS_46: We don't need S3 Origin Access when using Website origin

  count = var.enable_cloudfront ? 1 : 0

  aliases = var.cloudfront_domains
  comment = "S3 bucket: ${var.bucket_name}"

  dynamic "origin" { # Regular S3 CloudFront origin
    for_each = var.website_configuration == null ? [1] : []
    content {
      domain_name              = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.s3[0].id
      origin_id                = local.s3_origin_id
    }
  }

  dynamic "origin" { # S3 Website CloudFront origin
    for_each = var.website_configuration == null ? [] : [1]
    content {
      connection_attempts = 3
      connection_timeout  = 10
      domain_name         = aws_s3_bucket_website_configuration.website_config[0].website_endpoint
      origin_id           = local.s3_origin_id
      custom_origin_config {
        http_port                = 80
        https_port               = 443
        origin_keepalive_timeout = 5
        origin_protocol_policy   = "http-only" # We must use this for S3 Website hosting
        origin_read_timeout      = 30
        origin_ssl_protocols = [
          "SSLv3",
          "TLSv1",
          "TLSv1.1",
          "TLSv1.2",
        ]
      }
    }
  }

  dynamic "origin" {
    for_each = var.cloudfront_custom_origins

    content {
      origin_id           = origin.key
      connection_attempts = origin.value.connection_attempts
      connection_timeout  = origin.value.connection_timeout
      domain_name         = origin.value.domain_name

      custom_origin_config {
        https_port             = origin.value.https_port
        http_port              = origin.value.http_port
        origin_protocol_policy = origin.value.origin_protocol_policy
        origin_ssl_protocols   = origin.value.origin_ssl_protocols
      }
    }
  }

  default_cache_behavior {
    allowed_methods = var.cloudfront_default_cache_behavior_options.allowed_methods
    cached_methods  = var.cloudfront_default_cache_behavior_options.cached_methods
    compress        = "true"
    default_ttl     = var.cloudfront_default_cache_behavior_options.default_ttl

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "31536000"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    # response_headers_policy_id = aws_cloudfront_response_headers_policy.readonly.id
  }

  dynamic "ordered_cache_behavior" {
    for_each = { for index, cache_behavior in var.cloudfront_cache_behaviors : index => cache_behavior }

    content {
      allowed_methods = ordered_cache_behavior.value.allowed_methods
      cached_methods  = ordered_cache_behavior.value.cached_methods

      target_origin_id           = ordered_cache_behavior.value.target_origin_id
      path_pattern               = ordered_cache_behavior.value.path_pattern
      max_ttl                    = ordered_cache_behavior.value.max_ttl
      min_ttl                    = ordered_cache_behavior.value.min_ttl
      smooth_streaming           = "false"
      viewer_protocol_policy     = ordered_cache_behavior.value.viewer_protocol_policy
      response_headers_policy_id = ordered_cache_behavior.value.response_headers_policy != null ? aws_cloudfront_response_headers_policy.response_headers_policy[ordered_cache_behavior.key].id : null

      forwarded_values {
        cookies {
          forward = "none"
        }

        headers      = ordered_cache_behavior.value.forwarded_headers
        query_string = "false"
      }
    }
  }

  enabled         = "true"
  http_version    = "http2and3"
  is_ipv6_enabled = var.cloudfront_ipv6_enabled

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn      = var.cloudfront_certificate_arn
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
  }

  web_acl_id = var.cloudfront_web_acl_arn

  tags = var.tags
}

resource "aws_cloudfront_response_headers_policy" "response_headers_policy" {
  #checkov:skip=CKV_AWS_259:We want this to be fully customizable

  for_each = { for index, cache_behavior in var.cloudfront_cache_behaviors : index => cache_behavior if cache_behavior.response_headers_policy != null }

  name    = each.value.response_headers_policy.name
  comment = each.value.response_headers_policy.comment

  dynamic "custom_headers_config" {
    for_each = length(each.value.response_headers_policy.custom_headers_config) > 0 ? [1] : []
    content {
      dynamic "items" {
        for_each = each.value.response_headers_policy.custom_headers_config
        content {
          header   = items.key
          override = items.value.override
          value    = items.value.value
        }
      }
    }
  }

  dynamic "cors_config" {
    for_each = var.cloudfront_cors_config != null ? [var.cloudfront_cors_config] : []
    content {
      origin_override = var.cloudfront_cors_config.origin_override

      access_control_allow_credentials = var.cloudfront_cors_config.access_control_allow_credentials

      access_control_allow_headers {
        items = var.cloudfront_cors_config.access_control_allow_headers
      }
      access_control_allow_methods {
        items = var.cloudfront_cors_config.access_control_allow_methods
      }
      access_control_allow_origins {
        items = var.cloudfront_cors_config.access_control_allow_origins
      }
    }
  }
}

resource "aws_route53_record" "cloudfront_readonly" {
  for_each = var.cloudfront_route53_zone_id != null ? toset(var.cloudfront_domains) : toset([])

  name    = each.key
  type    = "A"
  zone_id = var.cloudfront_route53_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.readonly[0].domain_name
    zone_id                = aws_cloudfront_distribution.readonly[0].hosted_zone_id
  }
}

resource "aws_wafv2_rule_group" "ip_lists_v2" {
  name        = "IP_ListsV2"
  description = "Rule group containing allowlist and blocklist rules."
  scope       = var.scope
  capacity    = 50 # Allow some overhead for expansion

  ##################################################
  # Allowed IPs
  ##################################################

  rule { # 2 or more WCU depending on supported IP versions
    name     = "ConfigStaticAllowed"
    priority = 0

    action {
      allow {}
    }

    statement {
      or_statement {
        dynamic "statement" {
          for_each = toset(local.ip_versions)
          iterator = version

          content {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.static_allowed_ips[version.value].arn
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ConfigStaticAllowed"
      sampled_requests_enabled   = true
    }
  }

  rule { # 2 or more WCU depending on supported IP versions
    name     = "ConfigDynamicAllowed"
    priority = 1

    action {
      allow {}
    }

    statement {
      or_statement {
        dynamic "statement" {
          for_each = toset(local.ip_versions)
          iterator = version

          content {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.dynamic_allowed_ips[version.value].arn
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ConfigDynamicAllowed"
      sampled_requests_enabled   = true
    }
  }

  ##################################################
  # Blocked IPs
  ##################################################

  rule { # 1 WCU
    name     = "${aws_wafv2_ip_set.dynamic_blocked_ips["IPV4"].name}_Source"
    priority = 2

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.dynamic_blocked_ips["IPV4"].arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${aws_wafv2_ip_set.dynamic_blocked_ips["IPV4"].name}_Source"
      sampled_requests_enabled   = true
    }
  }

  rule { # 1 WCU
    name     = "${aws_wafv2_ip_set.dynamic_blocked_ips["IPV6"].name}_Source"
    priority = 3

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.dynamic_blocked_ips["IPV6"].arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${aws_wafv2_ip_set.dynamic_blocked_ips["IPV6"].name}_Source"
      sampled_requests_enabled   = true
    }
  }
  rule { # 5 WCU
    name     = "${aws_wafv2_ip_set.dynamic_blocked_ips["IPV4"].name}_Header"
    priority = 4

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.dynamic_blocked_ips["IPV4"].arn
        ip_set_forwarded_ip_config {
          fallback_behavior = "NO_MATCH"
          header_name       = "X-Forwarded-For"
          position          = "ANY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${aws_wafv2_ip_set.dynamic_blocked_ips["IPV4"].name}_Header"
      sampled_requests_enabled   = true
    }
  }

  rule { # 5 WCU
    name     = "${aws_wafv2_ip_set.dynamic_blocked_ips["IPV6"].name}_Header"
    priority = 5

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.dynamic_blocked_ips["IPV6"].arn
        ip_set_forwarded_ip_config {
          fallback_behavior = "NO_MATCH"
          header_name       = "X-Forwarded-For"
          position          = "ANY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${aws_wafv2_ip_set.dynamic_blocked_ips["IPV6"].name}_Header"
      sampled_requests_enabled   = true
    }
  }
  rule { # 1 WCU
    name     = "${aws_wafv2_ip_set.static_blocked_ips["IPV4"].name}_Source"
    priority = 6

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.static_blocked_ips["IPV4"].arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${aws_wafv2_ip_set.static_blocked_ips["IPV4"].name}_Source"
      sampled_requests_enabled   = true
    }
  }

  rule { # 1 WCU
    name     = "${aws_wafv2_ip_set.static_blocked_ips["IPV6"].name}_Source"
    priority = 7

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.static_blocked_ips["IPV6"].arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${aws_wafv2_ip_set.static_blocked_ips["IPV6"].name}_Source"
      sampled_requests_enabled   = true
    }
  }
  rule { # 5 WCU
    name     = "${aws_wafv2_ip_set.static_blocked_ips["IPV4"].name}_Header"
    priority = 8

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.static_blocked_ips["IPV4"].arn
        ip_set_forwarded_ip_config {
          fallback_behavior = "NO_MATCH"
          header_name       = "X-Forwarded-For"
          position          = "ANY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${aws_wafv2_ip_set.static_blocked_ips["IPV4"].name}_Header"
      sampled_requests_enabled   = true
    }
  }

  rule { # 5 WCU
    name     = "${aws_wafv2_ip_set.static_blocked_ips["IPV6"].name}_Header"
    priority = 9

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.static_blocked_ips["IPV6"].arn
        ip_set_forwarded_ip_config {
          fallback_behavior = "NO_MATCH"
          header_name       = "X-Forwarded-For"
          position          = "ANY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${aws_wafv2_ip_set.static_blocked_ips["IPV6"].name}_Header"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "IP_Lists"
    sampled_requests_enabled   = false
  }

  tags = var.tags
}

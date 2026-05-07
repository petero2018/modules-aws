resource "aws_lb_listener_rule" "redirect" {
  listener_arn = var.listener_arn
  priority     = var.priority

  lifecycle {
    precondition {
      condition = length(concat(
        var.condition_hosts,
        var.condition_headers,
        var.condition_paths,
        var.condition_source_ips,
        var.condition_request_methods,
        flatten([for cqs in var.condition_query_strings : values(cqs)])
      )) <= 5
      error_message = "Redirect rules cannot have more than 5 conditions."
    }
  }

  action {
    type = "redirect"

    redirect {
      host        = var.target_host
      path        = var.target_path
      port        = var.target_port
      protocol    = var.target_protocol
      query       = var.target_query
      status_code = var.is_permanent ? "HTTP_301" : "HTTP_302"
    }
  }

  # header conditions - multiple conditions allowed
  dynamic "condition" {
    for_each = var.condition_headers

    content {
      http_header {
        http_header_name = split("=", condition.value)[0]
        values           = split("=", condition.value)[1]
      }
    }
  }

  # query string conditions - multiple conditions allowed
  dynamic "condition" {
    for_each = var.condition_query_strings

    content {
      dynamic "query_string" {
        for_each = condition.value

        content {
          key   = query_string.key == "" ? null : query_string.key
          value = query_string.value
        }
      }
    }
  }

  # host header - 0 or 1 conditions allowed
  dynamic "condition" {
    for_each = length(var.condition_hosts) > 0 ? ["host_header"] : []

    content {
      host_header {
        values = var.condition_hosts
      }
    }
  }

  # source IP - 0 or 1 conditions allowed
  dynamic "condition" {
    for_each = length(var.condition_source_ips) > 0 ? ["source_ip"] : []

    content {
      source_ip {
        values = var.condition_source_ips
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.condition_paths) > 0 ? ["condition_paths"] : []

    content {
      path_pattern {
        values = var.condition_paths
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.condition_request_methods) > 0 ? ["condition_request_methods"] : []

    content {
      http_request_method {
        values = var.condition_request_methods
      }
    }
  }

  tags = var.tags
}

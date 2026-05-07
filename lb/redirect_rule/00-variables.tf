variable "listener_arn" {
  type = string

  description = "The ALB Listener with which the redirect rule will be associated"
}

variable "priority" {
  type = number

  description = "The priority of the redirect rule. Lower numbers are processed first."
}

variable "is_permanent" {
  type    = bool
  default = true

  description = "If true, the redirect will use the 301 status code. Otherwise, 302 will be used."
}

# Conditions

variable "condition_hosts" {
  type     = list(string)
  default  = []
  nullable = false

  description = "A list of hosts which, if matched, will cause the redirect."
}

variable "condition_headers" {
  type     = list(string)
  default  = []
  nullable = false

  description = "A list of headers which, if matched, will cause the redirect."
}

variable "condition_paths" {
  type     = list(string)
  default  = []
  nullable = false

  description = "A list of paths (excluding query strings) which, if matched, will cause the redirect."

}

variable "condition_query_strings" {
  type     = list(map(string))
  default  = []
  nullable = false

  description = "A list of query strings. The key can be an empty string which will mean only the value is considered. Each map will be AND'd with each other while key, value pairs within each map will be OR'd together"
}

variable "condition_request_methods" {
  type     = list(string)
  default  = []
  nullable = false

  description = "A list of request methods which, if matched, will cause the redirect."
}

variable "condition_source_ips" {
  type     = list(string)
  default  = []
  nullable = false

  description = "A list of IPv4 or IPv6 IPs in CIDR notation which, if matched, will cause the redirect."

  validation {
    condition = alltrue([
      for ip in var.condition_source_ips : length(split("/", ip)) == 2
    ])
    error_message = "Source IPs must be in CIDR notation format"
  }
}

# Target Config

variable "target_host" {
  type     = string
  default  = "#{host}"
  nullable = false

  description = "The destination host to which the client will be redirected."
}

variable "target_path" {
  type     = string
  default  = "/#{path}"
  nullable = false

  description = "The destination path to which the client will be redirected."

  validation {
    condition     = startswith(var.target_path, "/")
    error_message = "Path must contain the leading forward-slash."
  }
}

variable "target_port" {
  type     = string
  default  = "#{port}"
  nullable = false

  description = "The destination target_port to which the client will be redirected."

  validation {
    condition     = try(var.target_port >= 1 && var.target_port <= 65535, var.target_port == "#{port}")
    error_message = "Port must be between 1 and 65535 or #{port}."
  }
}

variable "target_query" {
  type     = string
  default  = "#{query}"
  nullable = false

  description = "The destination query string parameters included in the redirect."

  validation {
    condition     = !startswith(var.target_query, "?")
    error_message = "Query should not include the leading '?'"
  }
}

variable "target_protocol" {
  type     = string
  default  = "#{protocol}"
  nullable = false

  description = "The destination protocol used for the redirect."

  validation {
    condition     = contains(["HTTPS", "HTTP", "#{protocol}"], var.target_protocol)
    error_message = "Target protocol should be one of ['HTTPS', 'HTTP', '#{protocol}']"
  }
}

variable "tags" {
  description = "Tags to be applied to AWS resources."
  type        = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}

variable "environment" {
  type = string

  description = "Deploy environment (\"dev\", \"prod\" or \"tools\")."

  validation {
    condition     = contains(["dev", "prod", "tools"], var.environment)
    error_message = "Illegal environment name."
  }
}

variable "route53_zone" {
  type = string

  description = "Name of the Route53 zone to use for certificate DNS validation."
}

variable "hostnames" {
  type = map(string)

  description = "<namespace>:<hostname> records to issue ACM certificates for."
}

variable "main_namespaces" {
  type = list(string)

  default     = []
  description = "Namespaces to deploy our prod/dev applications and route traffic into via external \"blue/green\" proxy."
}

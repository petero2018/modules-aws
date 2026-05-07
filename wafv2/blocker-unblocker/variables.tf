variable "block_ipset_arns_ipv4" {
  type        = list(string)
  description = "IP Set(s) ARN(s) from the WAF(s) where IPs will be blocked. They will be unblocked automatically after a set time."
}

variable "block_ipset_arns_ipv6" {
  type        = list(string)
  description = "IP Set(s) ARN(s) from the WAF(s) where IPs will be blocked. They will be unblocked automatically after a set time."
}

variable "allow_ipset_arns_ipv4" {
  type        = list(string)
  description = "IP Set(s) ARN(s) from the WAF(s) where IPs will be allowed."
}

variable "allow_ipset_arns_ipv6" {
  type        = list(string)
  description = "IP Set(s) ARN(s) from the WAF(s) where IPs will be allowed."
}

variable "aws_account_id" {
  type        = string
  description = "12-digit AWS account ID where the WAF is"
}

variable "aws_region" {
  type        = string
  description = "Region in which to deploy the Lambdas. This already decided by the AWS provider, but it is required in this case to prevent a circular dependency"
}

variable "ip_whitelist_ipv4" {
  type        = list(string)
  description = "List of IPs that are never blocked"
  default     = []
}

variable "ip_whitelist_ipv6" {
  type        = list(string)
  description = "List of IPs that are never blocked"
  default     = []
}

variable "enable_unblocker_schedule" {
  type        = bool
  default     = true
  description = "Whether the unblocker should be automatically run periodically."
}

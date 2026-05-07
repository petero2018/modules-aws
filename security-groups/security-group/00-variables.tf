variable "name" {
  type        = string
  description = "Name of the created Security Group."
}

variable "vpc_id" {
  type = string

  description = "ID of the VPC to deploy Security Group to."

  validation {
    condition     = length(var.vpc_id) >= 12 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "Need to provide a valid ID of the VPC!"
  }
}

variable "port" {
  type        = number
  description = "Port to allow traffic on."
}

variable "protocol" {
  type        = string
  description = "IP protocol to allow. Defaults to \"tcp\"."
  default     = "tcp"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "Allow these CIDR blocks."
}

variable "ipv6_cidr_blocks" {
  type = list(string)

  default     = []
  description = "Allow these IPv6 CIDR blocks."
}

variable "description" {
  type        = string
  description = "description to give the Security Group."
  default     = "Allow access from given IPs to the given Port."
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

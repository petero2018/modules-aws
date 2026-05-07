################################################################################
# VPC Endpoint
################################################################################

variable "name" {
  type = string

  default     = null
  description = "VPC Endpoint name. By default the service name."
}

variable "service_name" {
  type = string

  description = "The service name. FQDN if is not an AWS service."
}

variable "endpoint_type" {
  type = string

  default     = "Interface"
  description = "The VPC endpoint type: Gateway, GatewayLoadBalancer, or Interface."

  validation {
    condition     = contains(["Gateway", "GatewayLoadBalancer", "Interface"], var.endpoint_type)
    error_message = "Please provide a valid endpoint type: Gateway, GatewayLoadBalancer, or Interface."
  }
}

variable "vpc_id" {
  type = string

  description = "Required ID of the VPC in which the endpoint will be used."
}

variable "extra_cidr" {
  type = list(string)

  default     = []
  description = "Additional CIDR range to be specified in the security group."
}

variable "route_table_ids" {
  type = list(string)

  default     = null
  description = "One or more route table IDs. Applicable for endpoints of type Gateway. By default all VPC tables."
}

variable "subnet_ids" {
  type = list(string)

  default     = null
  description = "The ID of one or more subnets in which to create a network interface for the endpoint. By default the private ones."
}

variable "security_group_ids" {
  type = list(string)

  default     = null
  description = "The ID of one or more security groups to associate with the network interface. By default creates one for access in the VPC."
}

################################################################################
# DNS
################################################################################

variable "private_dns_enabled" {
  type = bool

  default     = false
  description = "Whether or not the VPC is associated with a private hosted zone."
}

################################################################################
# Endpoint Policy
################################################################################

variable "policy" {
  type = string

  default     = null
  description = "A policy to attach to the endpoint that controls access to the service. Defaults to full access."
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

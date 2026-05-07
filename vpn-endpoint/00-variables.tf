################################################################################
# VPN Options
################################################################################

variable "name" {
  type        = string
  description = "VPN Endpoint name."
}

variable "self_service_portal" {
  type        = string
  default     = "disabled"
  description = "Indicates whether the self-service portal is enabled."
}

variable "client_cidr_block" {
  type        = string
  description = "CIDR Block used by the VPN Clients."
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "List of DNS servers used by VPN Client. By default the VPC DNS Server."
}

variable "split_tunnel" {
  type        = bool
  default     = false
  description = "Indicates whether split-tunnel is enabled on VPN endpoint."
}

################################################################################
# VPC
################################################################################

variable "vpc_id" {
  type        = string
  description = "The id of the VPC for VPN."
}

variable "private_subnet_tags" {
  type = map(string)
  default = {
    tier = "private"
  }
  description = "Tags to be used to identify private subnets."
}

################################################################################
# Routes
################################################################################

variable "vpn_routes" {
  type = map(object({
    cidr        = string
    description = string
  }))
  default     = {}
  description = "CIDRs to route to the VPN."
}

variable "authorization_rules_all" {
  type        = map(string)
  default     = {}
  description = "CIDRs authorized to all users. key: name, value: CIDR."
}

variable "authorization_rules" {
  type = map(object({
    cidr   = string       # CIDR of the peering
    groups = list(string) # Allowed OKTA groups with access to this peering
  }))
  default     = {}
  description = "Routes to authorize to OKTA groups"
}

################################################################################
# Logs
################################################################################

variable "logs_retention" {
  type        = number
  default     = 365
  description = "Logs retention."
}

################################################################################
# Certificate
################################################################################

variable "certificate_domain" {
  type        = string
  default     = "*.powise.tf"
  description = "Certificate to use on the VPN endpoint."
}

################################################################################
# OKTA Integration
################################################################################

variable "okta_metadata_document" {
  type        = string
  description = "OKTA Metadata Document"
}

variable "saml_provider_name" {
  type        = string
  description = "Name of IAM SAML Provider"
  default     = "okta"
}

################################################################################
# AWS Service
################################################################################

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

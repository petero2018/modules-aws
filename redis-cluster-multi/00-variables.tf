variable "open_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to open access from."
}

variable "clusters" {
  type = map(object({
    instance_type       = string,
    version             = string,
    parameter_group     = optional(string, "default"),
    tag_team            = string,
    tag_service         = string,
    tag_impact          = string,
    security_group_name = optional(string),
    dns_name            = optional(string, null)
  }))
  description = "Configuration of the clusters."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the clusters in."
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. 'tfprod')."
}

variable "tags" {
  type        = map(string)
  default     = { "team" = "product-infrastructure", "impact" = "high", "service" = "redis" }
  description = "Tags on AWS Backup related resources."
}

variable "private_subnets_ids" {
  type        = list(string)
  description = "List of private subnets IDs."
}

variable "subnet_group_name" {
  type        = string
  default     = null
  description = "Specify directly the subnet group name."
}

variable "upgrade_old_instance_types" {
  type        = bool
  default     = false
  description = "Override node_type with a newer instance type if possible (e.g. from m3 to m5)."
}

variable "route53_zone_id" {
  type        = string
  default     = null
  description = "Route53 zone ID to create records in."
}

variable "create_resources" {
  type        = bool
  default     = true
  description = "Enable to actually create resources."
}

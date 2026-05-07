variable "redis_name" {
  type        = string
  description = "Name of the redis cluster."
}

variable "redis_version" {
  type        = string
  description = "Avalable values: 6.0.5, 3.2.4, 2.8.24, 2.8.33, 2.8.22, 2.8.21, 2.8.19, 2.8.6"
}

variable "node_type" {
  type        = string
  description = "The compute and memory capacity of the nodes. (https://aws.amazon.com/es/elasticache/details/#Available_Cache_Node_Types)"
}

variable "upgrade_old_instance_types" {
  type        = bool
  default     = false
  description = "Override node_type with a newer instance type if possible (e.g. from m3 to m5)."
}

variable "parameter_group_name" {
  type        = string
  description = "Use 'default' to use the deafult parameter group. Use any other string to define a parameter group (in this case you should define the parameter group variables, if any)."
  default     = "default"
}

variable "subnet_group_name" {
  type        = string
  description = "Name of the subnet group to be used for the cache cluster."
}

variable "vpc_id" {
  type        = string
  description = "The id of the VPC where the security group belongs."
}

variable "open_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR that can access the cluster."
}

variable "default_parameter_group" {
  type        = map(string)
  description = "Default parameter group to apply if none provided. Mapped to redis version."
  default = {
    "7.1"    = "default.redis7"
    "7.0"    = "default.redis7"
    "6.x"    = "default.redis6.x"
    "6.0"    = "default.redis6.x"
    "6.2"    = "default.redis6.x"
    "6.0.5"  = "default.redis6.x"
    "3.2.4"  = "default.redis3.2"
    "2.8.24" = "default.redis2.8"
    "2.8.33" = "default.redis2.8"
    "2.8.21" = "default.redis2.8"
    "2.8.19" = "default.redis2.8"
    "2.8.6"  = "default.redis2.8"
  }
}

variable "security_group_name" {
  type        = string
  default     = null
  description = "Name of security group to create (optional)."
}

variable "security_group_description" {
  type        = string
  description = "Description of security group to create."
  default     = "Managed by Terraform"
}

variable "route53_zone_id" {
  type        = string
  default     = null
  description = "Route53 zone ID to create records in."
}

variable "dns_name" {
  type        = string
  default     = null
  description = "Route53 custom name in the zone, optional."
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

variable "name" {
  type = string

  description = "Domain name of the zone."
}

variable "description" {
  type    = string
  default = "Managed by Terraform."

  description = "Description for the zone (optional)."
}

variable "soa_record" {
  type = object({
    name   = string
    record = string
  })

  description = "Start Of Authority record to create in the zone. Only one per zone."
  default     = null
}

variable "ns_records" {
  type    = map(list(string))
  default = {}

  description = "Map of NS records to create in the zone (optional, use for sub-zones)."
}

variable "txt_records" {
  type    = map(list(string))
  default = {}

  description = "Map of TXT records to create in the zone (optional)."
}

variable "caa_records" {
  type    = map(list(string))
  default = {}

  description = "Map of CAA records to create in the zone (optional)."
}

variable "external_cname_records" {
  type    = map(list(string))
  default = {}

  description = "Map of *external* CNAME records to create in the zone (optional). Do not use this for creating CNAMEs towards internal resources like load balancers as we don't want Route53 zones to depend on any project except other Route53 zones. Only use this with static external values!"

  validation {
    condition = alltrue([for value in flatten(values(var.external_cname_records)) : alltrue([
      !strcontains(value, ".amazonaws.com"),
      !strcontains(value, ".cloudfront.net"),
      !strcontains(value, ".awsglobalaccelerator.com"),
      !strcontains(value, ".awsapprunner.com"),
    ])])
    error_message = "You cannot use this variable to set up CNAME towards resources we manage ourselves, please read the variable description for more details!"
  }
}

variable "vpc_ids" {
  type    = list(string)
  default = []

  description = "List of VPC IDs to associate the zone with. Optional, makes the zone private."
}

variable "tags" {
  type = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }

  description = "Tags on the zone."
}

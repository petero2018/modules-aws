variable "name" {
  type = string

  description = "Name of the Global Accelerator."
}

variable "ports" {
  type    = list(number)
  default = [80, 443]

  description = "Ports the Global Accelerator should listen on."
}

variable "protocol" {
  type    = string
  default = "TCP"

  description = "Protocol the Global Accelerator should listen on."
}

variable "client_affinity" {
  type    = string
  default = "NONE"

  description = "Client affinity setting on the listener."
}

variable "ip_address_type" {
  type    = string
  default = "IPV4"

  description = "Value of the Global Accelerator address type."
}

variable "route53_records" {
  type    = map(list(string))
  default = {}

  description = "Route53 records to create and associate to the Global Accelerator (Route53 Zone ID => list of records)."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to resources."
  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}

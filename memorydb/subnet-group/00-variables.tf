variable "name" {
  description = "Name of the subnet group."
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID, used only to pass down as an output to simplify dependency chains."
}

variable "prefix" {
  description = "Name prefix."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs that the subnet group should contain."
  type        = list(string)
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

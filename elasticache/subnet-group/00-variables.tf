variable "name" {
  type        = string
  description = "Name of the subnet group."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs that the subnet group should contain."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID, used only to pass down as an output to simplify dependency chains."
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

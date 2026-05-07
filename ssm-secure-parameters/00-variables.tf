variable "names" {
  type = list(string)

  description = "Names of the secure SSM parameters to be provisioned [with passed value]."
}

variable "value" {
  type = string

  description = "Value of the secure SSM parameters to provision."

  sensitive = true
}

variable "description" {
  type = string

  description = "Description of the secure SSM parameters."
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

variable "name" {
  type        = string
  description = "The name of the ECR repository to create."
}

variable "authorised_accounts" {
  type        = list(string)
  description = "A list of AWS Account IDs which are allowed to pull from this repository."
  default     = []
}

variable "use_immutable_image_tags" {
  type        = bool
  default     = true
  description = "Whether image tags are able to be overwritten. Tag immutability is recommended."
}

variable "use_additional_source_account_check" {
  type        = bool
  default     = false
  description = "If set to true, an extra IAM conditional is added to offer additional protection for cross-account ECR repositories. It requires that the calling service sends the aws:SourceAccount condition key in requests to ECR."
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

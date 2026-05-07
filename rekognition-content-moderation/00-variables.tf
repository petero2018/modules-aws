variable "environment" {
  type        = string
  description = "The environment to which these resources will be deployed."
}

variable "project_name" {
  type        = string
  description = "Name to give the AWS Rekognition project."
}

variable "auto_update" {
  type        = bool
  default     = false
  description = "Whether to enable the auto update feature."
}

variable "upload_bucket" {
  type        = string
  description = "Source bucket to read uploaded items from for content moderation."
}

################################################################################
# Tags
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

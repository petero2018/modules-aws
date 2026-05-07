variable "creation_token" {
  type        = string
  description = "The EFS file system creation token."
  default     = null
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

variable "encrypted" {
  description = "Whether the EFS file system is encrypted."
  type        = bool
  default     = true
}

variable "performance_mode" {
  description = "The performance mode of the EFS file system."
  type        = string
  default     = "generalPurpose"

  validation {
    condition = contains([
      "generalPurpose",
      "maxIO",
      ]
    , var.performance_mode)
    error_message = "Unsupported performance mode!"
  }
}

variable "provisioned_throughput_in_mibps" {
  description = "The provisioned throughput of the EFS file system in MiBps."
  type        = string
  default     = null
}

variable "throughput_mode" {
  description = "The throughput mode of the EFS file system."
  type        = string
  default     = "bursting"

  validation {
    condition = contains([
      "bursting",
      "provisioned",
    ], var.throughput_mode)
    error_message = "Unsupported throughput mode!"
  }
}

variable "kms_key_id" {
  default     = null
  type        = string
  description = "The ID of the AWS Key Management Service (AWS KMS) key that is used to encrypt the EFS file system."
}

variable "lifecycle_policy" {
  default = {
    transition_to_ia                    = "AFTER_90_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
  description = "The lifecycle policy of the EFS file system."
  type = object({
    transition_to_ia                    = string
    transition_to_primary_storage_class = string
  })
}

variable "subnet_ids" {
  type        = list(string)
  description = "The IDs of the subnets to which the EFS file system will be attached."
}

variable "security_group_ids" {
  type        = list(string)
  description = "The IDs of the security groups to which the EFS file system will be attached."
}

variable "mount_target_ip_address" {
  default     = null
  type        = string
  description = "The IP address of the mount target."
}

variable "enable_backups" {
  default     = false
  type        = bool
  description = "Whether to enable backups for the EFS file system."
}

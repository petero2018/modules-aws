variable "bucket_name" {
  type        = string
  description = "Name of the bucket to create an inventory for."
}

variable "bucket_arn" {
  type        = string
  description = "ARN of the bucket to create an inventory for."
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

variable "optional_fields" {
  type        = list(string)
  description = "Fields to include on the inventory. Check possible values here: https://docs.aws.amazon.com/AmazonS3/latest/API/API_InventoryConfiguration.html#AmazonS3-Type-InventoryConfiguration-OptionalFields"

  default = ["Size", "LastModifiedDate", "StorageClass", "IsMultipartUploaded", "ReplicationStatus", "EncryptionStatus", "ObjectLockRetainUntilDate", "ObjectLockMode", "ObjectLockLegalHoldStatus", "IntelligentTieringAccessTier", "BucketKeyStatus"]
}

variable "schedule_frequency" {
  type        = string
  description = "Specifies the schedule for generating inventory results. It can be \"Daily\" or \"Weekly\". Default is \"Weekly\"."

  default = "Weekly"
  validation {
    condition     = contains(["Daily", "Weekly"], var.schedule_frequency)
    error_message = "Schedule frequency must be either \"Daily\" or \"Weekly\"."
  }
}

variable "format" {
  type        = string
  description = "Specifies the format of the inventory. It can be \"CSV\", \"ORC\" or \"Parquet\". Default is \"ORC\"."

  default = "ORC"
  validation {
    condition     = contains(["CSV", "ORC", "Parquet"], var.format)
    error_message = "Format must be either \"CSV\", \"ORC\" or \"Parquet\"."
  }
}

variable "included_object_versions" {
  type        = string
  description = "Specifies the object versions to include in the inventory results. It can be \"All\", or \"Current\". Default is \"Current\"."

  default = "Current"
  validation {
    condition     = contains(["All", "Current"], var.included_object_versions)
    error_message = "Included object versions must be either \"All\" or \"Current\"."
  }
}

variable "enable_athena" {
  type    = bool
  default = false

  description = "If true creates an athena workgroup for the inventory bucket to be able to run queries against the inventory data."
}

variable "delete_after_days" {
  type    = number
  default = 14

  description = "Delete any inventory files that are this number of days old."
}

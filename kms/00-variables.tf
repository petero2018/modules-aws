variable "deletion_window_in_days" {
  type        = number
  default     = 14
  description = "Duration in days after which the key is deleted after destruction of the resource."
}

variable "description" {
  type        = string
  description = "The description of the key as viewed in AWS console."
}

variable "is_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether the key is enabled."
}

variable "multi_region" {
  type        = bool
  default     = false
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key."
}

variable "key_usage" {
  type        = string
  default     = "ENCRYPT_DECRYPT"
  description = "Specifies the intended use of the key."
  validation {
    condition = anytrue([
      var.key_usage == "ENCRYPT_DECRYPT",
      var.key_usage == "SIGN_VERIFY"
    ])
    error_message = "Invalid key usage. Valid values are: ENCRYPT_DECRYPT, SIGN_VERIFY."
  }
}

variable "alias" {
  type        = string
  description = "The display name of the alias. Alias resource is already accounting for the \"alias/\" prefix that AWS requires."
}

variable "key_policy" {
  type        = string
  default     = null
  description = "Resource policy to grant use of the KMS key."
}

variable "customer_master_key_spec" {
  type        = string
  default     = "SYMMETRIC_DEFAULT"
  description = "Signing or encryption algorithm supported by the key."
  validation {
    condition = anytrue([
      var.customer_master_key_spec == "SYMMETRIC_DEFAULT",
      var.customer_master_key_spec == "RSA_2048",
      var.customer_master_key_spec == "RSA_3072",
      var.customer_master_key_spec == "RSA_4096",
      var.customer_master_key_spec == "HMAC_256",
      var.customer_master_key_spec == "ECC_NIST_P256",
      var.customer_master_key_spec == "ECC_NIST_P384",
      var.customer_master_key_spec == "ECC_NIST_P521",
      var.customer_master_key_spec == "ECC_SECG_P256K1"
    ])
    error_message = "Invalid algorithm. Valid values are: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, HMAC_256, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, ECC_SECG_P256K1."
  }
}

variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled."
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

variable "attach_common_key_policy" {
  type        = bool
  default     = true
  description = "Attach common policy to the key."
}

variable "common_encryption_roles" {
  type        = list(string)
  description = "ARNs of IAM roles allowed to encrypt using KMS key."

  default = null
}

variable "common_decryption_roles" {
  type        = list(string)
  description = "ARNs of IAM roles allowed to decrypt using KMS key."

  default = null
}

variable "common_admin_roles" {
  type        = list(string)
  description = "ARNs of IAM roles allowed to administer KMS key."

  default = null
}

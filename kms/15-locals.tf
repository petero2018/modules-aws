locals {
  default_common_encryption_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SecurityRole",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CiCdRole",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TerraformRole",
  ]

  default_common_decryption_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CiCdRole",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TerraformRole",
  ]

  default_common_admin_roles = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AdminRole",
  ]

  common_encryption_roles = var.common_encryption_roles != null ? var.common_encryption_roles : local.default_common_encryption_roles
  common_decryption_roles = var.common_decryption_roles != null ? var.common_decryption_roles : local.default_common_decryption_roles
  common_admin_roles      = var.common_admin_roles != null ? var.common_admin_roles : local.default_common_admin_roles
}

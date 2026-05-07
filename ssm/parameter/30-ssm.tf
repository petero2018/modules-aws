resource "aws_ssm_parameter" "parameter" {
  #checkov:skip=CKV_AWS_337: No need to encrypt using KMS CMK
  #checkov:skip=CKV2_AWS_34: We don't always want to encrypt parameters
  count = var.dynamic ? 0 : 1

  name           = var.name
  description    = var.description
  type           = var.type
  value          = var.value
  insecure_value = var.insecure_value

  tags = var.tags
}

resource "aws_ssm_parameter" "parameter_dynamic" {
  #checkov:skip=CKV_AWS_337: No need to encrypt using KMS CMK
  #checkov:skip=CKV2_AWS_34: We don't always want to encrypt parameters
  count = var.dynamic ? 1 : 0

  name        = var.name
  description = var.description
  type        = var.type
  value       = var.dynamic_initial_value

  tags = var.tags

  lifecycle {
    ignore_changes = [value, insecure_value]

    precondition {
      condition     = var.dynamic && var.value == null && var.insecure_value == null
      error_message = "Creating a dynamic parameter with a value is not allowed. Please set 'value' and 'insecure_value' to null. If you meant to provide an initial seed value, use 'dynamic_initial_value' instead."
    }
  }
}

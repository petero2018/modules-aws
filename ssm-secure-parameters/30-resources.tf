resource "aws_ssm_parameter" "secure" {
  for_each = toset(var.names)

  name        = each.key
  description = var.description
  type        = "SecureString"
  value       = var.value

  tags = var.tags
}

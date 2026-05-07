resource "aws_shield_protection" "protected" {
  name         = var.name
  resource_arn = var.protected_resource_arn

  tags = var.tags
}

resource "aws_shield_application_layer_automatic_response" "application_layer_protection" {
  count = var.application_layer_protection_mode != "DISABLED" ? 1 : 0

  resource_arn = var.protected_resource_arn
  action       = var.application_layer_protection_mode

  depends_on = [
    aws_shield_protection.protected # Ensure the protection is created first to avoid an error
  ]
}

resource "aws_shield_protection_health_check_association" "healthcheck" {
  count = var.health_check.enabled ? 1 : 0

  shield_protection_id = aws_shield_protection.protected.id
  health_check_arn     = var.health_check.arn
}

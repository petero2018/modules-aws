resource "aws_ssm_parameter" "master" {
  name        = "/${var.environment}/databases/${var.name}/master"
  description = "Master credentials for ${var.name}"
  type        = "SecureString"

  value = jsonencode({
    type = var.engine
    host = aws_db_instance.primary.address
    user = aws_db_instance.primary.username
    pass = aws_db_instance.primary.password
  })

  key_id = var.credentials_encryption_key_id

  tags = merge({
    Env = var.environment
  }, local.base_tags)
}

resource "aws_ssm_parameter" "rds" {
  name        = "/database/config/${var.environment}-${var.engine}-${var.name}"
  description = "Master credentials for ${var.environment}-${var.engine}-${var.name}"
  type        = "SecureString"

  value = jsonencode({
    user = aws_db_instance.primary.username
    pass = aws_db_instance.primary.password
  })

  key_id = var.credentials_encryption_key_id

  tags = merge({
    Env = var.environment
  }, local.base_tags)
}

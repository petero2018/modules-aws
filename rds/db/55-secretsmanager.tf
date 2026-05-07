resource "aws_secretsmanager_secret" "rds" {
  #checkov:skip=CKV_AWS_149:The AWS managed KMS key is sufficient
  #checkov:skip=CKV2_AWS_57:No automated rotation for now

  name        = "rds/${local.identifier}"
  description = "Credentials for ${local.identifier}"

  tags = local.base_tags
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

  secret_string = jsonencode({
    # These fields are the standard expected fields for RDS secrets in Secrets Manager
    username             = aws_db_instance.primary.username
    password             = aws_db_instance.primary.password
    engine               = var.engine
    host                 = aws_db_instance.primary.address
    port                 = local.ports[var.engine]
    dbInstanceIdentifier = local.identifier
  })
}



resource "aws_ssm_parameter" "master" {
  name        = "/${var.environment}/databases/${var.name}/master"
  description = "Master credentials for ${var.name}"
  type        = "SecureString"

  value = jsonencode({
    type = "mysql"
    host = aws_rds_cluster.cluster.endpoint
    user = aws_rds_cluster.cluster.master_username
    pass = aws_rds_cluster.cluster.master_password
  })

  key_id = var.credentials_encryption_key_id

  tags = {
    Env     = var.environment
    service = var.name
    team    = var.team_tag
    impact  = var.impact_tag
  }
}

resource "aws_ssm_parameter" "rds" {
  name        = "/database/config/${local.instance_identifier}"
  description = "Master credentials for ${local.instance_identifier}"
  type        = "SecureString"

  value = jsonencode({
    user = aws_rds_cluster.cluster.master_username
    pass = aws_rds_cluster.cluster.master_password
  })

  key_id = var.credentials_encryption_key_id

  tags = {
    Env     = var.environment
    service = var.name
    team    = var.team_tag
    impact  = var.impact_tag
  }
}

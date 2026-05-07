resource "aws_db_proxy" "proxy" {
  count = var.enable_proxy ? 1 : 0

  name                = local.identifier
  debug_logging       = false
  engine_family       = local.engine_families[var.engine]
  idle_client_timeout = 1800
  require_tls         = true
  role_arn            = var.proxy_role_arn

  vpc_security_group_ids = [aws_security_group.proxy[0].id]
  vpc_subnet_ids         = data.aws_db_subnet_group.rds.subnet_ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "REQUIRED"
    secret_arn  = aws_secretsmanager_secret.rds.arn
  }

  tags = local.base_tags
}


resource "aws_db_proxy_default_target_group" "proxy" {
  count = var.enable_proxy ? 1 : 0

  db_proxy_name = aws_db_proxy.proxy[0].name

  connection_pool_config {
    max_connections_percent = var.proxy_max_connections_percentage
  }
}

resource "aws_db_proxy_target" "proxy" {
  count = var.enable_proxy ? 1 : 0

  db_instance_identifier = aws_db_instance.primary.identifier
  db_proxy_name          = aws_db_proxy.proxy[0].name
  target_group_name      = aws_db_proxy_default_target_group.proxy[0].name
}

locals {
  ports = {
    mysql    = 3306
    postgres = 5432
  }

  # Engine family is used for RDS Proxy and has specific values
  engine_families = {
    mysql    = "MYSQL"
    postgres = "POSTGRESQL"
  }

  rds_iam_full_access_user = "iamuser"
  rds_iam_read_only_user   = "iamreadonly"

  db_resource_ids   = length(var.replica_configurations) > 0 ? concat([aws_db_instance.primary.resource_id], flatten([for replica in aws_db_instance.replica : replica.resource_id])) : [aws_db_instance.primary.resource_id]
  proxy_resource_id = var.enable_proxy ? split(":", aws_db_proxy.proxy[0].arn)[6] : "" # This is the only way to fetch this ID at this time

  # We force some values when preparing for deletion:
  deletion_protection_enabled = var.prepare_deletion ? false : var.deletion_protection_enabled # Force disable deletion protection
  impact_tag                  = var.prepare_deletion ? "low" : var.impact_tag                  # Force low impact tag ('critical' tag prevents deletion)
  allowed_cidrs               = var.prepare_deletion ? [] : var.allowed_cidrs                  # Block ingress CIDRs
  allowed_security_groups     = var.prepare_deletion ? [] : var.allowed_security_groups        # Block ingress security groups

  base_tags = {
    service = var.name
    team    = var.team_tag
    impact  = local.impact_tag
  }
}

locals {
  cluster_identifier  = "${var.environment}-aurora-cluster-${var.name}"
  instance_identifier = var.custom_identifier ? "${var.environment}-${var.custom_identifier_name}" : "${var.environment}-${var.engine}-${var.name}"
  backup_tags         = var.aws_backup_enabled ? { "backup_plan" = "rds_daily" } : {}
  kms_key_id = (var.storage_encryption_enabled ?
    (var.restore_from_latest_snapshot ?
      data.aws_db_cluster_snapshot.latest_snapshot[0].kms_key_id
      : var.storage_encryption_arn
    ) : null
  )
}

resource "aws_rds_cluster" "cluster" {
  #checkov:skip=CKV_AWS_128:add iam authentication when needed
  #checkov:skip=CKV_AWS_162:enable iam authentication when needed
  #checkov:skip=CKV2_AWS_8:this is passed by parameter

  # DB configuration
  cluster_identifier              = local.cluster_identifier
  database_name                   = var.database_name == "" ? var.name : var.database_name
  engine                          = var.engine
  engine_version                  = var.engine_version
  master_password                 = coalesce(var.password, join("", random_password.primary[*].result))
  master_username                 = var.username
  db_cluster_parameter_group_name = var.cluster_parameter_group

  # Storage
  storage_encrypted = var.storage_encryption_enabled
  kms_key_id        = local.kms_key_id

  # Networking
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = concat(var.security_group_ids, [aws_security_group.primary.id])

  # Maintenance
  backup_retention_period      = var.backup_enabled ? var.backup_retention_days : null
  preferred_backup_window      = var.backup_enabled ? var.backup_window : null
  preferred_maintenance_window = var.backup_enabled ? var.maintenance_window : null
  deletion_protection          = var.deletion_protection_enabled
  skip_final_snapshot          = true
  copy_tags_to_snapshot        = true
  apply_immediately            = true

  # Logging
  enabled_cloudwatch_logs_exports = length(var.enabling_cloudwatch_logs_exports) == 0 ? null : var.enabling_cloudwatch_logs_exports

  # Restore from latest snapshot
  snapshot_identifier = var.restore_from_latest_snapshot ? data.aws_db_cluster_snapshot.latest_snapshot[0].id : null

  tags = merge({
    Env     = var.environment
    Role    = var.name
    service = var.name
    team    = var.team_tag
    impact  = var.impact_tag
  }, local.backup_tags)


  timeouts {
    create = "120m"
  }
}

data "aws_db_cluster_snapshot" "latest_snapshot" {
  count                 = var.restore_from_latest_snapshot ? 1 : 0
  db_cluster_identifier = local.cluster_identifier
  most_recent           = true
  include_shared        = true
}

resource "aws_rds_cluster_instance" "instance" {
  count = var.replica_count

  # DB configuration
  identifier         = "${local.instance_identifier}-${count.index}"
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = var.replica_instance_class
  engine             = var.engine
  engine_version     = var.engine_version

  # Monitoring
  monitoring_interval          = var.enhanced_monitoring_enabled ? var.enhanced_monitoring_interval : null
  monitoring_role_arn          = var.enhanced_monitoring_enabled ? var.enhanced_monitoring_role_arn : null
  performance_insights_enabled = var.performance_insights_enabled

  # Networking
  db_subnet_group_name = var.db_subnet_group_name

  # Maintenance
  auto_minor_version_upgrade = false
  apply_immediately          = true

  # Ignore Changes
  lifecycle {
    ignore_changes = [
      promotion_tier
    ]
  }
  tags = {
    Env     = var.environment
    Role    = var.name
    service = var.name
    team    = var.team_tag
    impact  = var.impact_tag
  }

  timeouts {
    create = "60m"
  }
}

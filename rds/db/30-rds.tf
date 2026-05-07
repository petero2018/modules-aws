locals {
  identifier  = var.identifier != "" ? var.identifier : "${var.environment}-${var.engine}-${var.name}"
  backup_tags = var.aws_backup_enabled ? { "backup_plan" = "rds_daily" } : {}
  kms_key_id = (var.storage_encryption_enabled ?
    (var.restore_from_latest_snapshot ?
      data.aws_db_snapshot.latest_snapshot[0].kms_key_id
      : var.storage_encryption_arn
    ) : null
  )
  allocated_storage = var.restore_from_latest_snapshot ? data.aws_db_snapshot.latest_snapshot[0].allocated_storage : var.storage_allocated
  engine_version    = var.restore_from_latest_snapshot ? data.aws_db_snapshot.latest_snapshot[0].engine_version : var.engine_version
  storage_type      = var.restore_from_latest_snapshot ? data.aws_db_snapshot.latest_snapshot[0].storage_type : var.storage_type
  iops              = var.restore_from_latest_snapshot ? data.aws_db_snapshot.latest_snapshot[0].iops : var.storage_iops
}

resource "aws_db_instance" "primary" {
  #checkov:skip=CKV_AWS_157:multi az is configured by parameter
  #checkov:skip=CKV_AWS_133:this is parametrized, optional for dev
  #checkov:skip=CKV_AWS_353:optional
  #checkov:skip=CKV_AWS_354:optional
  # DB configuration
  identifier                          = local.identifier
  engine                              = var.engine
  engine_version                      = local.engine_version
  instance_class                      = var.instance_class
  username                            = var.username
  password                            = coalesce(var.password, join("", random_password.primary[*].result))
  parameter_group_name                = aws_db_parameter_group.primary.name
  option_group_name                   = var.option_group
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  # Monitoring
  monitoring_interval          = var.enhanced_monitoring_enabled ? var.enhanced_monitoring_interval : null
  monitoring_role_arn          = var.enhanced_monitoring_enabled ? var.enhanced_monitoring_role_arn : null
  performance_insights_enabled = var.performance_insights_enabled

  # Storage
  allocated_storage     = local.allocated_storage
  max_allocated_storage = var.storage_max_allocated
  storage_type          = local.storage_type
  iops                  = local.iops
  kms_key_id            = local.kms_key_id
  ca_cert_identifier    = var.ca_cert_identifier
  storage_encrypted     = var.storage_encryption_enabled

  # Networking
  multi_az               = var.multi_az_enabled
  vpc_security_group_ids = concat(var.security_group_ids, aws_security_group.primary[*].id)
  db_subnet_group_name   = var.db_subnet_group_name

  # Maintenance
  skip_final_snapshot         = true
  copy_tags_to_snapshot       = true
  backup_window               = var.backup_enabled ? var.backup_window : null
  backup_retention_period     = var.backup_enabled ? var.backup_retention_days : null
  maintenance_window          = var.backup_enabled ? var.maintenance_window : null
  deletion_protection         = local.deletion_protection_enabled
  apply_immediately           = true
  auto_minor_version_upgrade  = var.allow_auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade

  # Logging
  enabled_cloudwatch_logs_exports = length(var.enabling_cloudwatch_logs_exports) == 0 ? null : var.enabling_cloudwatch_logs_exports

  # Restore from latest snapshot
  snapshot_identifier = var.restore_from_latest_snapshot ? data.aws_db_snapshot.latest_snapshot[0].id : null

  # Backups need to be enabled for blue/green deployments to work
  blue_green_update {
    enabled = var.backup_enabled && var.blue_green_enabled ? true : false
  }

  tags = merge({
    Env  = var.environment
    Role = var.name
  }, local.base_tags, local.backup_tags, var.extra_tags)

  timeouts {
    create = "120m"
  }
}

data "aws_db_snapshot" "latest_snapshot" {
  count                  = var.restore_from_latest_snapshot ? 1 : 0
  db_instance_identifier = local.identifier
  most_recent            = true
  include_shared         = true
  snapshot_type          = "awsbackup"
}

resource "aws_db_instance" "replica" {
  #checkov:skip=CKV2_AWS_60:irrelevant for replica
  #checkov:skip=CKV_AWS_157:multi az is configured by parameter
  #checkov:skip=CKV_AWS_118:enhanced monitoring not needed for now on replica
  #checkov:skip=CKV_AWS_353:optional
  #checkov:skip=CKV_AWS_354:optional

  for_each = var.replica_configurations

  # DB configuration
  identifier                          = "${local.identifier}-${each.key}"
  instance_class                      = each.value.instance_class
  parameter_group_name                = length(each.value.parameters) == 0 ? aws_db_parameter_group.primary.name : aws_db_parameter_group.replica[0].name
  replicate_source_db                 = aws_db_instance.primary.identifier
  option_group_name                   = var.option_group
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  # Storage
  allocated_storage     = local.allocated_storage
  max_allocated_storage = var.storage_max_allocated
  storage_type          = local.storage_type
  iops                  = each.value.iops
  kms_key_id            = local.kms_key_id
  ca_cert_identifier    = var.ca_cert_identifier
  storage_encrypted     = var.storage_encryption_enabled

  # Networking
  multi_az               = each.value.multi_az_enabled
  vpc_security_group_ids = concat(var.security_group_ids, aws_security_group.primary[*].id)

  # Maintenance
  apply_immediately           = true
  skip_final_snapshot         = true
  auto_minor_version_upgrade  = false
  allow_major_version_upgrade = var.allow_major_version_upgrade
  deletion_protection         = local.deletion_protection_enabled

  # Logging
  enabled_cloudwatch_logs_exports = length(each.value.enabling_cloudwatch_logs_exports) == 0 ? null : each.value.enabling_cloudwatch_logs_exports
  performance_insights_enabled    = each.value.performance_insights_enabled

  tags = merge({
    Env  = var.environment
    Role = "${var.name}-replica"
  }, local.base_tags, var.extra_tags)

  timeouts {
    create = "120m"
  }
}

moved {
  from = aws_db_instance.replica[0]
  to   = aws_db_instance.replica["replica"]
}

resource "aws_backup_framework" "dynamodb" {
  name        = "dynamodb"
  description = "This checks DynamoDB tables with daily backups"

  control {
    name = "BACKUP_RESOURCES_PROTECTED_BY_CROSS_ACCOUNT"

    input_parameter {
      name  = "crossAccountList"
      value = var.backup_account_id
    }

    scope {
      tags = local.dynamodb_daily_tags
    }
  }

  control {
    name = "BACKUP_RESOURCES_PROTECTED_BY_CROSS_REGION"

    input_parameter {
      name  = "crossRegionList"
      value = var.destination_region
    }

    scope {
      tags = local.dynamodb_daily_tags
    }
  }

  control {
    name = "BACKUP_PLAN_MIN_FREQUENCY_AND_MIN_RETENTION_CHECK"

    input_parameter {
      name  = "requiredFrequencyUnit"
      value = "days"
    }
    input_parameter {
      name  = "requiredFrequencyValue"
      value = "1"
    }
    input_parameter {
      name  = "requiredRetentionDays"
      value = var.backup_retention_days
    }

    scope {
      compliance_resource_types = ["AWS::Backup::BackupPlan"]
      compliance_resource_ids   = [aws_backup_plan.dynamodb_daily.id]
    }
  }

  control {
    name = "BACKUP_RECOVERY_POINT_MINIMUM_RETENTION_CHECK"

    input_parameter {
      name  = "requiredRetentionDays"
      value = var.backup_retention_days
    }

    scope {
      tags = local.dynamodb_daily_tags
    }
  }

  control {
    name = "BACKUP_RECOVERY_POINT_ENCRYPTED"

    scope {
      tags = local.dynamodb_daily_tags
    }
  }

  control {
    name = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_PLAN"

    scope {
      tags = local.dynamodb_daily_tags
    }
  }

  lifecycle {
    ignore_changes = [
      control,
    ]
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  tags = var.tags
}

resource "aws_backup_framework" "rds" {
  # Cross-account control cannot be done here as it's being done via Lambda and not a Backup Plan

  name        = "rds"
  description = "This checks RDS databases with daily backups"

  control {
    name = "BACKUP_RESOURCES_PROTECTED_BY_CROSS_REGION"

    input_parameter {
      name  = "crossRegionList"
      value = var.destination_region
    }

    scope {
      tags = local.rds_daily_tags
    }
  }

  control {
    name = "BACKUP_PLAN_MIN_FREQUENCY_AND_MIN_RETENTION_CHECK"

    input_parameter {
      name  = "requiredFrequencyUnit"
      value = "days"
    }
    input_parameter {
      name  = "requiredFrequencyValue"
      value = "1"
    }
    input_parameter {
      name  = "requiredRetentionDays"
      value = var.backup_retention_days
    }

    scope {
      compliance_resource_types = ["AWS::Backup::BackupPlan"]
      compliance_resource_ids   = [aws_backup_plan.rds_daily.id]
    }
  }

  control {
    name = "BACKUP_RECOVERY_POINT_MINIMUM_RETENTION_CHECK"

    input_parameter {
      name  = "requiredRetentionDays"
      value = var.backup_retention_days
    }

    scope {
      tags = local.rds_daily_tags
    }
  }

  control {
    name = "BACKUP_RECOVERY_POINT_ENCRYPTED"

    scope {
      tags = local.rds_daily_tags
    }
  }

  control {
    name = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_PLAN"

    scope {
      tags = local.rds_daily_tags
    }
  }

  lifecycle {
    ignore_changes = [
      control,
    ]
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  tags = var.tags
}

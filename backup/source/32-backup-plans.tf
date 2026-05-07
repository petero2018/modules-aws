resource "aws_backup_plan" "dynamodb_daily" {
  name = "dynamodb_daily"

  rule {
    rule_name         = "dynamodb_daily"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 5 ? * * *)"

    start_window      = 360 # Start within 6 hours
    completion_window = 720 # Finish within 12 hours

    lifecycle {
      delete_after = var.backup_retention_days
    }

    copy_action {
      lifecycle {
        delete_after = var.backup_retention_days
      }
      destination_vault_arn = var.backup_vault_arn
    }
  }

  tags = var.tags
}

resource "aws_backup_plan" "rds_daily" {
  name = "rds_daily"

  rule {
    rule_name         = "rds_daily"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 5 ? * * *)"

    start_window      = 360 # Start within 6 hours
    completion_window = 720 # Finish within 12 hours

    lifecycle {
      delete_after = var.backup_retention_days
    }

    copy_action {
      lifecycle {
        delete_after = 3 # Secondary region in main account is only temporary for the time to copy into the backup account
      }

      # RDS Backups cannot be moved from region & account at the same time
      # We need to do the operation in two steps
      destination_vault_arn = var.destination_region_vault_arn
    }
  }

  tags = var.tags
}

resource "aws_backup_plan" "s3_backup" {
  name = "s3_backup"

  rule {
    rule_name         = "s3_backup"
    target_vault_name = aws_backup_vault.vault.name

    schedule = "cron(0 5 ? * * *)"

    enable_continuous_backup = true

    lifecycle {
      delete_after = var.backup_retention_days
    }

    copy_action {
      lifecycle {
        delete_after = var.backup_retention_days
      }
      destination_vault_arn = var.backup_vault_arn
    }
  }
  tags = var.tags
}

resource "aws_backup_plan" "clickhouse_ebs" {
  name = "clickhouse_ebs"

  rule {
    rule_name         = "clickhouse_ebs"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 5 ? * * *)"

    start_window      = 60  # Start within 1 hour
    completion_window = 120 # Finish within 2 hours

    lifecycle {
      delete_after = var.backup_retention_days
    }

    copy_action {
      lifecycle {
        delete_after = var.backup_retention_days
      }
      destination_vault_arn = var.backup_vault_arn
    }
  }

  tags = var.tags
}

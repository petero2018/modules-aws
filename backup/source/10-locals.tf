locals {
  lambda_function_name = "rds_copy_backup"
  dynamodb_daily_tags = {
    "backup_plan" = var.dynamodb_selection_tag
  }
  rds_daily_tags = {
    "backup_plan" = var.rds_selection_tag
  }
}

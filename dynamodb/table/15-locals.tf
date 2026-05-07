locals {
  backup_tags = var.aws_backup_enabled ? { "backup_plan" = "dynamodb_daily" } : {}

  tags = merge({
    terraform_module = "git@github.com:powise/terraform-modules//aws/dynamodb/table"
  }, var.tags)
}

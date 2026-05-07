data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_db_subnet_group" "rds" {
  name = var.db_subnet_group_name
}

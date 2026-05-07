resource "aws_kms_replica_key" "replica" {
  primary_key_arn = var.primary_key_arn

  deletion_window_in_days = var.deletion_window_in_days
  description             = var.description
  enabled                 = var.is_enabled
  policy                  = var.key_policy

  tags = var.tags
}

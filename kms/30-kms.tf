resource "aws_kms_key" "kms_key" {
  description              = var.description
  key_usage                = var.key_usage
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  customer_master_key_spec = var.customer_master_key_spec
  multi_region             = var.multi_region
  policy                   = data.aws_iam_policy_document.combined_policy.json
  tags                     = var.tags
}

resource "aws_kms_alias" "key_alias" {
  name          = format("alias/%s", var.alias)
  target_key_id = aws_kms_key.kms_key.key_id
}

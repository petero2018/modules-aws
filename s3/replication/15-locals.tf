locals {
  replication_role_name   = "${var.bucket_id}-replication-role"
  replication_policy_name = "${var.bucket_id}-replication-policy"

  target_bucket_arns = compact([for name, config in var.replication_config : config.target_bucket_arn])
  source_kms_keys    = compact([for name, config in var.replication_config : config.source_kms_key_id])
  target_kms_keys    = compact([for name, config in var.replication_config : config.target_kms_key_id])

  # Tags
  tags = merge({
    terraform_module = "git@github.com:powise/terraform-modules//aws/s3/replication"
  }, var.tags)
}

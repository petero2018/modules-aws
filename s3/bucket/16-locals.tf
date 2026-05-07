resource "random_string" "random_suffix" {
  count = var.rand_suffix ? 1 : 0

  length  = 6
  special = false
  lower   = true
  upper   = false
}

moved { # Made the resource optional
  from = random_string.random_suffix
  to   = random_string.random_suffix[0]
}

locals {
  bucket_name = var.rand_suffix ? "${var.bucket_name}-${random_string.random_suffix[0].result}" : var.bucket_name

  enable_bucket_policy = var.create_bucket_policy ? anytrue([
    var.require_latest_tls,
    var.deny_insecure_transport,
    var.require_encrypted_uploads,
    var.attach_lb_log_delivery_policy,
    var.bucket_policy != null
  ]) : false

  tags = merge(
    {
      terraform_module = "git@github.com:powise/terraform-modules//aws/s3/bucket"
    },
    var.tags,
    (var.aws_backup_enabled && var.enable_versioning) ? { "backup_plan" = "s3_backup" } : {}
  )
}

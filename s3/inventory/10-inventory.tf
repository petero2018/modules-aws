module "inventory_bucket" {
  source = "../bucket"

  bucket_name   = local.inventory_name
  bucket_policy = data.aws_iam_policy_document.access_for_inventory.json

  require_latest_tls        = true
  deny_insecure_transport   = true
  require_encrypted_uploads = false

  public_access_block = {
    ignore_public_acls      = true
    block_public_policy     = true
    block_public_acls       = true
    restrict_public_buckets = true
  }

  tags = var.tags

  lifecycle_rules = [
    {
      id     = "expire-old-inventory-files"
      status = "Enabled"
      filter = {
        prefix = var.bucket_name
      }
      expiration = {
        days = var.delete_after_days
      }
    }
  ]
}

resource "aws_s3_bucket_inventory" "bucket_inventory" {
  bucket = var.bucket_name
  name   = local.inventory_name

  included_object_versions = var.included_object_versions

  schedule {
    frequency = var.schedule_frequency
  }

  destination {
    bucket {
      format     = var.format
      bucket_arn = module.inventory_bucket.bucket_arn
    }
  }

  optional_fields = var.optional_fields
}

resource "random_string" "s3_suffix" {
  length  = 6
  lower   = true
  upper   = false
  number  = true
  special = false
}

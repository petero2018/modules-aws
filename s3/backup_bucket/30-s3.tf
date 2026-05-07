module "backup_bucket" {
  source = "../bucket"

  bucket_name = local.bucket_name

  enable_versioning = true

  public_access_block = {
    ignore_public_acls      = true
    block_public_policy     = true
    block_public_acls       = true
    restrict_public_buckets = true
  }

  object_ownership_setting = "ObjectWriter" # Previous default, has to be explicit now

  create_bucket_policy = false # Bucket policy is created in the "policy" module to avoid cyclic dependencies

  lifecycle_rules = [
    {
      id     = "storage-class-transition"
      status = var.enable_storage_class_transition ? "Enabled" : "Disabled"
      transition = {
        days          = var.storage_class_transition_days
        storage_class = var.storage_class
      }
    },
    {
      id     = "expire-noncurrent"
      status = var.expire_noncurrent ? "Enabled" : "Disabled"
      noncurrent_version_expiration = {
        noncurrent_days = var.noncurrent_transition_days
      }
    }
  ]

  tags = var.tags
}

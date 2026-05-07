module "bucket" {
  for_each = { for name, repository in var.repositories : name => repository if repository.create_bucket }

  source = "../../s3/bucket"

  bucket_name = each.value.bucket_name

  rand_suffix = true

  lifecycle_rules = [
    {
      # As object versioning is enabled, we need to ensure we delete noncurrent versions from deleted backups
      id     = "expire-noncurrent"
      status = "Enabled"
      noncurrent_version_expiration = {
        noncurrent_days = 7
      }
    }
  ]

  tags = var.tags
}

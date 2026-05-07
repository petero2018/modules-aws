module "bucket" {
  source = "git@github.com:powise/terraform-modules//aws/s3/bucket?ref=aws-s3-bucket-2.7.0"

  bucket_name = "powise-${var.project_name}-${var.environment}-${data.aws_region.current.name}"

  rand_suffix = true

  public_access_block = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  tags = local.tags
}

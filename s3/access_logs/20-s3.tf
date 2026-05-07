resource "aws_s3_bucket" "s3_bucket" {
  #checkov:skip=CKV_AWS_18: Access log bucket should not have access logs enabled. Creates infinite loop.
  #checkov:skip=CKV_AWS_19: Encryption at rest enabled. Checkov just doesn't acknowledge yet it is no longer enabled in this resource
  #checkov:skip=CKV_AWS_20: Bucket does not have ACL with public READ access
  #checkov:skip=CKV_AWS_21: Versioning is enabled in this module
  #checkov:skip=CKV_AWS_57: Bucket does not have ACL with public WRITE access
  #checkov:skip=CKV_AWS_144: Disable cross-region replication check. Replication handled by module
  #checkov:skip=CKV_AWS_145: Disable KMS encryption check. KMS does not work with S3 access logs
  bucket        = "${data.aws_caller_identity.current.account_id}-s3-access-logs-${data.aws_region.current.name}"
  force_destroy = var.force_destroy
  tags          = var.tags
}

# Versioning
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Public Access
resource "aws_s3_bucket_public_access_block" "block_public_acls" {
  count                   = var.public_access_block != null ? 1 : 0
  bucket                  = aws_s3_bucket.s3_bucket.id
  ignore_public_acls      = var.public_access_block.ignore_public_acls
  block_public_policy     = var.public_access_block.block_public_policy
  block_public_acls       = var.public_access_block.block_public_acls
  restrict_public_buckets = var.public_access_block.restrict_public_buckets
}

# Bucket Policy
resource "aws_s3_bucket_policy" "bucket_policy_att" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.combined_policy.json
}

#Encryption at Rest
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    bucket_key_enabled = var.encryption_at_rest.bucket_key_enabled
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.encryption_at_rest.encryption_settings.kms_master_key_id
      sse_algorithm     = var.encryption_at_rest.encryption_settings.sse_algorithm
    }
  }
}

# Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.s3_bucket_versioning]
  bucket     = aws_s3_bucket.s3_bucket.id

  rule {
    id = "access-logs"

    expiration {
      days = 1
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    status = "Enabled"
  }
}

#Replication
resource "aws_s3_bucket_replication_configuration" "s3_bucket_replication" {
  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    status = "Enabled"

    destination {
      account       = "121458125975" # Logs account
      bucket        = "arn:aws:s3:::powise-s3-access-logs-${aws_s3_bucket.s3_bucket.region}"
      storage_class = "STANDARD"
      access_control_translation {
        owner = "Destination"
      }
    }
  }
}

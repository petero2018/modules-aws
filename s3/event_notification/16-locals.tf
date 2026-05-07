locals {
  bucket_arn = coalesce(var.bucket_arn, "arn:aws:s3:::${var.bucket}")
}

# # AWS Backup role in main account
module "db_export_bucket" {
  #checkov:skip=CKV_AWS_300: Disable period for aborting failed uploads check

  source = "git@github.com:powise/terraform-modules//aws/s3/bucket?ref=aws-s3-bucket-2.7.0"

  bucket_name       = "${var.vault_name}-backup-snapshots"
  acl               = "private"
  enable_versioning = true

  rand_suffix = true

  tags = var.tags
}

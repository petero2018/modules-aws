locals {
  inventory_name_prefix = substr(var.bucket_name, 0, 63 - length(local.inventory_name_suffix))
  inventory_name_suffix = "-${random_string.s3_suffix.result}-inventory"
  inventory_name        = "${local.inventory_name_prefix}${local.inventory_name_suffix}"
}

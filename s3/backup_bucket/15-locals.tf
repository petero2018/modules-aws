resource "random_string" "random" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

locals {
  bucket_name = var.add_random_suffix ? "${var.src_bucket_name}-${random_string.random.result}-backup" : "${var.src_bucket_name}-backup"
}

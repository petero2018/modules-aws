resource "aws_dynamodb_table" "table" {
  #checkov:skip=CKV_AWS_28:Point in time recovery is optional
  #checkov:skip=CKV_AWS_119:Encryption with KMS CMK is optional

  hash_key       = var.hash_key
  range_key      = var.range_key
  name           = var.name
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.key
      type = attribute.value
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indices

    content {
      name            = global_secondary_index.key
      hash_key        = global_secondary_index.value.hash_key
      projection_type = global_secondary_index.value.projection_type
    }
  }

  dynamic "ttl" {
    for_each = var.ttl != null ? [var.ttl] : []

    content {
      attribute_name = ttl.value.attribute_name
      enabled        = ttl.value.enabled
    }
  }

  tags = merge(
    local.backup_tags,
    local.tags
  )
}

locals {
  waf_blocks_gsi_name           = "IPVersionExpirationIndex"
  waf_blocks_whitelist_gsi_name = "IPVersionExpirationIndex"

}

resource "aws_dynamodb_table" "waf_blocks" {
  #checkov:skip=CKV_AWS_28:This table has items added and deleted regularly. No use for a recovery point
  #checkov:skip=CKV2_AWS_16:Unlikely for item volume to skyrocket. Autoscaling not required
  #checkov:skip=CKV_AWS_119:AWS managed key is used instead
  name           = "WAFBlocks"
  hash_key       = "IP"
  billing_mode   = "PROVISIONED"
  write_capacity = 1
  read_capacity  = 1
  stream_enabled = false

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "IP"
    type = "S"
  }

  attribute {
    name = "IPVersion"
    type = "S"
  }

  attribute {
    name = "timestamp_expired"
    type = "N"
  }

  global_secondary_index {
    name            = local.waf_blocks_gsi_name
    hash_key        = "IPVersion"
    range_key       = "timestamp_expired"
    write_capacity  = 1
    read_capacity   = 1
    projection_type = "ALL"
  }

  ttl {
    enabled        = true
    attribute_name = "timestamp_expired"
  }

  tags = {
    backup_plan = "dynamodb_daily"
    impact      = "High"
    service     = "WAFv2"
    team        = "Security"
  }
}

resource "aws_dynamodb_table" "waf_blocks_whitelist" {
  #checkov:skip=CKV2_AWS_16:Unlikely for item volume to skyrocket. App autoscaling not required
  #checkov:skip=CKV_AWS_119:AWS managed key is used instead
  name           = "WAFBlocksWhiteList"
  hash_key       = "IP"
  billing_mode   = "PROVISIONED"
  write_capacity = 1
  read_capacity  = 1
  stream_enabled = false

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "IP"
    type = "S"
  }

  attribute {
    name = "IPVersion"
    type = "S"
  }

  attribute {
    name = "timestamp_expired"
    type = "N"
  }

  global_secondary_index {
    name            = local.waf_blocks_whitelist_gsi_name
    hash_key        = "IPVersion"
    range_key       = "timestamp_expired"
    write_capacity  = 1
    read_capacity   = 1
    projection_type = "ALL"
  }

  ttl {
    enabled        = true
    attribute_name = "timestamp_expired"
  }

  tags = {
    backup_plan = "dynamodb_daily"
    impact      = "High"
    service     = "WAFv2"
    team        = "Security"
  }
}

resource "aws_dynamodb_table_item" "ipv4" {
  for_each   = toset(var.ip_whitelist_ipv4)
  table_name = aws_dynamodb_table.waf_blocks_whitelist.name
  hash_key   = aws_dynamodb_table.waf_blocks_whitelist.hash_key

  item = jsonencode({
    IP = {
      S = each.key
    }
    IPVersion = {
      S = "v4"
    }
    # Set the validity period from 0 to a very high epoch - DynamoDB will not expire these items
    # See: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/time-to-live-ttl-before-you-start.html#time-to-live-ttl-before-you-start-formatting
    timestamp_from = {
      N = "0"
    }
    timestamp_expired = {
      N = "32503680000"
    }
  })
}


resource "aws_dynamodb_table_item" "ipv6" {
  for_each   = toset(var.ip_whitelist_ipv6)
  table_name = aws_dynamodb_table.waf_blocks_whitelist.name
  hash_key   = aws_dynamodb_table.waf_blocks_whitelist.hash_key

  item = jsonencode({
    IP = {
      S = each.key
    }
    IPVersion = {
      S = "v6"
    }
    # Set the validity period from 0 to a very high epoch - DynamoDB will not expire these item
    # See: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/time-to-live-ttl-before-you-start.html#time-to-live-ttl-before-you-start-formatting
    timestamp_from = {
      N = "0"
    }
    timestamp_expired = {
      N = "32503680000"
    }
  })
}

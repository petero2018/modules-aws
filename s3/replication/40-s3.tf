resource "aws_s3_bucket_replication_configuration" "replication" {
  role   = aws_iam_role.replication.arn
  bucket = var.bucket_id

  dynamic "rule" {
    for_each = var.replication_config
    content {
      status   = "Enabled"
      priority = rule.value.priority

      destination {
        account       = rule.value.target_bucket_aws_account_id
        bucket        = rule.value.target_bucket_arn
        storage_class = rule.value.target_storage_class

        access_control_translation {
          owner = "Destination"
        }

        metrics {
          status = "Enabled"
          event_threshold {
            minutes = 15
          }
        }

        # Needed to get the events from the replication bucket: https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-time-control.html#using-s3-events-to-track-rtc
        replication_time {
          status = "Enabled"
          time {
            minutes = 15
          }
        }

        dynamic "encryption_configuration" {
          for_each = rule.value.source_kms_key_id != null ? [true] : []
          content {
            replica_kms_key_id = rule.value.source_kms_key_id
          }
        }
      }

      # Set required empty block if no filter is defined. Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration#rule
      # Max 1 block - filter - without any key arguments or tags, to match all
      dynamic "filter" {
        for_each = rule.value.filter == null ? [true] : []

        content {}
      }

      # Max 1 block - filter - with one key argument or a single tag
      dynamic "filter" {
        for_each = rule.value.filter != null ? [rule.value.filter] : []

        content {
          prefix = filter.value.prefix

          dynamic "tag" {
            for_each = rule.value.filter.tag != null ? [true] : []
            content {
              key   = rule.value.filter.tag.key
              value = rule.value.filter.tag.value
            }
          }
        }
      }

      # A policy for delete marker replication must be specified
      dynamic "delete_marker_replication" {
        for_each = try(rule.value.filter.tag, null) == null ? [true] : []
        content {
          status = "Enabled"
        }
      }

      # This policy must be explictly disabled when filtering by tags
      dynamic "delete_marker_replication" {
        for_each = try(rule.value.filter.tag, null) != null ? [true] : []
        content {
          status = "Disabled"
        }
      }

      dynamic "source_selection_criteria" {
        for_each = rule.value.source_kms_key_id != null ? [true] : []
        content {
          sse_kms_encrypted_objects {
            status = "Enabled"
          }
        }
      }
    }
  }
}

resource "time_sleep" "wait_for_role" {
  # Wait a bit before the role policy attachment & repository creation in OpenSearch, otherwise it will fail with an error 500

  depends_on = [aws_iam_role_policy.s3_access_policy]

  create_duration = "15s"
}

resource "opensearch_snapshot_repository" "repository" {
  for_each = var.repositories

  name = each.key
  type = "s3"

  settings = merge({
    bucket   = each.value.create_bucket ? module.bucket[each.key].bucket_id : each.value.bucket_name
    region   = each.value.bucket_region
    readonly = !each.value.create_bucket # Force readonly unless we created the bucket
    role_arn = aws_iam_role.s3_snapshots.arn
  }, each.value.settings)

  depends_on = [time_sleep.wait_for_role]
}

resource "opensearch_sm_policy" "snapshots" {
  for_each = { for name, repository in var.repositories : name => repository.snapshots if repository.snapshots != null }

  policy_name = each.value.policy_name

  body = jsonencode({
    enabled     = each.value.enabled
    description = each.value.policy_description
    name        = each.value.policy_name

    creation = {
      schedule = {
        cron = {
          expression = each.value.cron_expression
          timezone   = each.value.cron_timezone
        }
      }

      time_limit = each.value.time_limit
    }

    deletion = {
      schedule = {
        cron = {
          expression = "0 0 * * *"
          timezone   = "UTC"
        }
      }

      condition = {
        max_count = 400 # Default value, not specifying it creates a diff when planning
        min_count = 1   # Default value, not specifying it creates a diff when planning (needs to be 1 or more)
        max_age   = each.value.max_age
      }

      time_limit = each.value.deletion_time_limit
    }

    snapshot_config = {
      timezone   = each.value.timezone
      indices    = each.value.indices
      repository = opensearch_snapshot_repository.repository[each.key].name
    }
  })
}

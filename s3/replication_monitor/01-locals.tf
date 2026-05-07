locals {
  monitor_name               = var.monitor_name != null ? var.monitor_name : var.bucket_name
  sns_replication_topic_name = "s3-${local.monitor_name}-replication-fail-topic"
}

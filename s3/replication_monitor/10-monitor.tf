module "monitor_s3_replication_failures" {
  source        = "git@github.com:powise/terraform-modules//datadog/monitors?ref=datadog-monitors-1.0.0"
  name          = "S3 bucket ${local.monitor_name} failed to replicate"
  type          = "event-v2 alert"
  message       = "{{message.name}}"
  monitor_query = "events(\"source:amazon_sns AND topic:${local.sns_replication_topic_name}\").rollup(\"count\").by(\"@evt.id\").last(\"5m\")"
  operator      = ">="
  critical      = 1
  include_tags  = false
  notify_teams  = ["@slack-product-infrastructure-alerts"]
  tags          = var.tags
}

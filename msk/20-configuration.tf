locals {
  configuration_properties = merge(var.configuration_properties_extra, {
    "auto.create.topics.enable"      = var.configuration_properties.auto_create_topics
    "log.retention.hours"            = var.configuration_properties.log_retention_hours
    "default.replication.factor"     = var.configuration_properties.default_replication_factor
    "min.insync.replicas"            = var.configuration_properties.min_insync_replicas
    "num.partitions"                 = var.configuration_properties.num_partitions
    "num.io.threads"                 = var.configuration_properties.num_io_threads
    "num.network.threads"            = var.configuration_properties.num_network_threads
    "num.replica.fetchers"           = var.configuration_properties.num_replica_fetchers
    "socket.request.max.bytes"       = var.configuration_properties.socket_request_max_bytes
    "unclean.leader.election.enable" = var.configuration_properties.unclean_leader_election_enable
  })
}

resource "aws_msk_configuration" "config" {
  count = var.configuration_arn == null ? 1 : 0

  kafka_versions = [var.kafka_version]
  name           = coalesce(var.configuration_name, "${local.full_name}-config-v${replace(var.kafka_version, ".", "-")}")
  description    = "Manages an Amazon Managed Streaming for Kafka configuration for ${local.full_name} cluster."

  server_properties = join("\n", [
    for k in keys(local.configuration_properties) : format("%s=%s", k, local.configuration_properties[k])
  ])

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  configuration_arn      = coalesce(var.configuration_arn, aws_msk_configuration.config[0].arn)
  configuration_revision = coalesce(var.configuration_revision, aws_msk_configuration.config[0].latest_revision)
}

resource "aws_mskconnect_custom_plugin" "plugin" {
  name        = var.name
  description = var.description

  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = var.plugin_bucket_arn
      file_key   = var.plugin_path
    }
  }

  tags = var.tags
}

locals {
  # These parameters must be part of the _worker_ configuration and cannot be in the _connector_ configuration
  worker_configuration = merge(
    {
      # Offset continuity, re-uses the same topic to manage offsets even when recreating the connector
      # See https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-workers.html#msk-connect-manage-connector-offsets
      "offset.storage.topic" = "__amazon_msk_connect_offsets_${var.name}_${data.aws_region.current.name}"

      # Fine-tune partition counts for a 3 broker setup
      "offset.storage.partitions" = "24" # Default is 25 (multiples of 3 are better when using 3 brokers)
      "status.storage.partitions" = "6"  # Default is 5

      # Start consuming from latest offset, to avoid a huge backfill in prod
      "consumer.auto.offset.reset" = "latest"

      # Consume more at once to be able to catch up when consumer lag is high
      "max.poll.records" = "2000" # Default is 500

      # Allow consumer to stay alive for longer and not get kicked
      "max.poll.interval.ms" = "900000" # 15 minutes (default is 5 min)
      "session.timeout.ms"   = "120000" # Default is 45000

      # Default worker config
      "key.converter"   = "org.apache.kafka.connect.storage.StringConverter"
      "value.converter" = "org.apache.kafka.connect.storage.StringConverter"
    },
    var.custom_worker_config,
    var.custom_worker_config_sensitive,
  )
}

resource "aws_mskconnect_worker_configuration" "config" {
  name                    = var.name
  description             = "Worker configuration for ${var.name}."
  properties_file_content = join("\n", [for k, v in local.worker_configuration : "${k}=${v}"])

  tags = var.tags
}

resource "aws_mskconnect_connector" "connector" {
  name        = var.name
  description = var.description

  kafkaconnect_version = "2.7.1"

  capacity {
    autoscaling {
      mcu_count        = var.worker_mcu_count
      min_worker_count = var.min_worker_count
      max_worker_count = var.max_worker_count

      scale_in_policy {
        cpu_utilization_percentage = var.scale_in_cpu_percentage
      }

      scale_out_policy {
        cpu_utilization_percentage = var.scale_out_cpu_percentage
      }
    }
  }

  connector_configuration = merge(
    {
      # List of topics
      "topics" = join(",", var.kafka_topics)

      # Max tasks count
      "tasks.max" = var.max_tasks_count
    },
    local.default_connector_configuration[var.connector_mode],
    var.custom_config,
    var.custom_config_sensitive,
  )

  worker_configuration {
    arn      = aws_mskconnect_worker_configuration.config.arn
    revision = aws_mskconnect_worker_configuration.config.latest_revision
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = var.msk_bootstrap_brokers_tls
      vpc {
        security_groups = var.msk_security_group_ids
        subnets         = var.msk_subnet_ids
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "NONE"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS"
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.plugin.arn
      revision = aws_mskconnect_custom_plugin.plugin.latest_revision
    }
  }

  log_delivery {
    worker_log_delivery {
      cloudwatch_logs {
        enabled   = true
        log_group = local.cloudwatch_log_group_name
      }
    }
  }

  service_execution_role_arn = aws_iam_role.msk_connect.arn

  lifecycle {
    precondition {
      condition     = var.connector_mode == "s3" ? (var.output_bucket_name != null) : true
      error_message = "The output bucket name cannot be null in 's3' mode."
    }
  }

  tags = var.tags
}

resource "aws_msk_cluster" "cluster" {
  #checkov:skip=CKV_AWS_80:Skipping `Amazon MSK cluster logging is not enabled` check since it can be enabled with cloudwatch_logs_enabled = true
  # tflint-ignore: aws_msk_cluster_invalid_cluster_name
  cluster_name           = local.full_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_per_zone * length(local.subnet_ids)
  enhanced_monitoring    = var.monitoring_level
  storage_mode           = var.storage_mode

  broker_node_group_info {
    client_subnets  = local.subnet_ids
    instance_type   = var.broker_instance_type
    security_groups = [aws_security_group.security_group.id]

    storage_info {
      ebs_storage_info {
        volume_size = var.storage_gb_per_broker
      }
    }
  }

  configuration_info {
    arn      = local.configuration_arn
    revision = local.configuration_revision
  }

  encryption_info {
    encryption_in_transit {
      client_broker = var.client_broker
      in_cluster    = var.encryption_in_cluster
    }
    encryption_at_rest_kms_key_arn = local.kms_key_arn
  }

  dynamic "client_authentication" {
    for_each = var.client_tls_auth_enabled || var.client_sasl_scram_enabled || var.client_sasl_iam_enabled || var.client_allow_unauthenticated ? [1] : []
    content {
      dynamic "tls" {
        for_each = var.client_tls_auth_enabled ? [1] : []
        content {
          certificate_authority_arns = var.certificate_authority_arns
        }
      }
      sasl {
        scram = var.client_sasl_scram_enabled
        iam   = var.client_sasl_iam_enabled
      }
      unauthenticated = var.client_allow_unauthenticated
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.jmx_exporter_enabled
      }
      node_exporter {
        enabled_in_broker = var.node_exporter_enabled
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloudwatch_logs_enabled
        log_group = local.cloudwatch_logs_log_group
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to ebs_volume_size in favor of autoscaling policy
      broker_node_group_info[0].storage_info[0].ebs_storage_info[0].volume_size,
      # https://github.com/hashicorp/terraform-provider-aws/issues/24914
      client_authentication[0].tls,
    ]
  }

  tags = local.tags
}

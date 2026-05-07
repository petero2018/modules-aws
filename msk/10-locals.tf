locals {
  # Cluster full name
  full_name = var.full_name != null ? var.full_name : (var.name != null ? "msk-${var.name}-${var.env}-${var.aws_region}" : "unknown")

  # var.client_broker types
  plaintext     = "PLAINTEXT"
  tls_plaintext = "TLS_PLAINTEXT"
  tls           = "TLS"

  protocols = {
    # Broker protocols
    broker_plaintext = {
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#bootstrap_brokers
      name    = "Broker plaintext"
      port    = 9092
      enabled = contains([local.plaintext, local.tls_plaintext], var.client_broker)
      cidrs   = var.enable_broker_access_from_cidrs
      sgs     = var.enable_broker_access_from_sg
    }
    broker_tls = {
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#bootstrap_brokers_tls
      name    = "Broker TLS"
      port    = 9094
      enabled = contains([local.tls_plaintext, local.tls], var.client_broker)
      cidrs   = var.enable_broker_access_from_cidrs
      sgs     = var.enable_broker_access_from_sg
    }
    broker_sasl_scram = {
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#bootstrap_brokers_sasl_scram
      name    = "Broker SASL/SCRAM"
      port    = 9096
      enabled = var.client_sasl_scram_enabled && contains([local.tls_plaintext, local.tls], var.client_broker)
      cidrs   = var.enable_broker_access_from_cidrs
      sgs     = var.enable_broker_access_from_sg
    }
    broker_sasl_iam = {
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster#bootstrap_brokers_sasl_iam
      name    = "Broker SASL/IAM"
      port    = 9098
      enabled = var.client_sasl_iam_enabled && contains([local.tls_plaintext, local.tls], var.client_broker)
      cidrs   = var.enable_broker_access_from_cidrs
      sgs     = var.enable_broker_access_from_sg
    }
    # Zookeeper protocols
    zookeeper_plaintext = {
      name    = "Zookeeper plaintext"
      port    = 2181
      enabled = true
      cidrs   = var.enable_zookeeper_access_from_cidrs
      sgs     = var.enable_zookeeper_access_from_sg
    }
    zookeeper_tls = {
      name    = "Zookeeper TLS"
      port    = 2182
      enabled = true
      cidrs   = var.enable_zookeeper_access_from_cidrs
      sgs     = var.enable_zookeeper_access_from_sg
    }
    # Prometheus metrics
    jmx_exporter = {
      name    = "JMX Exporter"
      enabled = var.jmx_exporter_enabled
      cidrs   = var.enable_monitoring_access_from_cidrs
      sgs     = var.enable_monitoring_access_from_sg
      port    = 11001
    }
    node_exporter = {
      name    = "Node Exporter"
      enabled = var.node_exporter_enabled
      cidrs   = var.enable_monitoring_access_from_cidrs
      sgs     = var.enable_monitoring_access_from_sg
      port    = 11002
    }
  }

  # Filter enabled protocols and expand into array of (protocol, cidr/sg) pairs
  enabled_cidrs = concat([for protocol, config in local.protocols : setproduct([protocol], config.cidrs) if config.enabled]...)
  enabled_sgs   = concat([for protocol, config in local.protocols : setproduct([protocol], config.sgs) if config.enabled]...)

  # Generate ingress rules from the arrays of (protocol, cidr/sg) pairs
  cidr_ingress_rules = { for p in local.enabled_cidrs : "${p[0]}_${p[1]}" => { protocol = local.protocols[p[0]], cidr = p[1] } if length(p) == 2 }
  sg_ingress_rules   = { for p in local.enabled_sgs : "${p[0]}_${p[1]}" => { protocol = local.protocols[p[0]], sg = p[1] } if length(p) == 2 }

  # Tags
  tags = merge({
    terraform_module = "git@github.com:powise/terraform-modules//aws/msk"
  }, var.tags)
}

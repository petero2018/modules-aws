locals {
  target_weights = {
    for lb, clusters in var.switch_config :
    lb => {
      for cluster, config in clusters :
      cluster => config["weight"]
    }
  }

  environment = {
    for lb, colors in var.switch_config :
    lb => var.environment
  }

  active_eks_cluster = {
    for lb, clusters in var.switch_config :
    lb => clusters.blue.weight >= clusters.green.weight ? "${var.environment}-blue" : "${var.environment}-green"
  }

  inactive_eks_cluster = {
    for lb, clusters in var.switch_config :
    lb => clusters.blue.weight >= clusters.green.weight ? "${var.environment}-green" : "${var.environment}-blue"
  }

  eks_cluster_modality = {
    for lb, clusters in var.switch_config :
    lb => clusters.blue.enabled && clusters.green.enabled ? "both" : "active"
  }
}

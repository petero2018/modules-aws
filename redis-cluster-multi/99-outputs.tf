output "cluster_address" {
  value = var.create_resources ? {
    for cluster_name, cluster_config in var.clusters : cluster_name => module.elasticache[cluster_name].cluster_address
  } : tomap({})

  description = "Address of the first cache node for each cluster."
}

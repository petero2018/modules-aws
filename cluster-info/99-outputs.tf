output "active_eks_cluster" {
  value = local.active_eks_cluster

  description = "Cluster to which majority (or all!) of traffic is routed."
}

output "inactive_eks_cluster" {
  value = local.inactive_eks_cluster

  description = "Cluster to which minority (or nothing!) of traffic is routed."
}

output "enabled_clusters" {
  value = local.enabled_clusters

  description = "List of the clusters we enable for the given environment."
}

output "disabled_clusters" {
  value = local.disabled_clusters

  description = "List of the clusters we disable for the given environment."
}

output "all_clusters" {
  value = local.all_clusters

  description = "List of all clusters we have for the given environment."
}

output "enabled" {
  value = local.enabled

  description = "Convenience <cluster_name>:<true|false> map to query cluster state."
}

output "count" {
  value = local.count

  description = "Convenience <cluster_name>:1|0> map to query cluster state."
}

output "target_weights" {
  value       = local.target_weights
  description = "Relative weights of the target traffic distribution."
}

output "environment" {
  value = local.environment

  description = "Cluster environment (\"dev\", \"prod\" or \"dr\")."
}

output "active_eks_cluster" {
  value = local.active_eks_cluster

  description = "Cluster to which majority (or all!) of traffic is routed."
}

output "inactive_eks_cluster" {
  value = local.inactive_eks_cluster

  description = "Cluster to which minority (or nothing!) of traffic is routed."
}

output "eks_cluster_modality" {
  value = local.eks_cluster_modality

  description = "Do we route traffic to both active and inactive clusters or only to active cluster?"
}

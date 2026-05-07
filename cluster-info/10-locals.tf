locals {
  ssm_key_prefix = "/${var.environment}/config/deploy"

  active_eks_cluster   = data.aws_ssm_parameter.active_eks_cluster.value
  inactive_eks_cluster = data.aws_ssm_parameter.inactive_eks_cluster.value
  eks_cluster_modality = data.aws_ssm_parameter.eks_cluster_modality.value

  enabled_clusters  = local.eks_cluster_modality == "both" ? [local.active_eks_cluster, local.inactive_eks_cluster] : [local.active_eks_cluster]
  disabled_clusters = local.eks_cluster_modality == "both" ? [] : [local.inactive_eks_cluster]
  all_clusters      = [local.active_eks_cluster, local.inactive_eks_cluster]

  enabled = {
    (local.active_eks_cluster) : true,
    (local.inactive_eks_cluster) : local.eks_cluster_modality == "both",
  }

  count = {
    (local.active_eks_cluster) : 1,
    (local.inactive_eks_cluster) : local.eks_cluster_modality == "both" ? 1 : 0,
  }
}

data "aws_ssm_parameter" "active_eks_cluster" {
  name = "${local.ssm_key_prefix}/active_eks_cluster"
}

data "aws_ssm_parameter" "inactive_eks_cluster" {
  name = "${local.ssm_key_prefix}/inactive_eks_cluster"
}

data "aws_ssm_parameter" "eks_cluster_modality" {
  name = "${local.ssm_key_prefix}/eks_cluster_modality"
}

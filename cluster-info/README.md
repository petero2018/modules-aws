# cluster-info

Expose EKS cluster information from SSM.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.active_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.eks_cluster_modality](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.inactive_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Cluster environment ("dev", "prod" or "dr"). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_eks_cluster"></a> [active\_eks\_cluster](#output\_active\_eks\_cluster) | Cluster to which majority (or all!) of traffic is routed. |
| <a name="output_all_clusters"></a> [all\_clusters](#output\_all\_clusters) | List of all clusters we have for the given environment. |
| <a name="output_count"></a> [count](#output\_count) | Convenience <cluster\_name>:1\|0> map to query cluster state. |
| <a name="output_disabled_clusters"></a> [disabled\_clusters](#output\_disabled\_clusters) | List of the clusters we disable for the given environment. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Convenience <cluster\_name>:<true\|false> map to query cluster state. |
| <a name="output_enabled_clusters"></a> [enabled\_clusters](#output\_enabled\_clusters) | List of the clusters we enable for the given environment. |
| <a name="output_inactive_eks_cluster"></a> [inactive\_eks\_cluster](#output\_inactive\_eks\_cluster) | Cluster to which minority (or nothing!) of traffic is routed. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

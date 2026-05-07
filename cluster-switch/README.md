# cluster-switch

Generate traffic weight distribution for PROXYv3.

```hcl
module "sample_cluster_switch" {
  source = "git@github.com:powise/terraform-modules//aws/cluster-switch?ref=aws-cluster-switch-2.0.0"

  environment = "dev"

  switch_config = {
    "public" = {
      blue = {
        enabled = false,
        weight  = 0,
      },
      green = {
        enabled = true,
        weight  = 100,
      }
    }
    ...
  }

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Cluster environment ("dev", "staging", "prod" or "dr"). | `string` | n/a | yes |
| <a name="input_switch_config"></a> [switch\_config](#input\_switch\_config) | Cluster traffic weight distribution config. | <pre>map(object({<br>    blue = object({<br>      enabled = bool<br>      weight  = number<br>    })<br>    green = object({<br>      enabled = bool<br>      weight  = number<br>    })<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_eks_cluster"></a> [active\_eks\_cluster](#output\_active\_eks\_cluster) | Cluster to which majority (or all!) of traffic is routed. |
| <a name="output_eks_cluster_modality"></a> [eks\_cluster\_modality](#output\_eks\_cluster\_modality) | Do we route traffic to both active and inactive clusters or only to active cluster? |
| <a name="output_environment"></a> [environment](#output\_environment) | Cluster environment ("dev", "prod" or "dr"). |
| <a name="output_inactive_eks_cluster"></a> [inactive\_eks\_cluster](#output\_inactive\_eks\_cluster) | Cluster to which minority (or nothing!) of traffic is routed. |
| <a name="output_target_weights"></a> [target\_weights](#output\_target\_weights) | Relative weights of the target traffic distribution. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

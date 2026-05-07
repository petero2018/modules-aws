# Addon Images

For addons that pull images from a region-specific ECR container registry by default
for more information see: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.4 |
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
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Image to get the URL. Keep empty if want to get only the repository | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_image_repository"></a> [image\_repository](#output\_image\_repository) | Local AWS Repository for the image |
| <a name="output_local_registry"></a> [local\_registry](#output\_local\_registry) | Local AWS Registry |
| <a name="output_registry_by_zone"></a> [registry\_by\_zone](#output\_registry\_by\_zone) | All AWS Registry by region |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

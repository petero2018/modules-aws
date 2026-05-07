# certificates

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_certificate"></a> [certificate](#module\_certificate) | jpamies/certificate/aws | ~>1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Deploy environment ("dev", "prod" or "tools"). | `string` | n/a | yes |
| <a name="input_hostnames"></a> [hostnames](#input\_hostnames) | <namespace>:<hostname> records to issue ACM certificates for. | `map(string)` | n/a | yes |
| <a name="input_main_namespaces"></a> [main\_namespaces](#input\_main\_namespaces) | Namespaces to deploy our prod/dev applications and route traffic into via external "blue/green" proxy. | `list(string)` | `[]` | no |
| <a name="input_route53_zone"></a> [route53\_zone](#input\_route53\_zone) | Name of the Route53 zone to use for certificate DNS validation. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arns"></a> [acm\_certificate\_arns](#output\_acm\_certificate\_arns) | A map of <hostname>:<ACM certificate> values. |
| <a name="output_hostnames"></a> [hostnames](#output\_hostnames) | <namespace>:<hostname> records to issue ACM certificates for. |
| <a name="output_route53_zone_id"></a> [route53\_zone\_id](#output\_route53\_zone\_id) | ID of the Route53 zone used to valudate certificates. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# global-accelerator

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
| [aws_globalaccelerator_accelerator.accelerator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_accelerator) | resource |
| [aws_globalaccelerator_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_listener) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_affinity"></a> [client\_affinity](#input\_client\_affinity) | Client affinity setting on the listener. | `string` | `"NONE"` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | Value of the Global Accelerator address type. | `string` | `"IPV4"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Global Accelerator. | `string` | n/a | yes |
| <a name="input_ports"></a> [ports](#input\_ports) | Ports the Global Accelerator should listen on. | `list(number)` | <pre>[<br>  80,<br>  443<br>]</pre> | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | Protocol the Global Accelerator should listen on. | `string` | `"TCP"` | no |
| <a name="input_route53_records"></a> [route53\_records](#input\_route53\_records) | Route53 records to create and associate to the Global Accelerator (Route53 Zone ID => list of records). | `map(list(string))` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_global_accelerator_arn"></a> [global\_accelerator\_arn](#output\_global\_accelerator\_arn) | ARN of the Global Accelerator. |
| <a name="output_listener_arn"></a> [listener\_arn](#output\_listener\_arn) | ARN of the Global Accelerator Listener. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

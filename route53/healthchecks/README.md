# healthchecks

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
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
| [aws_route53_health_check.aggregated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) | resource |
| [aws_route53_health_check.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aggregated_health_check_name"></a> [aggregated\_health\_check\_name](#input\_aggregated\_health\_check\_name) | If true, an additional health check will be created with this name, which aggregates all health checks in the healthchecks map. | `string` | `""` | no |
| <a name="input_aggregated_health_check_threshold"></a> [aggregated\_health\_check\_threshold](#input\_aggregated\_health\_check\_threshold) | value of the child health threshold for the aggregated health check. If not set, or set to 0, it will be set to the length of the healthchecks map. | `number` | `0` | no |
| <a name="input_healthchecks"></a> [healthchecks](#input\_healthchecks) | Map of healthcheck configurations, map key is used as the Name tag on each healthcheck. | <pre>map(<br>    object({<br>      domain            = string<br>      port              = optional(number, 443)<br>      path              = optional(string, "/")<br>      type              = optional(string, "HTTPS")<br>      interval          = optional(number, 10)<br>      failure_threshold = optional(number, 3)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags on the healthcheck. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aggregated_health_check_arn"></a> [aggregated\_health\_check\_arn](#output\_aggregated\_health\_check\_arn) | The Amazon Resource Name (ARN) of the aggregated health check. |
| <a name="output_aggregated_health_check_id"></a> [aggregated\_health\_check\_id](#output\_aggregated\_health\_check\_id) | The ID of the aggregated health check. |
| <a name="output_health_check_arns"></a> [health\_check\_arns](#output\_health\_check\_arns) | The Amazon Resource Name (ARN) of the Health Check. |
| <a name="output_health_check_ids"></a> [health\_check\_ids](#output\_health\_check\_ids) | The id of the health check. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

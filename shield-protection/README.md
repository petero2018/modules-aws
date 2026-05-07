# shield-protection

Configures a specific resource with AWS Shield Advanced protection.

Normally, resources are protected by Shield Advanced via an organization-level FMS policy.
However in some cases we want to manually manage the protection, for example when we want to associate Route53 health checks with the protection resource

In such cases, tag the resource being protected `security:shield-adv-enabled = false` (NOTE: case sensitivity matters. Be sure to use lowercase)

```terraform
resource "aws_lb" "manually_protected" {
  ...

  tags = {
    "security:shield-adv-enabled" = "false"
  }
}

module "shield-protection" {
  name = "MyALBProtection"

  protected_resource_arn = aws_lb.manually_protected.arn

  ...
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.39.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.39.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_shield_application_layer_automatic_response.application_layer_protection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_application_layer_automatic_response) | resource |
| [aws_shield_protection.protected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection_health_check_association.healthcheck](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection_health_check_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_layer_protection_mode"></a> [application\_layer\_protection\_mode](#input\_application\_layer\_protection\_mode) | Whether application layer protection should be enabled. Valid values are 'BLOCK', 'COUNT' or 'DISABLED' | `string` | `"BLOCK"` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | The ARN of the Route53 healthcheck to associate with the protection | <pre>object({<br>    enabled = bool<br>    arn     = string<br>  })</pre> | <pre>{<br>  "arn": null,<br>  "enabled": false<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the protection to be created | `string` | n/a | yes |
| <a name="input_protected_resource_arn"></a> [protected\_resource\_arn](#input\_protected\_resource\_arn) | The arn of the resource to be protected by AWS Shield | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | value of the tags to be applied to resources created by this module | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

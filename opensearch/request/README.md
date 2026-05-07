# OpenSearch Plain Request

Sends an HTTP request to OpenSearch, useful when the provider doesn't support something.

> **Warning**
> This only works to create/update resources, not to manage them
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >=3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >=3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.request](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_session_context.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_body"></a> [body](#input\_body) | Body to send to OpenSearch. | `map(any)` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | OpenSearch endpoint to send the requests. | `string` | n/a | yes |
| <a name="input_method"></a> [method](#input\_method) | HTTP Method to send to OpenSearch. | `string` | `"PUT"` | no |
| <a name="input_path"></a> [path](#input\_path) | HTTP Path to send to OpenSearch. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

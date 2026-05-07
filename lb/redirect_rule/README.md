# redirect_rule

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener_rule.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_condition_headers"></a> [condition\_headers](#input\_condition\_headers) | A list of headers which, if matched, will cause the redirect. | `list(string)` | `[]` | no |
| <a name="input_condition_hosts"></a> [condition\_hosts](#input\_condition\_hosts) | A list of hosts which, if matched, will cause the redirect. | `list(string)` | `[]` | no |
| <a name="input_condition_paths"></a> [condition\_paths](#input\_condition\_paths) | A list of paths (excluding query strings) which, if matched, will cause the redirect. | `list(string)` | `[]` | no |
| <a name="input_condition_query_strings"></a> [condition\_query\_strings](#input\_condition\_query\_strings) | A list of query strings. The key can be an empty string which will mean only the value is considered. Each map will be AND'd with each other while key, value pairs within each map will be OR'd together | `list(map(string))` | `[]` | no |
| <a name="input_condition_request_methods"></a> [condition\_request\_methods](#input\_condition\_request\_methods) | A list of request methods which, if matched, will cause the redirect. | `list(string)` | `[]` | no |
| <a name="input_condition_source_ips"></a> [condition\_source\_ips](#input\_condition\_source\_ips) | A list of IPv4 or IPv6 IPs in CIDR notation which, if matched, will cause the redirect. | `list(string)` | `[]` | no |
| <a name="input_is_permanent"></a> [is\_permanent](#input\_is\_permanent) | If true, the redirect will use the 301 status code. Otherwise, 302 will be used. | `bool` | `true` | no |
| <a name="input_listener_arn"></a> [listener\_arn](#input\_listener\_arn) | The ALB Listener with which the redirect rule will be associated | `string` | n/a | yes |
| <a name="input_priority"></a> [priority](#input\_priority) | The priority of the redirect rule. Lower numbers are processed first. | `number` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_target_host"></a> [target\_host](#input\_target\_host) | The destination host to which the client will be redirected. | `string` | `"#{host}"` | no |
| <a name="input_target_path"></a> [target\_path](#input\_target\_path) | The destination path to which the client will be redirected. | `string` | `"/#{path}"` | no |
| <a name="input_target_port"></a> [target\_port](#input\_target\_port) | The destination target\_port to which the client will be redirected. | `string` | `"#{port}"` | no |
| <a name="input_target_protocol"></a> [target\_protocol](#input\_target\_protocol) | The destination protocol used for the redirect. | `string` | `"#{protocol}"` | no |
| <a name="input_target_query"></a> [target\_query](#input\_target\_query) | The destination query string parameters included in the redirect. | `string` | `"#{query}"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

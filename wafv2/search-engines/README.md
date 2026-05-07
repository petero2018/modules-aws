# search-engines

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~>2.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~>2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.waf_search_engines_1h](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.waf_search_engines_1h](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.waf_lambda_policy_search_engines](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.waf_lambda_role_search_engines](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.waf_lambda_policy_search_engines](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.waf_search_engines](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.trigger_on_create](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_permission.search_engine_allow_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_wafv2_ip_set.search_engines_ipv4_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.search_engines_ipv4_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.search_engines_ipv6_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.search_engines_ipv6_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [archive_file.lambda_search_engines_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lambda_assume_role_search_engines](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_policy_search_engines](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_cloudfront_ip_lists"></a> [create\_cloudfront\_ip\_lists](#input\_create\_cloudfront\_ip\_lists) | If true, this module creates and populates GLOBAL-scoped IPSets. | `bool` | `false` | no |
| <a name="input_create_regional_ip_lists"></a> [create\_regional\_ip\_lists](#input\_create\_regional\_ip\_lists) | If true, this module creates and populates REGIONAL-scoped IPSets. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ipset_ipv4_cloudfront_arn"></a> [ipset\_ipv4\_cloudfront\_arn](#output\_ipset\_ipv4\_cloudfront\_arn) | The ARN of the Cloudfront ipset containing known search engines' IPv4 addresses. |
| <a name="output_ipset_ipv4_regional_arn"></a> [ipset\_ipv4\_regional\_arn](#output\_ipset\_ipv4\_regional\_arn) | The ARN of the ipset containing known search engines' IPv4 addresses. |
| <a name="output_ipset_ipv6_cloudfront_arn"></a> [ipset\_ipv6\_cloudfront\_arn](#output\_ipset\_ipv6\_cloudfront\_arn) | The ARN of the Cloudfront ipset containing known search engines' IPv6 addresses. |
| <a name="output_ipset_ipv6_regional_arn"></a> [ipset\_ipv6\_regional\_arn](#output\_ipset\_ipv6\_regional\_arn) | The ARN of the ipset containing known search engines' IPv6 addresses. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

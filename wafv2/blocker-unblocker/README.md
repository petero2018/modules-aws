# blocker-unblocker

## Example Usage

```hcl

module "blocker_unblocker" {
  source = "git@github.com:powise/terraform-modules//aws/wafv2/blocker-unblocker?ref=aws-wafv2-blocker-unblocker-<TAG>"

  # All IPSets in these lists will be updated to include blocked IPs
  block_ipset_arns_ipv4 = [
    aws_wafv2_ip_set.test_blocklist_ipv4.arn
    aws_wafv2_ip_set.test_cloudfront_blocklist_ipv4.arn
  ]
  block_ipset_arns_ipv6 = [aws_wafv2_ip_set.test_blocklist_ipv6.arn]

  # All IPSets in these lists will be updated to include allowed IPs
  allow_ipset_arns_ipv4 = [aws_wafv2_ip_set.test_allowlist_ipv4.arn]
  allow_ipset_arns_ipv6 = [aws_wafv2_ip_set.test_allowlist_ipv6.arn]

  # IPs in either this or the equivalent _ipv6 list will result in permanent items in the whitelist DynamoDB table
  ip_whitelist_ipv4 = [
    data.aws_vpc.dev.cidr_block
  ]

  aws_region     = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.default.account_id
}

```

powise maintains a number of WAFs, which can block or allow requests independently, and these do not take into account the history of the IP address. AWS WAFv2's ratelimiting, for example, only blocks addresses for 5 minute periods and we want to block attacking IP addresses for longer periods (e.g. 2 hours).

This module creates the needed infrastructure to easily add IP addresses to WAF blocklists for a set amount of time (2 hours by default).

- Two Lambda functions are created:
  - `WAF-Blocker` recieves incoming SNS messages and adds them to the block DynamoDB table
  - `WAF-Updater` runs periodically and updates all subscribed IPSets to match what is in the two DynamoDB tables
- Two DynamoDB tables are also created: one to store the blocked addresses and another one to store a whitelist (addresses that never will be blocked).
- One SNS topic is created to receive IPs to be blocked. IPs are sent by script(s) maintained outside of this module.
- CloudWatch event to execute the `WAF-Updater` lambda (currently every minute)
- IAM roles and policies to glue all the aforementioned services together.

The IP addresses sent to the SNS topic in this module must have one of these formats: `IP,version,timestamp` or `IP,version,number_of_seconds`, where `version` must be one of `v4` or `v6`. In the first format the timestamp is ignored and the IP will be blocked for 2 hours. In the second format the IP address will be blocked for the specified number of seconds.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.31 |
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
| [aws_cloudwatch_event_rule.waf_updater](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.waf_updater](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_dynamodb_table.waf_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.waf_blocks_whitelist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table_item.ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_dynamodb_table_item.ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_iam_policy.waf_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.waf_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.waf_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.sns_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.sns_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.waf_blocker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.waf_updater](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.common](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.allow_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.allow_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.waf_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.waf_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.waf_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [archive_file.common_layer_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.lambda_blocker_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.lambda_updater_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ipset_arns_ipv4"></a> [allow\_ipset\_arns\_ipv4](#input\_allow\_ipset\_arns\_ipv4) | IP Set(s) ARN(s) from the WAF(s) where IPs will be allowed. | `list(string)` | n/a | yes |
| <a name="input_allow_ipset_arns_ipv6"></a> [allow\_ipset\_arns\_ipv6](#input\_allow\_ipset\_arns\_ipv6) | IP Set(s) ARN(s) from the WAF(s) where IPs will be allowed. | `list(string)` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | 12-digit AWS account ID where the WAF is | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region in which to deploy the Lambdas. This already decided by the AWS provider, but it is required in this case to prevent a circular dependency | `string` | n/a | yes |
| <a name="input_block_ipset_arns_ipv4"></a> [block\_ipset\_arns\_ipv4](#input\_block\_ipset\_arns\_ipv4) | IP Set(s) ARN(s) from the WAF(s) where IPs will be blocked. They will be unblocked automatically after a set time. | `list(string)` | n/a | yes |
| <a name="input_block_ipset_arns_ipv6"></a> [block\_ipset\_arns\_ipv6](#input\_block\_ipset\_arns\_ipv6) | IP Set(s) ARN(s) from the WAF(s) where IPs will be blocked. They will be unblocked automatically after a set time. | `list(string)` | n/a | yes |
| <a name="input_enable_unblocker_schedule"></a> [enable\_unblocker\_schedule](#input\_enable\_unblocker\_schedule) | Whether the unblocker should be automatically run periodically. | `bool` | `true` | no |
| <a name="input_ip_whitelist_ipv4"></a> [ip\_whitelist\_ipv4](#input\_ip\_whitelist\_ipv4) | List of IPs that are never blocked | `list(string)` | `[]` | no |
| <a name="input_ip_whitelist_ipv6"></a> [ip\_whitelist\_ipv6](#input\_ip\_whitelist\_ipv6) | List of IPs that are never blocked | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

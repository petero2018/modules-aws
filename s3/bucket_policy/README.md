# bucket_policy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_elb_service_account.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.cloudfront_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.combined_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deny_insecure_transport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lb_log_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication_destination_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.require_encrypted_uploads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.require_latest_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.template_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_read_from_account_ids"></a> [allow\_read\_from\_account\_ids](#input\_allow\_read\_from\_account\_ids) | List of AWS account IDs that will be allowed to read the bucket. | `list(number)` | `[]` | no |
| <a name="input_attach_lb_log_delivery_policy"></a> [attach\_lb\_log\_delivery\_policy](#input\_attach\_lb\_log\_delivery\_policy) | Controls if S3 bucket should have ALB/NLB log delivery policy attached | `bool` | `false` | no |
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | The S3 bucket ARN. | `string` | n/a | yes |
| <a name="input_bucket_id"></a> [bucket\_id](#input\_bucket\_id) | The S3 bucket ID. | `string` | n/a | yes |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | Bucket policy to attach. Must be in JSON format. | `string` | `null` | no |
| <a name="input_bucket_policy_template"></a> [bucket\_policy\_template](#input\_bucket\_policy\_template) | Bucket policy template. useful when you don't know the bucket name. | <pre>map(object({<br>    effect         = optional(string) # by default Allow<br>    principal_type = optional(string) # by default AWS<br>    principals     = list(string)<br>    actions        = list(string)<br>    paths          = optional(list(string)) # by default /*<br>    conditions = optional(list(object({<br>      test     = string<br>      variable = string<br>      values   = list(string)<br>    })))<br>  }))</pre> | `{}` | no |
| <a name="input_cloudfront_distribution_arns"></a> [cloudfront\_distribution\_arns](#input\_cloudfront\_distribution\_arns) | Allow these CloudFront distribution ARNs to access the bucket in the policy (optional). | `list(string)` | `[]` | no |
| <a name="input_deny_insecure_transport"></a> [deny\_insecure\_transport](#input\_deny\_insecure\_transport) | Whether to enable bucket policy to deny insecure transport in bucket policy. | `bool` | `true` | no |
| <a name="input_replication_role_arn"></a> [replication\_role\_arn](#input\_replication\_role\_arn) | IAM replication role ARN, set this to the replication role for replication target buckets (optional). | `string` | `null` | no |
| <a name="input_require_encrypted_uploads"></a> [require\_encrypted\_uploads](#input\_require\_encrypted\_uploads) | Whether to require encrypted uploads in bucket policy. Since SSE is enabled always this is not always needed. | `bool` | `false` | no |
| <a name="input_require_latest_tls"></a> [require\_latest\_tls](#input\_require\_latest\_tls) | Whether to enable bucket policy to require latest TLS in bucket policy. | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

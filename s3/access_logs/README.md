# access_logs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
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
| [aws_iam_policy.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.s3_bucket_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.bucket_policy_att](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.block_public_acls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.s3_bucket_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_bucket_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.s3_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.combined_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deny_insecure_transport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.require_encrypted_uploads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.require_latest_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deny_insecure_transport"></a> [deny\_insecure\_transport](#input\_deny\_insecure\_transport) | Whether to enable bucket policy to deny insecure transport in bucket policy. | `bool` | `true` | no |
| <a name="input_encryption_at_rest"></a> [encryption\_at\_rest](#input\_encryption\_at\_rest) | Encryption at rest settings for the bucket. | <pre>object({<br>    bucket_key_enabled = optional(bool)<br>    encryption_settings = object({<br>      sse_algorithm     = string<br>      kms_master_key_id = optional(string)<br>    })<br>  })</pre> | <pre>{<br>  "bucket_key_enabled": false,<br>  "encryption_settings": {<br>    "kms_master_key_id": null,<br>    "sse_algorithm": "AES256"<br>  }<br>}</pre> | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Indicates all objects should be deleted from the bucket so that it can be destroyed without error. | `bool` | `false` | no |
| <a name="input_public_access_block"></a> [public\_access\_block](#input\_public\_access\_block) | Options to block public access to the bucket. | <pre>object({<br>    ignore_public_acls      = optional(bool)<br>    block_public_policy     = optional(bool)<br>    block_public_acls       = optional(bool)<br>    restrict_public_buckets = optional(bool)<br>  })</pre> | <pre>{<br>  "block_public_acls": true,<br>  "block_public_policy": true,<br>  "ignore_public_acls": true,<br>  "restrict_public_buckets": true<br>}</pre> | no |
| <a name="input_require_encrypted_uploads"></a> [require\_encrypted\_uploads](#input\_require\_encrypted\_uploads) | Whether to require encrypted uploads in bucket policy. | `bool` | `true` | no |
| <a name="input_require_latest_tls"></a> [require\_latest\_tls](#input\_require\_latest\_tls) | Whether to enable bucket policy to require latest TLS in bucket policy. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | Access Logs S3 bucket arn |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Access Logs S3 bucket id |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | Region in which the S3 bucket is deployed. |
| <a name="output_replication_role"></a> [replication\_role](#output\_replication\_role) | Role for the bucket to replicate objects into another bucket. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

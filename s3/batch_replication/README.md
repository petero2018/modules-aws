# batch_replication

Creates the IAM role with required permissions to launch an S3 batch replication job, used mostly to copy existing objects to a backup bucket.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.31 |
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
| [aws_iam_role.s3_batch_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_batch_operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_batch_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_manifests_bucket_arn"></a> [manifests\_bucket\_arn](#input\_manifests\_bucket\_arn) | Bucket arn for replication job manifests. | `string` | n/a | yes |
| <a name="input_reports_bucket_arn"></a> [reports\_bucket\_arn](#input\_reports\_bucket\_arn) | Bucket arn to store replication reports. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags on AWS Backup related resources. | `map(string)` | <pre>{<br>  "impact": "critical",<br>  "service": "disaster-recovery",<br>  "team": "product-infrastructure"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

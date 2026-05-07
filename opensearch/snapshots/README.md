# snapshots

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.65 |
| <a name="requirement_opensearch"></a> [opensearch](#requirement\_opensearch) | >= 2.3.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.65 |
| <a name="provider_opensearch"></a> [opensearch](#provider\_opensearch) | >= 2.3.0 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket"></a> [bucket](#module\_bucket) | ../../s3/bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.s3_snapshots](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.s3_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [opensearch_sm_policy.snapshots](https://registry.terraform.io/providers/opensearch-project/opensearch/latest/docs/resources/sm_policy) | resource |
| [opensearch_snapshot_repository.repository](https://registry.terraform.io/providers/opensearch-project/opensearch/latest/docs/resources/snapshot_repository) | resource |
| [time_sleep.wait_for_role](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_iam_policy_document.snapshot_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | OpenSearch cluster name, used to name the snapshots IAM role. | `string` | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Map of { name => repository } of OpenSearch S3 snapshot repositories to set up. | <pre>map(object({<br>    bucket_name   = string<br>    bucket_region = string<br>    create_bucket = optional(bool, false)<br>    settings      = optional(map(string), {})<br>    snapshots = optional(object({<br>      enabled             = optional(bool, false)<br>      policy_name         = optional(string, "daily-snapshots")<br>      policy_description  = optional(string, "Daily cluster-wide snapshots")<br>      cron_expression     = optional(string, "0 4 * * *")<br>      cron_timezone       = optional(string, "UTC")<br>      time_limit          = optional(string, "2h")<br>      deletion_time_limit = optional(string, "2h")<br>      max_age             = optional(string, "15d")<br>      indices             = optional(string, "*")<br>      timezone            = optional(string, "UTC")<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

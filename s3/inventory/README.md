# inventory

## Example

```hcl
module "archived_events_inventory" {
    source      = "git@github.com:powise/terraform-modules//aws/s3/inventory?ref=aws-s3-inventory-0.0.1"
    bucket_name = aws_s3_bucket.archived_events.id
    bucket_arn  = aws_s3_bucket.archived_events.arn
    tags        = {
        team    = "product-infrastructure"
        impact  = "high"
        service = "datadog-msk"
    }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_inventory_bucket"></a> [inventory\_bucket](#module\_inventory\_bucket) | ../bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_athena_workgroup.workgroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup) | resource |
| [aws_s3_bucket_inventory.bucket_inventory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory) | resource |
| [random_string.s3_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_for_inventory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | ARN of the bucket to create an inventory for. | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the bucket to create an inventory for. | `string` | n/a | yes |
| <a name="input_delete_after_days"></a> [delete\_after\_days](#input\_delete\_after\_days) | Delete any inventory files that are this number of days old. | `number` | `14` | no |
| <a name="input_enable_athena"></a> [enable\_athena](#input\_enable\_athena) | If true creates an athena workgroup for the inventory bucket to be able to run queries against the inventory data. | `bool` | `false` | no |
| <a name="input_format"></a> [format](#input\_format) | Specifies the format of the inventory. It can be "CSV", "ORC" or "Parquet". Default is "ORC". | `string` | `"ORC"` | no |
| <a name="input_included_object_versions"></a> [included\_object\_versions](#input\_included\_object\_versions) | Specifies the object versions to include in the inventory results. It can be "All", or "Current". Default is "Current". | `string` | `"Current"` | no |
| <a name="input_optional_fields"></a> [optional\_fields](#input\_optional\_fields) | Fields to include on the inventory. Check possible values here: https://docs.aws.amazon.com/AmazonS3/latest/API/API_InventoryConfiguration.html#AmazonS3-Type-InventoryConfiguration-OptionalFields | `list(string)` | <pre>[<br>  "Size",<br>  "LastModifiedDate",<br>  "StorageClass",<br>  "IsMultipartUploaded",<br>  "ReplicationStatus",<br>  "EncryptionStatus",<br>  "ObjectLockRetainUntilDate",<br>  "ObjectLockMode",<br>  "ObjectLockLegalHoldStatus",<br>  "IntelligentTieringAccessTier",<br>  "BucketKeyStatus"<br>]</pre> | no |
| <a name="input_schedule_frequency"></a> [schedule\_frequency](#input\_schedule\_frequency) | Specifies the schedule for generating inventory results. It can be "Daily" or "Weekly". Default is "Weekly". | `string` | `"Weekly"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_athena_workgroup_name"></a> [athena\_workgroup\_name](#output\_athena\_workgroup\_name) | Name of the aws athena workgroup to use for qurying the bucket inventory data. |
| <a name="output_inventory_bucket_id"></a> [inventory\_bucket\_id](#output\_inventory\_bucket\_id) | Name of the bucket that will store the s3 inventory data. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

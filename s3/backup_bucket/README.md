# backup bucket

## Example

```hcl
module "s3_backup_bucket" {
  source = "git@github.com:powise/terraform-modules//aws/s3/backup_bucket?ref=aws-s3-backup-bucket-0.0.1"

  aws_backup_account_id = "1235467891011"
  src_bucket_name       = "example-bucket"

  replication_role_arn =  "arn:aws:iam::123456789012:role/sample-role"

  tags = {
    team    = "powise"
    service = "forms"
    impact  = "low"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup_bucket"></a> [backup\_bucket](#module\_backup\_bucket) | ../bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_random_suffix"></a> [add\_random\_suffix](#input\_add\_random\_suffix) | Whether to add a random string to bucket name to make it unique. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_storage_class_transition"></a> [enable\_storage\_class\_transition](#input\_enable\_storage\_class\_transition) | Whether to enable storage class transition lifecycle rule. | `bool` | `false` | no |
| <a name="input_expire_noncurrent"></a> [expire\_noncurrent](#input\_expire\_noncurrent) | Whether to expire non-current objects (i.e. with a delete marker). | `bool` | `true` | no |
| <a name="input_noncurrent_transition_days"></a> [noncurrent\_transition\_days](#input\_noncurrent\_transition\_days) | Number of days before expiring non-current objects, if enabled. | `number` | `7` | no |
| <a name="input_src_bucket_name"></a> [src\_bucket\_name](#input\_src\_bucket\_name) | Name of the source bucket to back up. | `string` | n/a | yes |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | The target storage class after the lifecycle transition rule execution. | `string` | `"GLACIER_IR"` | no |
| <a name="input_storage_class_transition_days"></a> [storage\_class\_transition\_days](#input\_storage\_class\_transition\_days) | Number of days after which the storage class transition should happen. | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_account_id"></a> [bucket\_account\_id](#output\_bucket\_account\_id) | Backup bucket AWS account ID. |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | Backup bucket ARN. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Backup bucket ID. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

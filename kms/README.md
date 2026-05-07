# kms

This is a generic KMS key module that should be used for creating a new Customer Managed Key (CMK) at powise. It provides support for encryption/decryption (most common) as well as digital signatures with flexibility as to which algorithm to use.

This also enforces tagging on resources and the following are required:

| **Tag** | **Value** |
|---------|-----------|
| team | The team responsible for the resource(s) |
| service | The service the resource is used for |
| impact | The *'blast radius'* of the resource. [ `critcal`, `high`, `low` ] |


## Example

```hcl
module "sample_key" {
  source = "git@github.com:powise/terraform-modules//aws/kms?ref=aws-kms-0.0.1"

  alias       = "s3-logs"
  description = "KMS Key for S3 encryption at rest."

  # Optional: Key Policy
  key_policy  = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow an external account to use this KMS key",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
              "arn:aws:iam::444455556666:root"
          ]
      },
      "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
      ],
      "Resource": "*"   # The key that this policy is attached to. It does not mean "every KMS key".
    }
  ]
}
POLICY

  tags = {
    team    = "frontend"
    service = "main-site"
    impact  = "critical"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.baseline_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.combined_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.common_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias"></a> [alias](#input\_alias) | The display name of the alias. Alias resource is already accounting for the "alias/" prefix that AWS requires. | `string` | n/a | yes |
| <a name="input_attach_common_key_policy"></a> [attach\_common\_key\_policy](#input\_attach\_common\_key\_policy) | Attach common policy to the key. | `bool` | `true` | no |
| <a name="input_common_admin_roles"></a> [common\_admin\_roles](#input\_common\_admin\_roles) | ARNs of IAM roles allowed to administer KMS key. | `list(string)` | `null` | no |
| <a name="input_common_decryption_roles"></a> [common\_decryption\_roles](#input\_common\_decryption\_roles) | ARNs of IAM roles allowed to decrypt using KMS key. | `list(string)` | `null` | no |
| <a name="input_common_encryption_roles"></a> [common\_encryption\_roles](#input\_common\_encryption\_roles) | ARNs of IAM roles allowed to encrypt using KMS key. | `list(string)` | `null` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | Signing or encryption algorithm supported by the key. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource. | `number` | `14` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the key as viewed in AWS console. | `string` | n/a | yes |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Specifies whether key rotation is enabled. | `bool` | `true` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Specifies whether the key is enabled. | `bool` | `true` | no |
| <a name="input_key_policy"></a> [key\_policy](#input\_key\_policy) | Resource policy to grant use of the KMS key. | `string` | `null` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | Specifies the intended use of the key. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_multi_region"></a> [multi\_region](#input\_multi\_region) | Indicates whether the KMS key is a multi-Region (true) or regional (false) key. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias_arn"></a> [alias\_arn](#output\_alias\_arn) | Alias ARN. |
| <a name="output_alias_name"></a> [alias\_name](#output\_alias\_name) | Alias name. |
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | Key ARN. |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | Key ID. |
| <a name="output_key_policy"></a> [key\_policy](#output\_key\_policy) | The full policy associated with the key. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# shield-srt-response

For accounts with AWS Shield enabled, this modules configures the SRT Proactive Engagement feature, in which the Shield Response Team contacts listed parties directly when the availability or performance of your application is affected because of a possible attack.

For most situations the default contacts should be used. Additional contacts can be specified using the relevant variable. In specific cases an absolute list of contacts be provided which will override the defaults.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.39.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.39.0 |
| <a name="provider_aws.organization"></a> [aws.organization](#provider\_aws.organization) | >= 5.39.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_srt_bucket"></a> [srt\_bucket](#module\_srt\_bucket) | ../s3/bucket | n/a |
| <a name="module_srt_bucket_key"></a> [srt\_bucket\_key](#module\_srt\_bucket\_key) | ../kms | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.srt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.srt_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_shield_drt_access_role_arn_association.srt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_drt_access_role_arn_association) | resource |
| [aws_shield_proactive_engagement.contacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_proactive_engagement) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.srt_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.srt_bucket_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organizational_unit_descendant_accounts.shield_advanced_accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_unit_descendant_accounts) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | Account name tag, e.g prod | `string` | n/a | yes |
| <a name="input_additional_proactive_engagement_contacts"></a> [additional\_proactive\_engagement\_contacts](#input\_additional\_proactive\_engagement\_contacts) | A list of additional teams who will be contacted by AWS SRT in the event of an identified issue. | <pre>map(object({<br>    phone_number  = optional(string)<br>    contact_notes = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_enable_proactive_engagement"></a> [enable\_proactive\_engagement](#input\_enable\_proactive\_engagement) | Whether to enable the AWS Shield Response Team (SRT) proactive engagement | `bool` | `true` | no |
| <a name="input_force_enable_shield_srt_access"></a> [force\_enable\_shield\_srt\_access](#input\_force\_enable\_shield\_srt\_access) | Whether to enable the AWS Shield Response Team (SRT) access for this account/region regardless of its containing Org Unit. | `bool` | `false` | no |
| <a name="input_override_proactive_engagement_contacts"></a> [override\_proactive\_engagement\_contacts](#input\_override\_proactive\_engagement\_contacts) | Override the default proactive engagement contacts. | <pre>map(object({<br>    phone_number  = optional(string),<br>    contact_notes = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_shield_advanced_org_unit_ids"></a> [shield\_advanced\_org\_unit\_ids](#input\_shield\_advanced\_org\_unit\_ids) | A list of Org Units which have Shield Advanced enabled. | `list(string)` | <pre>[<br>  "ou-5ngy-rqquo55k"<br>]</pre> | no |
| <a name="input_srt_bucket_names"></a> [srt\_bucket\_names](#input\_srt\_bucket\_names) | A list of buckets that this module will create, to be used to share information with AWS SRT. One should be created per engagement with SRT. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | <pre>{<br>  "impact": "critical",<br>  "service": "security",<br>  "team": "security"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

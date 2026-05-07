# Elasticsearch

Creates one cluster of the AWS managed elasticsearch service
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.49 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.49 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_certificate"></a> [certificate](#module\_certificate) | git@github.com:powise/terraform-modules//aws/acm | aws-acm-0.0.2 |
| <a name="module_cmk"></a> [cmk](#module\_cmk) | git@github.com:powise/terraform-modules//aws/kms | aws-kms-0.1.2 |
| <a name="module_override_main_response_version"></a> [override\_main\_response\_version](#module\_override\_main\_response\_version) | ../request | n/a |
| <a name="module_readonly_policy"></a> [readonly\_policy](#module\_readonly\_policy) | git@github.com:powise/terraform-modules//aws/iam/policy | aws-iam-policy-0.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.es_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.es_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_iam_service_linked_role.es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_opensearch_domain.es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_opensearch_domain_saml_options.saml](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_saml_options) | resource |
| [aws_route53_record.custom_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.dashboard_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.security_group_cidr_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.security_group_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.security_group_vpc_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.security_group_vpcs_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.fine_grained_open_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.sg_vpcs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.vpc_from_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.vpc_from_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_software_update_enabled"></a> [auto\_software\_update\_enabled](#input\_auto\_software\_update\_enabled) | Enable automated service software updates. | `bool` | `false` | no |
| <a name="input_auto_tune_enabled"></a> [auto\_tune\_enabled](#input\_auto\_tune\_enabled) | Enable auto-tune. | `bool` | `false` | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Number of Availability Zones for the domain to use with zone\_awareness\_enabled. | `number` | `3` | no |
| <a name="input_create_iam_service_linked_role_count"></a> [create\_iam\_service\_linked\_role\_count](#input\_create\_iam\_service\_linked\_role\_count) | Creates an IAM Service Linked role for this cluster. | `bool` | `true` | no |
| <a name="input_custom_endpoint"></a> [custom\_endpoint](#input\_custom\_endpoint) | Fully qualified domain for your custom endpoint. | `string` | `null` | no |
| <a name="input_custom_endpoint_certificate_arn"></a> [custom\_endpoint\_certificate\_arn](#input\_custom\_endpoint\_certificate\_arn) | ACM certificate ARN for your custom endpoint. | `string` | `null` | no |
| <a name="input_custom_endpoint_enabled"></a> [custom\_endpoint\_enabled](#input\_custom\_endpoint\_enabled) | Enables Custom Endpoint URL | `bool` | `false` | no |
| <a name="input_custom_endpoint_zone"></a> [custom\_endpoint\_zone](#input\_custom\_endpoint\_zone) | Zone where the custom endpoint will be created. | `string` | `null` | no |
| <a name="input_dashboard_users_cidrs"></a> [dashboard\_users\_cidrs](#input\_dashboard\_users\_cidrs) | CIDR of the dashboard users. This should be the VPN CIDR. | `list(string)` | n/a | yes |
| <a name="input_dedicated_master_count"></a> [dedicated\_master\_count](#input\_dedicated\_master\_count) | Number of dedicated main nodes in the cluster. if 0, then will disable master nodes. | `number` | `0` | no |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | Instance type of the dedicated main nodes in the cluster. | `string` | `"m5.large"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Name of the domain. | `string` | n/a | yes |
| <a name="input_ebs_enabled"></a> [ebs\_enabled](#input\_ebs\_enabled) | Whether EBS volumes are attached to data nodes in the domain. | `bool` | `false` | no |
| <a name="input_ebs_iops"></a> [ebs\_iops](#input\_ebs\_iops) | Volume IOPS (for gp3 and provisioned IOPS only). | `number` | `null` | no |
| <a name="input_ebs_throughput"></a> [ebs\_throughput](#input\_ebs\_throughput) | Volume throughput in MiB/s (for gp3 and provisioned IOPS only, always optional). | `number` | `null` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | Size of EBS volumes attached to data nodes (in GiB). | `string` | `"1024"` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | Type of EBS volumes attached to data nodes. | `string` | `"gp3"` | no |
| <a name="input_enable_access_from_cidrs"></a> [enable\_access\_from\_cidrs](#input\_enable\_access\_from\_cidrs) | List of CIDRs allowed to access from. | `list(string)` | `[]` | no |
| <a name="input_enable_access_from_vpc"></a> [enable\_access\_from\_vpc](#input\_enable\_access\_from\_vpc) | List of VPC IDs to enable access from. VPC peering is not setup here. | `list(string)` | `[]` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Engine to use in this cluster. Available options: OpenSearch or Elasticsearch | `string` | `"Elasticsearch"` | no |
| <a name="input_es_version"></a> [es\_version](#input\_es\_version) | Version of Elasticsearch to deploy. | `string` | `"7.10"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances in the cluster. | `number` | `3` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type of data nodes in the cluster. | `string` | `"i3.xlarge"` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | CW Log group where the Elasticsearch cluster will send the logs. | `string` | `null` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CW logs retention days. | `number` | `90` | no |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | List of elasticsearch logs to send to CW logs. | `list(string)` | <pre>[<br>  "INDEX_SLOW_LOGS",<br>  "SEARCH_SLOW_LOGS",<br>  "ES_APPLICATION_LOGS",<br>  "AUDIT_LOGS"<br>]</pre> | no |
| <a name="input_logs_enabled"></a> [logs\_enabled](#input\_logs\_enabled) | Enables sending logs to CW logs for troubleshooting. | `bool` | `true` | no |
| <a name="input_max_clause_count"></a> [max\_clause\_count](#input\_max\_clause\_count) | Specifies the maximum number of clauses allowed in a query. | `number` | `1024` | no |
| <a name="input_off_peak_window_enabled"></a> [off\_peak\_window\_enabled](#input\_off\_peak\_window\_enabled) | Enable off-peak window for updates. | `bool` | `false` | no |
| <a name="input_off_peak_window_hours"></a> [off\_peak\_window\_hours](#input\_off\_peak\_window\_hours) | Hour start of the 10 hours off-peak window (UTC). | `number` | `20` | no |
| <a name="input_off_peak_window_minutes"></a> [off\_peak\_window\_minutes](#input\_off\_peak\_window\_minutes) | Minutes start of the 10 hours off-peak window. | `number` | `0` | no |
| <a name="input_saml_enable"></a> [saml\_enable](#input\_saml\_enable) | Enables SAML authentication for Kibana | `bool` | `false` | no |
| <a name="input_saml_idp_entity_id"></a> [saml\_idp\_entity\_id](#input\_saml\_idp\_entity\_id) | Unique Entity ID of the application in SAML Identity Provider. | `string` | `null` | no |
| <a name="input_saml_master_backend_role"></a> [saml\_master\_backend\_role](#input\_saml\_master\_backend\_role) | This backend role from the SAML IdP receives full permissions to the cluster, equivalent to a new master user. | `string` | `"admins"` | no |
| <a name="input_saml_metadata_xml"></a> [saml\_metadata\_xml](#input\_saml\_metadata\_xml) | SSM Parameter where to get the SAML metadata xml | `string` | `null` | no |
| <a name="input_saml_roles_key"></a> [saml\_roles\_key](#input\_saml\_roles\_key) | Element of the SAML assertion to use for backend roles. | `string` | `"Group"` | no |
| <a name="input_saml_session_timeout_minutes"></a> [saml\_session\_timeout\_minutes](#input\_saml\_session\_timeout\_minutes) | Duration of SAML sessions. | `number` | `1440` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC Subnet IDs for the Elasticsearch domain endpoints to be created in. Will use subnet tags if not defined | `list(string)` | `null` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | Tags to lookup subnets for the Elasticsearch domain endpoints to be created in. | `map(string)` | <pre>{<br>  "tier": "private"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC where to deploy the elasticsearch cluster. | `string` | `null` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC name where to deploy the elasticsearch cluster. | `string` | `null` | no |
| <a name="input_warm_count"></a> [warm\_count](#input\_warm\_count) | Count of UltraWarm nodes. | `number` | `null` | no |
| <a name="input_warm_enabled"></a> [warm\_enabled](#input\_warm\_enabled) | Whether to enable UltraWarm nodes. | `bool` | `false` | no |
| <a name="input_warm_type"></a> [warm\_type](#input\_warm\_type) | Type of UltraWarm instances. | `string` | `null` | no |
| <a name="input_zone_awareness"></a> [zone\_awareness](#input\_zone\_awareness) | Whether zone awareness is enabled, set to true for multi-az deployment. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the domain. |
| <a name="output_domain"></a> [domain](#output\_domain) | Name of the OpenSearch domain. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Domain-specific endpoint used to submit index, search, and data upload requests. |
| <a name="output_iam_readonly_policy_arn"></a> [iam\_readonly\_policy\_arn](#output\_iam\_readonly\_policy\_arn) | ARN of the IAM read only policy for this domain. |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | Domain-specific endpoint for kibana without https scheme. |
| <a name="output_kibana_url"></a> [kibana\_url](#output\_kibana\_url) | Domain-specific url for kibana without https scheme. |
| <a name="output_url"></a> [url](#output\_url) | Domain-specific url used to submit index, search, and data upload requests. |
| <a name="output_version"></a> [version](#output\_version) | Engine Version of the OpenSeach domain. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

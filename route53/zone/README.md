# zone

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.caa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.cname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.ns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.soa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.txt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_caa_records"></a> [caa\_records](#input\_caa\_records) | Map of CAA records to create in the zone (optional). | `map(list(string))` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the zone (optional). | `string` | `"Managed by Terraform."` | no |
| <a name="input_external_cname_records"></a> [external\_cname\_records](#input\_external\_cname\_records) | Map of *external* CNAME records to create in the zone (optional). Do not use this for creating CNAMEs towards internal resources like load balancers as we don't want Route53 zones to depend on any project except other Route53 zones. Only use this with static external values! | `map(list(string))` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Domain name of the zone. | `string` | n/a | yes |
| <a name="input_ns_records"></a> [ns\_records](#input\_ns\_records) | Map of NS records to create in the zone (optional, use for sub-zones). | `map(list(string))` | `{}` | no |
| <a name="input_soa_record"></a> [soa\_record](#input\_soa\_record) | Start Of Authority record to create in the zone. Only one per zone. | <pre>object({<br>    name   = string<br>    record = string<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags on the zone. | `map(string)` | n/a | yes |
| <a name="input_txt_records"></a> [txt\_records](#input\_txt\_records) | Map of TXT records to create in the zone (optional). | `map(list(string))` | `{}` | no |
| <a name="input_vpc_ids"></a> [vpc\_ids](#input\_vpc\_ids) | List of VPC IDs to associate the zone with. Optional, makes the zone private. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | Zone domain name (for convenience). |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | List of the zone name servers. |
| <a name="output_zone_arn"></a> [zone\_arn](#output\_zone\_arn) | ARN of the Route53 zone. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Route53 zone ID. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

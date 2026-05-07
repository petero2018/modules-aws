# Records multi

Module that creates multiple `route53` records based on a given map.

## Example Usage

```hcl-terraform

module "multiple_records" {
  source      = "git@github.com:powise/terraform-modules//aws/route53/records?ref=aws-route53-records-0.0.1"

  records = {
    "example.powise.com" = {
      records     = ["d2abc123d4efgh.cloudfront.net"]
      ttl         = "300"
      record_type = "CNAME"
      zone_id     = "Z012345678ABCDE1A234B"
    },
    "example2.powise.com" = {
      records     = ["d2abc123d4efjk.cloudfront.net"]
      ttl         = "300"
      record_type = "CNAME"
      zone_id     = "Z012345678ABCDE1A234C"
    }
  },
  alias_a_records = {
    "example.com" = {
      alias_name             = "d2abc123d4efjk.cloudfront.net"
      zone_id                = "Z012345678ABCDE1A234C"
      hosted_zone_id         = "Z2FDTNDATAQYW2"
      evaluate_target_health = "false"
    }
  }
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
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
| [aws_route53_record.aliased_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias_a_records"></a> [alias\_a\_records](#input\_alias\_a\_records) | Map of aliased records to create. | <pre>map(object({<br>    zone_id                = string<br>    alias_name             = string<br>    hosted_zone_id         = string<br>    evaluate_target_health = string<br>  }))</pre> | `null` | no |
| <a name="input_records"></a> [records](#input\_records) | Map of records to create. | <pre>map(object({<br>    zone_id     = string,<br>    records     = list(string),<br>    ttl         = number,<br>    record_type = string<br>  }))</pre> | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

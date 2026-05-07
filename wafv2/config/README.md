# config

## Example Usage

```hcl
module "waf_config" {
  source = "git@github.com:powise/terraform-modules//aws/wafv2/config?ref=aws-waf-config-0.0.1"

  scope = "REGIONAL"
  waf_arn = aws_wafv2_web_acl.waf.arn
  allowed_ips = {
    ipv4 = ["0.0.0.0/0"]
    ipv6 = ["0.0.0.0/0"]
  }

  blocked_ips = {
    ipv4 = ["0.0.0.0/0"]
    ipv6 = ["0.0.0.0/0"]
  }

  tags = {
    team = "sec"
    service = "waf"
    impact = "high"
  }
}

resource "aws_wafv2_web_acl" "waf" {
  name        = "WAF"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 0
    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = module.waf_config.rule_group_arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "rule-1"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ips"></a> [ips](#module\_ips) | git@github.com:powise/terraform-modules//common/ips | ips-0.2.7 |

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_ip_set.dynamic_allowed_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.dynamic_blocked_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.static_allowed_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.static_blocked_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_rule_group.ip_lists](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_rule_group) | resource |
| [aws_wafv2_rule_group.ip_lists_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_rule_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | Extra IPs to allow through the WAF ACL. | <pre>object({<br>    ipv4 = optional(list(string), [])<br>    ipv6 = optional(list(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_blocked_ips"></a> [blocked\_ips](#input\_blocked\_ips) | Extra IPs to allow through the WAF ACL. | <pre>object({<br>    ipv4 = optional(list(string), [])<br>    ipv6 = optional(list(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Whether the IP sets and rule groups are regional (i.e. us-east-1, eu-west-1 etc) or global (CloudFront). | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamic_allowed_ipset_arn_ipv4"></a> [dynamic\_allowed\_ipset\_arn\_ipv4](#output\_dynamic\_allowed\_ipset\_arn\_ipv4) | ARNs of the allowlist IP sets (IPv4). |
| <a name="output_dynamic_allowed_ipset_arn_ipv6"></a> [dynamic\_allowed\_ipset\_arn\_ipv6](#output\_dynamic\_allowed\_ipset\_arn\_ipv6) | ARNs of the allowlist IP sets (IPv6). |
| <a name="output_dynamic_blocked_ipset_arn_ipv4"></a> [dynamic\_blocked\_ipset\_arn\_ipv4](#output\_dynamic\_blocked\_ipset\_arn\_ipv4) | ARNs of the dynamic blocklist IP sets (IPv4). |
| <a name="output_dynamic_blocked_ipset_arn_ipv6"></a> [dynamic\_blocked\_ipset\_arn\_ipv6](#output\_dynamic\_blocked\_ipset\_arn\_ipv6) | ARNs of the dynamic blocklist IP sets (IPv6). |
| <a name="output_rule_group_arn"></a> [rule\_group\_arn](#output\_rule\_group\_arn) | ARN of rule group to be attached to every WAF. |
| <a name="output_rule_group_v2_arn"></a> [rule\_group\_v2\_arn](#output\_rule\_group\_v2\_arn) | ARN of rule group to be attached to every WAF. |
| <a name="output_static_allowed_ipset_arn_ipv4"></a> [static\_allowed\_ipset\_arn\_ipv4](#output\_static\_allowed\_ipset\_arn\_ipv4) | ARNs of the allowlist IP sets (IPv4). |
| <a name="output_static_allowed_ipset_arn_ipv6"></a> [static\_allowed\_ipset\_arn\_ipv6](#output\_static\_allowed\_ipset\_arn\_ipv6) | ARNs of the allowlist IP sets (IPv6). |
| <a name="output_static_blocked_ipset_arn_ipv4"></a> [static\_blocked\_ipset\_arn\_ipv4](#output\_static\_blocked\_ipset\_arn\_ipv4) | ARNs of the static blocklist IP sets (IPv4). |
| <a name="output_static_blocked_ipset_arn_ipv6"></a> [static\_blocked\_ipset\_arn\_ipv6](#output\_static\_blocked\_ipset\_arn\_ipv6) | ARNs of the static blocklist IP sets (IPv6). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

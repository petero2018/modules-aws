# cloudflare_failover

This is a module for creating Route53 records that point to Cloudflare's CDN. Rather than having a single record with a simple routing policy, with this module, you have a primary and a secondary records with failover policies and corresponding health checks. This way, if Cloudflare goes down, Route53 automatically kicks in so our downtime is minimal.

This also enforces tagging on resources and the following are required:

| **Tag** | **Value** |
|---------|-----------|
| team | The team responsible for the resource(s) |
| service | The service the resource is used for |
| impact | The *'blast radius'* of the resource. [ `critical`, `high`, `low` ] |

## Example

```hcl
module "subdomain_powise_com" {
  source = "git@github.com:powise/terraform-modules//aws/route53/cloudflare_failover?ref=aws-route53-cloudflare_failover-0.0.1"
  records = {
    name = "subdomain.powise.com"
    record = {
      primary = "subdomain.powise.com.cdn.cloudflare.net"
      secondary = "loadbalancer.us-east-1.elb.amazonaws.com"
    }
    ttl = 60
    type = "CNAME"
    zone_id = "ZN12345ABCDEF"
  }
  health_checks = {
    failure_threshold = 3
    fqdn = {
      primary = "subdomain.powise.com.cdn.cloudflare.net"
      secondary = "loadbalancer.us-east-1.elb.amazonaws.com"
    }
    port = 443
    request_interval = 30
    resource_path = "index.html"
    type = "HTTPS"
  }
  tags = {
    team    = "infra"
    service = "admin"
    impact  = "critical"
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
| [aws_route53_health_check.primary_record_health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) | resource |
| [aws_route53_health_check.secondary_record_health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) | resource |
| [aws_route53_record.primary_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.secondary_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_records"></a> [create\_records](#input\_create\_records) | Boolean to create Route 53 resource or not. Set to false if just testing health check before tying a failover record to it. | `bool` | `true` | no |
| <a name="input_health_checks"></a> [health\_checks](#input\_health\_checks) | Parameters for the health checks associated with the primary and secondary record. | <pre>object({<br>    fqdn = object({<br>      primary   = string<br>      secondary = string<br>    })<br>    port              = number<br>    type              = string<br>    resource_path     = optional(string)<br>    failure_threshold = number<br>    request_interval  = number<br>  })</pre> | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | Parameters for the primary and the secondary records. | <pre>object({<br>    name = string<br>    record = object({<br>      primary   = string<br>      secondary = string<br>    })<br>    ttl     = number<br>    type    = string<br>    zone_id = string<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

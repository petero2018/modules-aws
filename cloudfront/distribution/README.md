# distribution

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_cache_policy.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_cache_policy) | resource |
| [aws_cloudfront_distribution.distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_route53_record.cloudfront_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_cloudfront_cache_policy.managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | Existing ACM certificate ARN to use. | `string` | n/a | yes |
| <a name="input_custom_cache_policies"></a> [custom\_cache\_policies](#input\_custom\_cache\_policies) | Map of custom cache policies to create: cache policy name => parameters. | <pre>map(object({<br>    min_ttl     = optional(number, 1)<br>    max_ttl     = optional(number, 31536000)<br>    default_ttl = optional(number, 86400)<br>    comment     = optional(string)<br>    cookies = optional(object({<br>      behavior = optional(string, "none")<br>      list     = optional(list(string), null)<br>    }), {})<br>    headers = optional(object({<br>      behavior = optional(string, "none")<br>      list     = optional(list(string), null)<br>    }), {})<br>    query_strings = optional(object({<br>      behavior = optional(string, "none")<br>      list     = optional(list(string), null)<br>    }), {})<br>    enable_brotli = optional(bool, true)<br>    enable_gzip   = optional(bool, true)<br>  }))</pre> | `{}` | no |
| <a name="input_custom_origins"></a> [custom\_origins](#input\_custom\_origins) | Map of custom origins: origin ID => origin config. | <pre>map(object({<br>    domain_name       = string<br>    http_port         = optional(number, 80)<br>    https_port        = optional(number, 443)<br>    protocol_policy   = optional(string, "https-only")<br>    ssl_protocols     = optional(list(string), ["TLSv1.2"])<br>    keepalive_timeout = optional(number, 5)<br>    read_timeout      = optional(number, 30)<br>  }))</pre> | n/a | yes |
| <a name="input_default_behavior"></a> [default\_behavior](#input\_default\_behavior) | Default cache behavior of the distribution. | <pre>object({<br>    origin                 = string<br>    cache_policy           = optional(string, "Managed-CachingOptimized")<br>    allowed_methods        = optional(list(string), ["GET", "HEAD"])<br>    cached_methods         = optional(list(string), ["GET", "HEAD"])<br>    compress               = optional(bool, true)<br>    viewer_protocol_policy = optional(string, "redirect-to-https")<br>  })</pre> | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the CloudFront distribution. | `string` | n/a | yes |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | List of domain name aliases for the distribution. | `list(string)` | `[]` | no |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | Supported HTTP protocols. | `string` | `"http2and3"` | no |
| <a name="input_logging_bucket_fqdn"></a> [logging\_bucket\_fqdn](#input\_logging\_bucket\_fqdn) | Logging bucket FQDN, e.g. 'bucket.s3.amazonaws.com'. | `string` | n/a | yes |
| <a name="input_logging_prefix"></a> [logging\_prefix](#input\_logging\_prefix) | Prefix for storing logs in the logging bucket, e.g. 'my-distro'. | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 Zone ID where to create domains for the Cloudfront distribution, optional. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | Web ACL (WAF) ID to attach to the distribution. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

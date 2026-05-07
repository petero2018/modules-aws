# bucket

This is a generic S3 bucket module that should be used for creating a new bucket here at powise. It provides support
for the following options, which you can see implementation details of below:

* Cors Configuration
* Versioning of objects
* ACL policy grants
* Public Access Block
* Bucket Policy
* Website Configuration
* Replication Configuration
* Lifecycle Configuration
* Object Lock
* Metrics

This also enforces tagging on resources and the following are required:

| **Tag** | **Value** |
|---------|-----------|
| team | The team responsible for the resource(s) |
| service | The service the resource is used for |
| impact | The *'blast radius'* of the resource. [ `critical`, `high`, `low` ] |

## Replication of KMS encrypted objects

The following conditions must be met for KMS encrypted objects in a bucket to be replicated.

- Source and destination buckets must be in the same region
- KMS key in destination account must have usage permissions from source account
- `origin_kms_key_id` and `replication_kms_key_id` must be specified in `replication_config`

## Example

```hcl
module "sample_s3" {
  source = "git@github.com:powise/terraform-modules//aws/s3/bucket?ref=aws-s3-bucket-2.0.0"

  bucket_name = "test-bucket-${random_string.test_bucket_suffix.result}"

  # Optional: Cors rules. Can be one or many
  cors_configuration = {
    rule_1 = {
      allowed_headers = ["Authorization"]
      allowed_methods = ["GET"]
      allowed_origins = ["*"]
      max_age_seconds = 3000
    },
    rule_2 = {
      allowed_headers = ["Authorization"]
      allowed_methods = ["POST"]
      allowed_origins = ["*"]
      max_age_seconds = 500
    }
  }

  enable_versioning = true

  # Optional: ACL grants. Can be one or many
  acl_policy_grants = [
    {
      grants = {
        "full" = {
          id         = data.aws_canonical_user_id.current.id
          permission = "FULL_CONTROL"
          type       = "CanonicalUser"
        },
        "read" = {
          permission = "READ"
          type       = "Group"
          uri        = "http://acs.amazonaws.com/groups/global/AllUsers"
        },
      },
      owner_id = data.aws_canonical_user_id.current.id
    }
  ]

  # Optional: Block Public Access
  public_access_block = {
    ignore_public_acls  = true
    block_public_policy = true
  }

  # Optional: Bucket Policy
  bucket_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::some-other-bucket"
      ]
    }
  ]
}
POLICY

  # Optional: Website configuration
  website_configuration = {
    index_document = "index.html"
    error_document = "error.html"
  }

  # Optional: Replication configuration
  replication_config = [
    {
      replication_bucket_arn            = "arn:aws:s3:::some-other-bucket"
      replication_bucket_aws_account_id = "1234567890987"

      filter = {
        prefix = "my-example"
      }
    },
    {
      replication_bucket_arn            = "arn:aws:s3:::some-other-bucket-2"
      replication_bucket_aws_account_id = "1234567890123"
      origin_kms_key_id                 = "arn:aws:kms:us-east-1:1234567890123:key/ab1cde234-a1b2-1234-1ab2-12a3bc467de"
      replication_kms_key_id            = "arn:aws:kms:us-east-1:3210987454321:key/431edc1ba-2b1a-4321-2b1a-ed764cb3a21"

      filter = {
        tag = {
          key   = "env"
          value = "test"
        }
      }
    }
  ]

  # Optional: Lifecycle configuration
  lifecycle_rules = [
    {
      # Transition to another storage tier
      id         = "transition-to-infrequent"
      status     = "Enabled"
      transition = {
        days          = 30
        storage_class = "STANDARD_IA"
      }
    },
    {
      # Expiration of older objects
      id         = "expiration"
      status     = "Enabled"
      expiration = {
        days = 90
      }
    }
  ]

  # Optional: Object Lock
  object_lock_config = {
    default_retention = {
      mode = "COMPLIANCE"
      years = 1
    }
  }

  # Optional: Metrics
  metric_config = {
    "Filter1" = {
      prefix = "prefix1/"
      tags = {
        key1 = "value1"
      }
    }
    "Filter2" = {
      prefix = "prefix2/"
      tags = {
        key1  = "value1"
        key2  = "value2"
        key3  = "value3"
      }
    }
    "AllRequestsAllBucket" = {}
  }

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket_policy"></a> [bucket\_policy](#module\_bucket\_policy) | ../bucket_policy | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudfront_response_headers_policy.response_headers_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy) | resource |
| [aws_route53_record.cloudfront_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.canned_s3_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_acl.s3_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.s3_bucket_cors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.bucket_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_metric.bucket_metric](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric) | resource |
| [aws_s3_bucket_object_lock_configuration.bucket_object_lock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.ownership_controls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.block_public_acls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.bucket_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.s3_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.website_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_ssm_parameter.arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_string.random_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | The canned ACL to apply to the bucket. | `string` | `null` | no |
| <a name="input_acl_policy_grants"></a> [acl\_policy\_grants](#input\_acl\_policy\_grants) | Optional list of configurations for acl | <pre>list(object({<br>    grants = map(object({<br>      id         = optional(string)<br>      type       = optional(string)<br>      uri        = optional(string)<br>      permission = optional(string)<br>    })),<br>    owner_id = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_attach_lb_log_delivery_policy"></a> [attach\_lb\_log\_delivery\_policy](#input\_attach\_lb\_log\_delivery\_policy) | Controls if S3 bucket should have ALB/NLB log delivery policy attached | `bool` | `false` | no |
| <a name="input_aws_backup_enabled"></a> [aws\_backup\_enabled](#input\_aws\_backup\_enabled) | Adds a new tag to enable AWS backups. | `bool` | `false` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the bucket you wish to create. | `string` | n/a | yes |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | Bucket policy to attach. Must be in JSON format. | `string` | `null` | no |
| <a name="input_bucket_policy_template"></a> [bucket\_policy\_template](#input\_bucket\_policy\_template) | Bucket policy template. useful when you don't know the bucket name. | <pre>map(object({<br>    effect         = optional(string) # by default Allow<br>    principal_type = optional(string) # by default AWS<br>    principals     = list(string)<br>    actions        = list(string)<br>    paths          = optional(list(string)) # by default /*<br>    conditions = optional(list(object({<br>      test     = string<br>      variable = string<br>      values   = list(string)<br>    })))<br>  }))</pre> | `{}` | no |
| <a name="input_cloudfront_cache_behaviors"></a> [cloudfront\_cache\_behaviors](#input\_cloudfront\_cache\_behaviors) | List of CloudFront ordered cache behaviors. | <pre>list(object({<br>    target_origin_id       = string<br>    path_pattern           = string<br>    allowed_methods        = optional(list(string), ["GET", "HEAD"])<br>    cached_methods         = optional(list(string), ["GET", "HEAD"])<br>    max_ttl                = optional(number, 31536000)<br>    min_ttl                = optional(number, 0)<br>    viewer_protocol_policy = optional(string, "redirect-to-https")<br>    forwarded_headers      = optional(list(string), ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"])<br>    response_headers_policy = optional(object({<br>      name    = string<br>      comment = string<br>      custom_headers_config = optional(map(object({<br>        override = bool<br>        value    = string<br>      })), {})<br>    }), null)<br>  }))</pre> | `[]` | no |
| <a name="input_cloudfront_certificate_arn"></a> [cloudfront\_certificate\_arn](#input\_cloudfront\_certificate\_arn) | ARN of the ACM certificate to use for the Cloudfront distribution. | `string` | `null` | no |
| <a name="input_cloudfront_cors_config"></a> [cloudfront\_cors\_config](#input\_cloudfront\_cors\_config) | CloudFront CORS settings. | <pre>object({<br>    origin_override                  = optional(bool, true)<br>    access_control_allow_credentials = optional(bool, false)<br>    access_control_allow_headers     = optional(list(string), ["*"])<br>    access_control_allow_methods     = optional(list(string), ["GET", "HEAD"])<br>    access_control_allow_origins     = list(string)<br>  })</pre> | `null` | no |
| <a name="input_cloudfront_custom_origins"></a> [cloudfront\_custom\_origins](#input\_cloudfront\_custom\_origins) | Map of CloudFront custom origins: origin ID => configuration. | <pre>map(object({<br>    domain_name            = string<br>    connection_attempts    = optional(number, 3)<br>    connection_timeout     = optional(number, 10)<br>    http_port              = optional(number, 80)<br>    https_port             = optional(number, 443)<br>    origin_protocol_policy = optional(string, "https-only")<br>    origin_ssl_protocols   = optional(list(string), ["TLSv1", "TLSv1.1", "TLSv1.2"])<br>  }))</pre> | `{}` | no |
| <a name="input_cloudfront_default_cache_behavior_options"></a> [cloudfront\_default\_cache\_behavior\_options](#input\_cloudfront\_default\_cache\_behavior\_options) | Options for the CloudFront defautl cache behavior. | <pre>object({<br>    allowed_methods = optional(list(string), ["GET", "HEAD"])<br>    cached_methods  = optional(list(string), ["GET", "HEAD"])<br>    default_ttl     = optional(number, 300)<br>  })</pre> | `{}` | no |
| <a name="input_cloudfront_domains"></a> [cloudfront\_domains](#input\_cloudfront\_domains) | List of domains accepted by the Cloudfront distribution. | `list(string)` | `[]` | no |
| <a name="input_cloudfront_ipv6_enabled"></a> [cloudfront\_ipv6\_enabled](#input\_cloudfront\_ipv6\_enabled) | Whether to enable IPv6 on the Cloudfront distribution. | `bool` | `true` | no |
| <a name="input_cloudfront_route53_zone_id"></a> [cloudfront\_route53\_zone\_id](#input\_cloudfront\_route53\_zone\_id) | Route53 Zone ID where to create domains for the Cloudfront distribution, optional. | `string` | `null` | no |
| <a name="input_cloudfront_web_acl_arn"></a> [cloudfront\_web\_acl\_arn](#input\_cloudfront\_web\_acl\_arn) | Web ACL (WAF) ARN to use in front of the Cloudfront distribution. | `string` | `null` | no |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | Optional list of configurations for cors rules | <pre>map(object({<br>    allowed_headers = optional(list(string))<br>    allowed_methods = optional(list(string))<br>    allowed_origins = optional(list(string))<br>    expose_headers  = optional(list(string))<br>    max_age_seconds = optional(number)<br>  }))</pre> | `null` | no |
| <a name="input_create_bucket_policy"></a> [create\_bucket\_policy](#input\_create\_bucket\_policy) | Whether to create the bucket policy in this module. | `bool` | `true` | no |
| <a name="input_deny_insecure_transport"></a> [deny\_insecure\_transport](#input\_deny\_insecure\_transport) | Whether to enable bucket policy to deny insecure transport in bucket policy. | `bool` | `true` | no |
| <a name="input_enable_cloudfront"></a> [enable\_cloudfront](#input\_enable\_cloudfront) | Whether to create a simple read-only Cloudfront distribution with this bucket as the origin. | `bool` | `false` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Enable versioning on objects stored in the bucket. | `bool` | `true` | no |
| <a name="input_encryption_at_rest"></a> [encryption\_at\_rest](#input\_encryption\_at\_rest) | Encryption at rest settings for the bucket. | <pre>object({<br>    bucket_key_enabled = optional(bool, true)<br>    encryption_settings = optional(object({<br>      sse_algorithm     = optional(string, "AES256")<br>      kms_master_key_id = optional(string)<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Indicates all objects should be deleted from the bucket so that it can be destroyed without error. | `bool` | `false` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of maps containing configuration of object lifecycle management. | `any` | `[]` | no |
| <a name="input_logging_bucket"></a> [logging\_bucket](#input\_logging\_bucket) | Bucket to store the logs | `string` | `""` | no |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Whether to enable access logs sent to the logs AWS account. | `bool` | `false` | no |
| <a name="input_logging_prefix"></a> [logging\_prefix](#input\_logging\_prefix) | Prefix to add to the bucket logging | `string` | `""` | no |
| <a name="input_metric_config"></a> [metric\_config](#input\_metric\_config) | Metrics to enable on the bucket. | <pre>map(object({<br>    prefix = optional(string, "")<br>    tags   = optional(map(string), {})<br>    }<br>  ))</pre> | `{}` | no |
| <a name="input_object_lock_config"></a> [object\_lock\_config](#input\_object\_lock\_config) | Configuration for the bucket's object lock. | <pre>object({<br>    expected_bucket_owner = optional(string)<br>    token                 = optional(string)<br>    # Only required when enabling object lock on a bucket that was created without it. AWS Support has to provide this token.<br>    default_retention = object({<br>      mode  = string<br>      days  = optional(number)<br>      years = optional(number)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_object_ownership_setting"></a> [object\_ownership\_setting](#input\_object\_ownership\_setting) | Controls ownership of objects uploaded to the bucket. If set to BucketOwnerEnforced, all ACLs are ignored for the purposes of determining access and only resource and/or identity policies will determine access to the bucket and its objects. | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_public_access_block"></a> [public\_access\_block](#input\_public\_access\_block) | Options to block public access to the bucket. | <pre>object({<br>    ignore_public_acls      = optional(bool)<br>    block_public_policy     = optional(bool)<br>    block_public_acls       = optional(bool)<br>    restrict_public_buckets = optional(bool)<br>  })</pre> | <pre>{<br>  "block_public_acls": true,<br>  "block_public_policy": true,<br>  "ignore_public_acls": true,<br>  "restrict_public_buckets": true<br>}</pre> | no |
| <a name="input_rand_suffix"></a> [rand\_suffix](#input\_rand\_suffix) | Whether to add random suffix to end of bucket name to make it globally unique. Defaults to false. | `bool` | `false` | no |
| <a name="input_require_encrypted_uploads"></a> [require\_encrypted\_uploads](#input\_require\_encrypted\_uploads) | Whether to require encrypted uploads in bucket policy. Since SSE is enabled always this is not always needed. | `bool` | `false` | no |
| <a name="input_require_latest_tls"></a> [require\_latest\_tls](#input\_require\_latest\_tls) | Whether to enable bucket policy to require latest TLS in bucket policy. | `bool` | `true` | no |
| <a name="input_ssm_identifier"></a> [ssm\_identifier](#input\_ssm\_identifier) | Name to use to generate SSM parameter names to store the bucket name and ARN (optional). | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to AWS resources. | `map(string)` | n/a | yes |
| <a name="input_transition_default_minimum_object_size"></a> [transition\_default\_minimum\_object\_size](#input\_transition\_default\_minimum\_object\_size) | The default minimum object size behavior applied to the lifecycle configuration. | `string` | `"all_storage_classes_128K"` | no |
| <a name="input_website_configuration"></a> [website\_configuration](#input\_website\_configuration) | Options for website configuration of the bucket. | <pre>object({<br>    index_document = optional(string)<br>    error_document = optional(string)<br>    redirect = optional(object({<br>      domain   = string<br>      protocol = optional(string, "https")<br>    }))<br>    routing_rules = optional(list(object({<br>      Condition = object({<br>        KeyPrefixEquals = string<br>      })<br>      Redirect = object({<br>        HostName             = string<br>        Protocol             = optional(string, "https")<br>        ReplaceKeyWith       = optional(string)<br>        ReplaceKeyPrefixWith = optional(string)<br>      })<br>    })))<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_tags"></a> [all\_tags](#output\_all\_tags) | All tags applied to the S3 bucket and its resources, including tags created by this module. |
| <a name="output_bucket_account_id"></a> [bucket\_account\_id](#output\_bucket\_account\_id) | AWS account ID owning the bucket. |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of newly created bucket. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The bucket domain namein the format <bucketname>.s3.amazonaws.com |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of newly created bucket. |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | Region in which the S3 bucket is deployed. |
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | CloudFront distribution ARN, if any. |
| <a name="output_cloudfront_origin_access_control_id"></a> [cloudfront\_origin\_access\_control\_id](#output\_cloudfront\_origin\_access\_control\_id) | CloudFront Origin Access Control (OAC) ID. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_ssm_parameters_arns"></a> [ssm\_parameters\_arns](#output\_ssm\_parameters\_arns) | List of SSM parameter ARNs created, useful to build IAM policies. |
| <a name="output_tags"></a> [tags](#output\_tags) | The user-supplied tags applied to the S3 bucket and its resources. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

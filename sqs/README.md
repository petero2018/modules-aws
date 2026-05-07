# sqs

This is a generic SQS queue module that should be used for creating a new queues here at powise. It provides support
for all the different settings that can also be configured from the console. The only difference, and the reason as to why have a module with just two resources, is that encryption at rest is enabled and cannot be disabled. It must be either SQS-managed or KMS.

This also enforces tagging on resources and the following are required:

| **Tag** | **Value** |
|---------|-----------|
| team | The team responsible for the resource(s) |
| service | The service the resource is used for |
| impact | The *'blast radius'* of the resource. [ `critical`, `high`, `low` ] |

## Example

```hcl
module "sample_queue" {
  source = "git@github.com:powise/terraform-modules//aws/sqs?ref=aws-sqs-0.0.1"


  name = "queue"

  visibility_timeout_seconds  = 30
  message_retention_seconds   = 345600
  max_message_size            = 262144
  delay_seconds               = 0
  receive_wait_time_seconds   = 0
  access_policy               = data.aws_iam_policy_document.extra_queue_policy.json
  redrive_policy              = {
    deadLetterTargetArn = "arn:aws:sqs:us-east-1:123456789012:queue"
    maxReceiveCount = 1
  }
  redrive_allow_policy        = {
    redrivePermission = "byQueue"   # If set to "allowAll" or "denyAll", delete sourceQueueArns list
    sourceQueueArns = [ "arn:aws:sqs:us-east-1:123456789012:queue1", "arn:aws:sqs:us-east-1:123456789012:queue2" ]
  }
  fifo_queue                  = false
  content_based_deduplication = false
  deduplication_scope         = "queue"
  fifo_throughput_limit       = "perQueue"

  encryption_at_rest = {
    kms_sse = {
      kms_data_key_reuse_period_seconds = 300
      kms_master_key_id = aws_kms_key.sqs_key.key_id
  }
}

  tags = {
    team    = "frontend"
    service = "logs"
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
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.queue_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_iam_policy_document.combined_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deny_insecure_transport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy"></a> [access\_policy](#input\_access\_policy) | The JSON policy for the SQS queue | `string` | `null` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enables content-based deduplication for FIFO queues | `bool` | `false` | no |
| <a name="input_deduplication_scope"></a> [deduplication\_scope](#input\_deduplication\_scope) | Specifies whether message deduplication occurs at the message group or queue level | `string` | `null` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes) | `number` | `0` | no |
| <a name="input_deny_insecure_transport"></a> [deny\_insecure\_transport](#input\_deny\_insecure\_transport) | Whether to enable access policy to deny insecure transport in access policy. | `bool` | `true` | no |
| <a name="input_encryption_at_rest"></a> [encryption\_at\_rest](#input\_encryption\_at\_rest) | Encryption-at-rest settings for the queue | <pre>object({<br>    sqs_managed_sse_enabled = optional(bool)<br>    kms_sse = optional(object({<br>      kms_master_key_id                 = string<br>      kms_data_key_reuse_period_seconds = number<br>    }))<br>  })</pre> | <pre>{<br>  "sqs_managed_sse_enabled": true<br>}</pre> | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Boolean designating a FIFO queue | `bool` | `false` | no |
| <a name="input_fifo_throughput_limit"></a> [fifo\_throughput\_limit](#input\_fifo\_throughput\_limit) | Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group | `string` | `null` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB) | `number` | `262144` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days) | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | This is the human-readable name of the queue. If omitted, Terraform will assign a random name. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | A unique name beginning with the specified prefix. | `string` | `null` | no |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds) | `number` | `0` | no |
| <a name="input_redrive_allow_policy"></a> [redrive\_allow\_policy](#input\_redrive\_allow\_policy) | The JSON policy to set up the Dead Letter Queue redrive permission. | <pre>object({<br>    redrivePermission = string<br>    sourceQueueArns   = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_redrive_policy"></a> [redrive\_policy](#input\_redrive\_policy) | The JSON policy to set up the Dead Letter Queue. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5") | <pre>object({<br>    deadLetterTargetArn = string<br>    maxReceiveCount     = number<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours) | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | The ARN of the SQS queue |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | The URL for the created Amazon SQS queue |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | Same as `id`: The URL for the created Amazon SQS queue. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

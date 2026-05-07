# event_notification

## Example

```hcl
module "s3_notifications" {
  source = "git@github.com:powise/terraform-modules//aws/s3/event_notification?ref=aws-s3-event-notification-0.0.1"

  bucket = module.s3_bucket.bucket_id
  eventbridge = true
  create_sns_policy = true
  create_sqs_policy = true
  create_lambda_permission = true

  sns_notifications = {
    "SNS_Rule_1" = {
      events = [ "s3:ObjectCreated:*" ]
      filter_prefix = "prefix/"
      filter_suffix = "suffix/"
      topic_arn = "arn:aws:sns:us-east-1:123456789012:SNS_Topic_1"
    }
  }

  sqs_notifications = {
    "SQS_Rule_1" = {
      events = [ "s3:ObjectRestore:*" ]
      filter_prefix = "prefix/"
      filter_suffix = "suffix/"
      queue_arn = "arn:aws:sqs:us-east-1:123456789012:SQS_Queue_1"
      queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/SQS_Queue_1"
    }
  }

  lambda_notifications = {
    "Lambda_Rule_1" = {
      events = [ "s3:Replication:*" ]
      filter_prefix = "prefix/"
      filter_suffix = "suffix/"
      function_name = "LambdaFunction"
      lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:Lambda_Function_1"
      qualifier = aws_lambda_alias.test_alias.name
      source_account = "123456789012"
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lambda_permission.allow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_sns_topic_policy.allow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sqs_queue_policy.allow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_iam_policy_document.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Name of S3 bucket to use | `string` | `""` | no |
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | ARN of S3 bucket to use in policies | `string` | `null` | no |
| <a name="input_create_lambda_permission"></a> [create\_lambda\_permission](#input\_create\_lambda\_permission) | Whether to create a lambda permission for S3 or not? | `bool` | `false` | no |
| <a name="input_create_sns_policy"></a> [create\_sns\_policy](#input\_create\_sns\_policy) | Whether to create a policy for SNS permissions or not? | `bool` | `false` | no |
| <a name="input_create_sqs_policy"></a> [create\_sqs\_policy](#input\_create\_sqs\_policy) | Whether to create a policy for SQS permissions or not? | `bool` | `false` | no |
| <a name="input_eventbridge"></a> [eventbridge](#input\_eventbridge) | Whether to enable Amazon EventBridge notifications | `bool` | `null` | no |
| <a name="input_lambda_notifications"></a> [lambda\_notifications](#input\_lambda\_notifications) | Options for S3 event notifications (Lambda) | <pre>map(object({<br>    function_name       = string<br>    lambda_function_arn = string<br>    events              = list(string)<br>    filter_prefix       = optional(string)<br>    filter_suffix       = optional(string)<br>    qualifier           = optional(string)<br>    source_account      = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_sns_notifications"></a> [sns\_notifications](#input\_sns\_notifications) | Options for S3 event notifications (SNS) | <pre>map(object({<br>    topic_arn     = string<br>    events        = list(string)<br>    filter_prefix = optional(string)<br>    filter_suffix = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_sqs_notifications"></a> [sqs\_notifications](#input\_sqs\_notifications) | Options for S3 event notifications (SQS) | <pre>map(object({<br>    queue_arn     = string<br>    events        = list(string)<br>    queue_url     = optional(string) # Queue URL is needed only when creating policy<br>    filter_prefix = optional(string)<br>    filter_suffix = optional(string)<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of S3 bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

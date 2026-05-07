# auto-scaling-group

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cmk"></a> [cmk](#module\_cmk) | git@github.com:powise/terraform-modules//aws/kms | aws-kms-0.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.asg_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.asg_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_launch_template.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cmk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The ID of the AMI from which autoscaling instances will be launched. | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired number of instances the autoscaling group will maintain. | `number` | n/a | yes |
| <a name="input_iam_policy_arns"></a> [iam\_policy\_arns](#input\_iam\_policy\_arns) | A list of externally-created IAM policy ARNs that will be attached to autoscaling instances. | `list(string)` | `[]` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | The type(s) of instance that the autoscaling group will launch. You must specify at least one instance type. Any other instance types will be used as overrides with a given (optional) weighting. | <pre>list(object({<br>    instance_type = string<br>    weight        = optional(number)<br>  }))</pre> | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of instances the autoscaling group will scale up to. | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of instances the autoscaling group will scale down to. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the autoscaling group. | `string` | n/a | yes |
| <a name="input_on_demand_base_capacity"></a> [on\_demand\_base\_capacity](#input\_on\_demand\_base\_capacity) | Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances. | `number` | `0` | no |
| <a name="input_refresh_instances_on_update"></a> [refresh\_instances\_on\_update](#input\_refresh\_instances\_on\_update) | Whether changes to the launch template automatically trigger an instance refresh. | `bool` | `true` | no |
| <a name="input_refresh_minimum_healthy_percentage"></a> [refresh\_minimum\_healthy\_percentage](#input\_refresh\_minimum\_healthy\_percentage) | The percentage of the amount of capacity in the Auto Scaling group that must remain healthy during an instance refresh to allow the operation to continue. | `number` | `90` | no |
| <a name="input_root_volume_device_name"></a> [root\_volume\_device\_name](#input\_root\_volume\_device\_name) | The device name of the root volume's EBS volume. | `string` | `"/dev/xvda"` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | The root volume size for autoscaling instances. This must be equal to or larger than the root volume of the AMI! | `number` | n/a | yes |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | The type of EBS volume to be used for the root volume | `string` | `"gp2"` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Ingress and Egress rules to associate with the autoscaling instances. | <pre>list(object({<br>    type               = string<br>    description        = optional(string)<br>    to_port            = number<br>    from_port          = number<br>    protocol           = string<br>    cidr_blocks        = optional(list(string))<br>    security_group_ids = optional(list(string))<br>    self               = optional(bool)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0,<br>    "type": "egress"<br>  }<br>]</pre> | no |
| <a name="input_spot_percentage"></a> [spot\_percentage](#input\_spot\_percentage) | The percentage of instances that will be spot instances rather than on\_demand once on\_demand\_base\_capacity has been fulfilled. | `number` | `100` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The subnets in which the autoscaling instances will be launched. | `list(string)` | n/a | yes |
| <a name="input_suspended_processes"></a> [suspended\_processes](#input\_suspended\_processes) | A list of processes to suspend for the autoscaling group. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | n/a | yes |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | Target groups in which the ASG will manage instances. | `list(string)` | `[]` | no |
| <a name="input_termination_policies"></a> [termination\_policies](#input\_termination\_policies) | A list of policies that determine how an autoscaling group will choose instances to terminate. | `list(string)` | <pre>[<br>  "OldestInstance"<br>]</pre> | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user\_data definition to be used by the autoscaling instances. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC in which the autoscaling instances will reside. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | The ARN of the autoscaling group |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | The name of the autoscaling group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

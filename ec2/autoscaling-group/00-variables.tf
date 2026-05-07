variable "ami_id" {
  type        = string
  description = "The ID of the AMI from which autoscaling instances will be launched."
}

variable "instance_types" {
  type = list(object({
    instance_type = string
    weight        = optional(number)
  }))
  description = "The type(s) of instance that the autoscaling group will launch. You must specify at least one instance type. Any other instance types will be used as overrides with a given (optional) weighting."
}

variable "name" {
  type        = string
  description = "The name of the autoscaling group."
}

variable "user_data" {
  type        = string
  default     = ""
  description = "The user_data definition to be used by the autoscaling instances."
}

variable "root_volume_size" {
  type        = number
  description = "The root volume size for autoscaling instances. This must be equal to or larger than the root volume of the AMI!"
}

variable "root_volume_type" {
  type        = string
  description = "The type of EBS volume to be used for the root volume"
  default     = "gp2"
}

variable "root_volume_device_name" {
  type        = string
  description = "The device name of the root volume's EBS volume."
  default     = "/dev/xvda"
}

variable "iam_policy_arns" {
  type        = list(string)
  description = "A list of externally-created IAM policy ARNs that will be attached to autoscaling instances."
  default     = []
  validation {
    condition     = alltrue([for arn in var.iam_policy_arns : can(regex("^arn:aws:iam::[0-9]{12}:policy/.+", arn))])
    error_message = "Invalid IAM policy ARN."
  }
}

# Networking config
variable "vpc_id" {
  type        = string
  description = "The VPC in which the autoscaling instances will reside."
}

variable "security_group_rules" {
  type = list(object({
    type               = string
    description        = optional(string)
    to_port            = number
    from_port          = number
    protocol           = string
    cidr_blocks        = optional(list(string))
    security_group_ids = optional(list(string))
    self               = optional(bool)
  }))
  description = "Ingress and Egress rules to associate with the autoscaling instances."
  default = [{
    type        = "egress"
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnets in which the autoscaling instances will be launched."
}

# Autoscaling limits
variable "desired_size" {
  type        = number
  description = "The desired number of instances the autoscaling group will maintain."
}

variable "max_size" {
  type        = number
  description = "The maximum number of instances the autoscaling group will scale up to."
}

variable "min_size" {
  type        = number
  description = "The minimum number of instances the autoscaling group will scale down to."
}

# Misc config
variable "on_demand_base_capacity" {
  type        = number
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances."
  default     = 0
  validation {
    condition     = var.on_demand_base_capacity >= 0
    error_message = "Invalid value for on_demand_base_capacity: Must be greater than or equal to 0."
  }
}

variable "refresh_instances_on_update" {
  type        = bool
  description = "Whether changes to the launch template automatically trigger an instance refresh."
  default     = true
}

variable "refresh_minimum_healthy_percentage" {
  type        = number
  description = "The percentage of the amount of capacity in the Auto Scaling group that must remain healthy during an instance refresh to allow the operation to continue."
  default     = 90
}

variable "spot_percentage" {
  type        = number
  description = "The percentage of instances that will be spot instances rather than on_demand once on_demand_base_capacity has been fulfilled."
  default     = 100
  validation {
    condition     = var.spot_percentage >= 0 && var.spot_percentage <= 100
    error_message = "Invalid value for spot_percentage: Must be between 0 and 100 (inclusive)."
  }
}

variable "suspended_processes" {
  type        = list(string)
  description = "A list of processes to suspend for the autoscaling group."
  default     = []
  validation {
    condition = alltrue([for sp in var.suspended_processes : contains([
      "AddToLoadBalancer",
      "AlarmNotification",
      "AZRebalance",
      "HealthCheck",
      "Launch",
      "ReplaceUnhealthy",
      "ScheduledActions",
      "Terminate",
    ], sp)])
    error_message = "Invalid value for suspended_processes."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to resources."
  validation {
    condition = alltrue([
      contains(keys(var.tags), "team"),
      contains(keys(var.tags), "service"),
      contains(keys(var.tags), "impact"),
    ])
    error_message = "Required tags are missing! Please provide tags 'team', 'service' and 'impact'."
  }
}

variable "target_group_arns" {
  type        = list(string)
  description = "Target groups in which the ASG will manage instances."
  default     = []
  validation {
    condition     = alltrue([for tg in var.target_group_arns : regex("^tg-[a-z0-9]+", tg)])
    error_message = "Invalid target group ARNs."
  }
}

variable "termination_policies" {
  type        = list(string)
  description = "A list of policies that determine how an autoscaling group will choose instances to terminate."
  default     = ["OldestInstance"]
  validation {
    condition = alltrue([for tp in var.termination_policies : contains([
      "AllocationStrategy",
      "ClosestToNextInstanceHour",
      "Default",
      "NewestInstance",
      "OldestInstance",
      "OldestLaunchConfiguration",
      "OldestLaunchTemplate",
    ], tp)])
    error_message = "Invalid value for termination_policies."
  }
}

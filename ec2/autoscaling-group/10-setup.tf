terraform {
  required_version = ">= 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  asg_name = "asg-${var.name}"
  iam_policy_arns = concat(var.iam_policy_arns, [
    # TODO: Add any IAM ARNs that are required but not supplied by the user of the module
  ])
}

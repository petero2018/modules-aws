terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.3.6"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.39.0"
      configuration_aliases = [aws.organization]
    }
  }
  required_version = ">= 1.1"
}

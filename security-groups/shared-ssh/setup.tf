terraform {
  required_version = ">= 1.2.4"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 3.0"
      configuration_aliases = [aws.prod]
    }
  }
}

# https://support.hashicorp.com/hc/en-us/articles/1500000332721-Error-Provider-configuration-not-present
provider "aws" {
  alias = "prod"
}

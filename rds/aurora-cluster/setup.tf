terraform {
  required_version = ">= 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"

      configuration_aliases = [aws.identity]
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

# https://support.hashicorp.com/hc/en-us/articles/1500000332721-Error-Provider-configuration-not-present
provider "aws" {
  alias = "identity"
}

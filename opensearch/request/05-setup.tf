terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">=3.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.0"
    }
  }
  required_version = ">= 1.3.6"
}

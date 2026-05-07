terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~>2.1.0"
    }
  }
  required_version = ">= 1.6.6"
}

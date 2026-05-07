terraform {
  required_version = ">= 1.6.6"

  required_providers {
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = ">= 2.3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.65"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.12.0"
    }
  }
}

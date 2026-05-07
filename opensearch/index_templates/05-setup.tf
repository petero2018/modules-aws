terraform {
  required_version = ">= 1.6.6"

  required_providers {
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = ">= 2.2.1"
    }
  }
}

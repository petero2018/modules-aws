terraform {
  required_version = ">= 1.6.6"
  required_providers {
    # This provider is used in submodules and needs to be defined here to avoid possible conflicts
    # tflint-ignore: terraform_unused_required_providers
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = ">= 2.3.0"
    }
  }
}

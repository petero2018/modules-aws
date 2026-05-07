terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
    # This is ABSOLUTELY required, otherwise you will recieve the following error from terraform:
    # | Could not retrieve the list of available versions for provider
    # | hashicorp/datadog: provider registry registry.terraform.io does not have a
    # | provider named registry.terraform.io/hashicorp/datadog

    # tflint-ignore: terraform_unused_required_providers
    datadog = {
      source = "DataDog/datadog"
    }
  }

  required_version = ">= 1.3.6"
}

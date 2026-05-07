locals {
  lambda_function_name = "content_moderation"

  auto_update = var.auto_update ? "ENABLED" : "DISABLED"

  tags = merge({
    terraform_module = "git@github.com:powise/terraform-modules//aws/rekognition-content-moderation"
  }, var.tags)
}

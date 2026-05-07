locals {
  tags = merge(var.tags, {
    terraform_module = "git@github.com:powise/terraform-modules//aws/iam/policy"
  })
}

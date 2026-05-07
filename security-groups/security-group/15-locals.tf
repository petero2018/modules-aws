locals {
  tags = merge(var.tags, {
    Name             = var.name
    terraform_module = "git@github.com:powise/terraform-modules//aws/security-group"
  })
}

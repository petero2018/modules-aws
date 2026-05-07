locals {
  tags = merge({
    terraform_module = "git@github.com:powise/terraform-modules//aws/memorydb/cluster",
  }, var.tags)

  iam_user          = "iamuser"
  iam_access_string = "on ~* &* +@all"
  iam_acl           = "iamacl"

  security_group_name = coalesce(var.security_group_name, "memorydb-${var.memorydb_name}")
}

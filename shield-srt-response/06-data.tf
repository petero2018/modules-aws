data "aws_caller_identity" "current" {}

data "aws_organizations_organizational_unit_descendant_accounts" "shield_advanced_accounts" {
  for_each = toset(var.shield_advanced_org_unit_ids)

  parent_id = each.value

  provider = aws.organization
}

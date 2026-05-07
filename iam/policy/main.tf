resource "aws_iam_policy" "policy" {
  name        = var.name
  path        = var.path
  description = var.description
  policy      = var.policy
  tags        = local.tags
}

resource "aws_iam_role_policy_attachment" "attachment" {
  # this is done to compute without dependencies:
  # https://discuss.hashicorp.com/t/the-for-each-value-depends-on-resource-attributes-that-cannot-be-determined-until-apply/25016/4
  for_each = { for i, val in var.roles_to_attach : i => val }

  role       = each.value
  policy_arn = aws_iam_policy.policy.arn
}

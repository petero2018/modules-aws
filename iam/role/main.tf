resource "aws_iam_role" "role" {
  name                  = var.name
  path                  = var.path
  description           = var.description
  assume_role_policy    = var.assume_role_policy
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary
  force_detach_policies = var.force_detach_policies
  tags                  = local.tags
}

resource "aws_iam_role_policy_attachment" "attachment" {
  for_each = toset(var.attach_policies)

  role       = aws_iam_role.role.name
  policy_arn = each.key
}

resource "aws_iam_role_policy" "creation" {
  for_each = var.create_policies

  name   = each.key
  policy = each.value
  role   = aws_iam_role.role.name
}

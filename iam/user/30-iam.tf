resource "aws_iam_user" "user" {
  #checkov:skip=CKV_AWS_273:We need IAM users and access keys in some cases

  name = var.name
  path = var.path

  force_destroy = true

  tags = var.tags
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.name

  lifecycle {
    ignore_changes = [status] # Allow Security to disable old, unused access keys and keep Terraform from enabling them again
  }
}

resource "aws_iam_user_policy_attachment" "attached_policy" {
  for_each = toset(var.policy_arns)

  user       = aws_iam_user.user.name
  policy_arn = each.value
}

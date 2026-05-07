data "aws_iam_policy_document" "memorydb_iam_full_access_authentication" {
  count = var.iam_authentication_enabled ? 1 : 0

  statement {
    sid = "AllowMemoryDBIamAuthentication"

    actions = ["memorydb:connect"]
    resources = [
      "arn:aws:memorydb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:user/${local.iam_user}",
      aws_memorydb_cluster.memorydb_cluster.arn
    ]
  }
}

resource "aws_iam_role_policy" "memorydb_iam_full_access_authentication" {
  for_each = toset(var.iam_authenticated_roles)

  name = "MemoryDBIamAuth.${aws_memorydb_cluster.memorydb_cluster.name}"
  role = each.key

  policy = data.aws_iam_policy_document.memorydb_iam_full_access_authentication[0].json
}

resource "aws_iam_policy" "memorydb_iam_full_access_authentication" {
  count = var.iam_authentication_enabled ? 1 : 0

  name = "memorydb-iam-auth.${aws_memorydb_cluster.memorydb_cluster.name}.${data.aws_region.current.name}"
  path = "/"

  description = "Allows full access IAM authentication to database ${aws_memorydb_cluster.memorydb_cluster.name} (${data.aws_region.current.name})."

  policy = data.aws_iam_policy_document.memorydb_iam_full_access_authentication[0].json
}

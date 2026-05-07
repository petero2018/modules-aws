locals {
  rds_iam_read_only_resources = formatlist(
    "arn:aws:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:%s/${local.rds_iam_read_only_user}",
    local.db_resource_ids,
  )
}

data "aws_iam_policy_document" "rds_iam_read_only_authentication" {
  count = var.iam_database_authentication_enabled ? 1 : 0

  statement {
    sid = "AllowRdsIamReadOnlyAuthentication"

    actions = ["rds-db:connect"]

    resources = local.rds_iam_read_only_resources
  }
}

resource "aws_iam_role_policy" "rds_iam_read_only_authentication" {
  for_each = toset(var.iam_read_only_roles)

  name = "RdsIamReadOnlyAuth.${aws_db_instance.primary.identifier}"
  role = each.key

  policy = data.aws_iam_policy_document.rds_iam_read_only_authentication[0].json
}

resource "aws_iam_policy" "rds_iam_read_only_authentication" {
  count = var.iam_database_authentication_enabled ? 1 : 0

  name = "rds-iam-read-only-auth.${aws_db_instance.primary.identifier}.${data.aws_region.current.region}"
  path = "/"

  description = "Allows full access IAM authentication to database ${aws_db_instance.primary.identifier} (${data.aws_region.current.region})."

  policy = data.aws_iam_policy_document.rds_iam_read_only_authentication[0].json
}

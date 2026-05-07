locals {
  rds_iam_full_access_resources = concat(
    formatlist(
      "arn:aws:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:%s/${local.rds_iam_full_access_user}",
      local.db_resource_ids,
    ),
    # Connection through RDS Proxy is done with the original database user
    var.enable_proxy ? ["arn:aws:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:${local.proxy_resource_id}/${aws_db_instance.primary.username}"] : [],
  )
}

data "aws_iam_policy_document" "rds_iam_full_access_authentication" {
  count = var.iam_database_authentication_enabled ? 1 : 0

  statement {
    sid = "AllowRdsIamAuthentication"

    actions = ["rds-db:connect"]

    resources = local.rds_iam_full_access_resources
  }
}

resource "aws_iam_role_policy" "rds_iam_full_access_authentication" {
  for_each = toset(var.iam_authenticated_roles)

  name = "RdsIamAuth.${aws_db_instance.primary.identifier}"
  role = each.key

  policy = data.aws_iam_policy_document.rds_iam_full_access_authentication[0].json
}

resource "aws_iam_policy" "rds_iam_full_access_authentication" {
  count = var.iam_database_authentication_enabled ? 1 : 0

  name = "rds-iam-auth.${aws_db_instance.primary.identifier}.${data.aws_region.current.region}"
  path = "/"

  description = "Allows full access IAM authentication to database ${aws_db_instance.primary.identifier} (${data.aws_region.current.region})."

  policy = data.aws_iam_policy_document.rds_iam_full_access_authentication[0].json
}

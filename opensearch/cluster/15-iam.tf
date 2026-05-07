resource "aws_iam_service_linked_role" "es" {
  count = var.create_iam_service_linked_role_count ? 1 : 0

  aws_service_name = "es.amazonaws.com"

  tags = var.tags
}

data "aws_iam_policy_document" "readonly" {
  statement {
    effect = "Allow"

    actions = [
      "es:ESHttpGet",
      "es:ESHttpHead",
    ]

    resources = [aws_opensearch_domain.es.arn]
  }
}

module "readonly_policy" {
  source = "git@github.com:powise/terraform-modules//aws/iam/policy?ref=aws-iam-policy-0.0.1"

  name = "OpenSearch-${var.domain}-${data.aws_region.current.name}-ReadOnly"

  description = "Read only policy for the OpenSearch domain ${var.domain} (${data.aws_region.current.name})."
  policy      = data.aws_iam_policy_document.readonly.json

  tags = var.tags
}

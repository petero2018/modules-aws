data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "s3_snapshots" {
  name               = "OpenSearchSnapshots-${var.cluster_name}-${data.aws_region.current.name}"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json

  tags = var.tags
}

data "aws_iam_policy_document" "snapshot_to_s3" {
  for_each = var.repositories

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = each.value.create_bucket ? ["arn:aws:s3:::${module.bucket[each.key].bucket_id}"] : ["arn:aws:s3:::${each.value.bucket_name}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = each.value.create_bucket ? ["arn:aws:s3:::${module.bucket[each.key].bucket_id}/*"] : ["arn:aws:s3:::${each.value.bucket_name}/*"]
  }
}

resource "aws_iam_role_policy" "s3_access_policy" {
  for_each = var.repositories

  name   = "snapshot-to-s3-${each.key}"
  role   = aws_iam_role.s3_snapshots.id
  policy = data.aws_iam_policy_document.snapshot_to_s3[each.key].json
}

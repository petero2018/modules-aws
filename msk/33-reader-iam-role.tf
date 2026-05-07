data "aws_iam_policy_document" "msk_external_reader" {
  for_each = var.external_reader_roles

  statement {
    sid     = "AllowDataPlatformAccess"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${each.value}:root"
      ]
    }
  }
}

resource "aws_iam_role" "msk_external_reader" {
  for_each = var.external_reader_roles

  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.msk_external_reader[each.key].json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "msk_read_only" {
  for_each = var.external_reader_roles

  policy_arn = "arn:aws:iam::aws:policy/AmazonMSKReadOnlyAccess"
  role       = aws_iam_role.msk_external_reader[each.key].id
}

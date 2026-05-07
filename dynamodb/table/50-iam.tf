data "aws_iam_policy_document" "readwrite" {
  # Taken from https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/iam-policy-example-data-crud.html

  statement {
    sid = "DynamoDBIndexAndStreamAccess"
    actions = [
      "dynamodb:GetShardIterator",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:ListStreams",
    ]
    resources = [
      "${aws_dynamodb_table.table.arn}/index/*",
      "${aws_dynamodb_table.table.arn}/stream/*",
    ]
  }

  statement {
    sid = "DynamoDBTableAccess"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
    ]
    resources = [aws_dynamodb_table.table.arn]
  }

  statement {
    sid = "DynamoDBDescribeLimitsAccess"
    actions = [
      "dynamodb:DescribeLimits",
    ]
    resources = [
      aws_dynamodb_table.table.arn,
      "${aws_dynamodb_table.table.arn}/index/*"
    ]
  }
}

module "readwrite_policy" {
  count = var.create_iam_readwrite_policy ? 1 : 0

  source = "git@github.com:powise/terraform-modules//aws/iam/policy?ref=aws-iam-policy-0.0.1"

  name = "DynamoDB-${aws_dynamodb_table.table.name}-${data.aws_region.current.name}-ReadWrite"

  description = "Read/write policy for the DynamoDB table ${aws_dynamodb_table.table.name} (${data.aws_region.current.name})."
  policy      = data.aws_iam_policy_document.readwrite.json
  tags        = local.tags
}

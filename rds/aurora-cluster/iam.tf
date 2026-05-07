resource "aws_iam_group" "rds_read" {
  count = var.create_iam_groups ? 1 : 0

  name     = "rds-read-${local.instance_identifier}-0"
  provider = aws.identity
}

resource "aws_iam_group" "rds_write" {
  count = var.create_iam_groups ? 1 : 0

  name     = "rds-write-${local.instance_identifier}-0"
  provider = aws.identity
}

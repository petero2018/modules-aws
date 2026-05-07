resource "aws_iam_group" "rds_read" {
  for_each = toset(var.identifiers)
  name     = "rds-read-${each.value}"
}

resource "aws_iam_group" "rds_write" {
  for_each = toset(var.identifiers)
  name     = "rds-write-${each.value}"
}

resource "aws_iam_role" "main_backup_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.allow_backup.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "main_backup_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.main_backup_role.name
}

data "aws_iam_policy_document" "allow_backup" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_backup_selection" "dynamodb_daily" {
  iam_role_arn = var.backup_role_arn
  name         = "dynamodb_daily"
  plan_id      = aws_backup_plan.dynamodb_daily.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup_plan"
    value = var.dynamodb_selection_tag
  }
}

resource "aws_backup_selection" "rds_daily" {
  iam_role_arn = var.backup_role_arn
  name         = "rds_daily"
  plan_id      = aws_backup_plan.rds_daily.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup_plan"
    value = var.rds_selection_tag
  }
}

resource "aws_backup_selection" "s3_backup" {
  iam_role_arn = var.backup_role_arn
  name         = "s3_backup"
  plan_id      = aws_backup_plan.s3_backup.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup_plan"
    value = var.s3_selection_tag
  }
}

resource "aws_backup_selection" "clickhouse_ebs" {
  iam_role_arn = var.backup_role_arn
  name         = "clickhouse_ebs"
  plan_id      = aws_backup_plan.clickhouse_ebs.id

  resources = ["arn:aws:ec2:*:*:volume/*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/KubernetesCluster"
      value = "clickhouse"
    }
    string_equals {
      key   = "aws:ResourceTag/kubernetes.io/created-for/pvc/namespace"
      value = "clickhouse"
    }
    string_like {
      key   = "aws:ResourceTag/kubernetes.io/created-for/pv/name"
      value = "*"
    }
    string_like {
      key   = "aws:ResourceTag/kubernetes.io/created-for/pvc/name"
      value = "*"
    }
  }
}

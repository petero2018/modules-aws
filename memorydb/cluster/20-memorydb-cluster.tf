resource "aws_memorydb_parameter_group" "memorydb_parameter_group" {
  count  = var.parameter_group_name == "default" ? 0 : 1
  name   = var.parameter_group_name
  family = "redis7"

  tags = local.tags
}

resource "aws_memorydb_cluster" "memorydb_cluster" {
  #checkov:skip=CKV_AWS_202: TODO: implement TLS in all Redis

  name = var.memorydb_name

  engine_version             = var.redis_version
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  port                       = 6379
  node_type                  = var.node_type
  num_shards                 = var.num_shards
  num_replicas_per_shard     = var.num_replicas_per_shard
  parameter_group_name       = var.parameter_group_name == "default" ? var.default_parameter_group[var.redis_version] : var.parameter_group_name
  data_tiering               = var.data_tiering

  tls_enabled = var.iam_authentication_enabled ? true : var.tls_enabled
  acl_name    = var.iam_authentication_enabled ? local.iam_acl : var.acl_name
  kms_key_arn = var.kms_key_arn

  security_group_ids = [aws_security_group.memorydb_security_group.id]
  subnet_group_name  = var.subnet_group_name

  maintenance_window = var.maintenance_window

  snapshot_retention_limit = 5
  snapshot_window          = var.snapshot_window
  final_snapshot_name      = "${var.memorydb_name}-final-snapshot"

  tags       = var.tags
  depends_on = [aws_memorydb_acl.iamacl]
}

resource "aws_memorydb_user" "iamuser" {
  count = var.iam_authentication_enabled ? 1 : 0

  user_name     = local.iam_user
  access_string = local.iam_access_string

  authentication_mode {
    type = "iam"
  }

  tags = var.tags
}

resource "aws_memorydb_acl" "iamacl" {
  count = var.iam_authentication_enabled ? 1 : 0

  name = local.iam_acl

  user_names = [aws_memorydb_user.iamuser[0].id]

  lifecycle {
    create_before_destroy = true
  }

  tags       = var.tags
  depends_on = [aws_memorydb_user.iamuser]
}

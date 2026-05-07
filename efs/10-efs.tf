resource "aws_efs_file_system" "efs" {
  #checkov:skip=CKV2_AWS_18:Backup plan should be configured outside of the module if needed
  creation_token                  = var.creation_token
  tags                            = var.tags
  encrypted                       = var.encrypted
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
  kms_key_id                      = var.kms_key_id

  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy != null ? [var.lifecycle_policy] : []

    content {
      transition_to_ia                    = lifecycle_policy.value.transition_to_ia
      transition_to_primary_storage_class = lifecycle_policy.value.transition_to_primary_storage_class
    }
  }
}

resource "aws_efs_mount_target" "default" {
  for_each        = toset(var.subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  ip_address      = var.mount_target_ip_address
  subnet_id       = each.value
  security_groups = var.security_group_ids
}

resource "aws_efs_backup_policy" "policy" {
  count = var.enable_backups ? 1 : 0

  file_system_id = aws_efs_file_system.efs.id

  backup_policy {
    status = "ENABLED"
  }
}

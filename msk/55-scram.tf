resource "aws_msk_scram_secret_association" "default" {
  count = var.client_sasl_scram_enabled ? 1 : 0

  cluster_arn = aws_msk_cluster.cluster.arn
  secret_arn_list = concat(
    [for username in var.scram_users : aws_secretsmanager_secret.scram[username].arn],
    var.client_sasl_scram_secret_association_arns,
  )

  depends_on = [aws_secretsmanager_secret_version.credentials]
}

resource "aws_secretsmanager_secret" "scram" {
  #checkov:skip=CKV2_AWS_57:We don't want automatic rotation here for now

  for_each = toset(var.scram_users)

  name       = "AmazonMSK_${local.full_name}_${each.key}" # Must start with "AmazonMSK_"
  kms_key_id = module.kms_scram[0].key_arn
}

resource "random_password" "scram_password" {
  for_each = toset(var.scram_users)

  override_special = "!@#&*-_=+[]<>:?" # Removed symbols that can trip templating languages

  length = 128

  lifecycle { # It's not necessary to regenerate previous passwords if we change the special characters
    ignore_changes = [override_special]
  }
}

resource "aws_secretsmanager_secret_version" "credentials" {
  for_each = toset(var.scram_users)

  secret_id = aws_secretsmanager_secret.scram[each.key].id
  secret_string = jsonencode(
    {
      username = each.key
      password = random_password.scram_password[each.key].result
    }
  )
}

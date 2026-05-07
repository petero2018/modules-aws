data "aws_acm_certificate" "powise_tf" {
  domain      = var.certificate_domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_iam_saml_provider" "okta" {
  name                   = var.saml_provider_name
  saml_metadata_document = var.okta_metadata_document
  tags                   = var.tags
}

resource "aws_ec2_client_vpn_endpoint" "powise_client_vpn" {
  description            = "${var.name} VPN Client"
  server_certificate_arn = data.aws_acm_certificate.powise_tf.arn
  client_cidr_block      = var.client_cidr_block
  self_service_portal    = var.self_service_portal
  split_tunnel           = var.split_tunnel
  dns_servers            = local.dns_servers

  tags = merge(var.tags, {
    Name = var.name
  })

  authentication_options {
    type              = "federated-authentication"
    saml_provider_arn = aws_iam_saml_provider.okta.arn
  }

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.vpn_endpoint.name
  }
}

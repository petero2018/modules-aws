resource "aws_opensearch_domain_saml_options" "saml" {
  count = var.saml_enable ? 1 : 0

  domain_name = aws_opensearch_domain.es.domain_name

  saml_options {
    enabled             = true
    master_backend_role = var.saml_master_backend_role
    roles_key           = var.saml_roles_key
    idp {
      entity_id        = var.saml_idp_entity_id
      metadata_content = var.saml_metadata_xml
    }
    session_timeout_minutes = var.saml_session_timeout_minutes
  }
}

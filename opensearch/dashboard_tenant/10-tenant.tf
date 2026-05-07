resource "opensearch_dashboard_tenant" "custom_tenant" {

  tenant_name = var.name
  description = var.description
}

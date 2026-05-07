resource "opensearch_composable_index_template" "template" {
  for_each = var.index_templates

  name = each.key
  body = each.value
}

resource "opensearch_dashboard_object" "index_pattern" {
  for_each = var.index_patterns

  body = jsonencode(
    [
      {
        "_id"   = "index-pattern:${each.key}"
        "_type" = ""
        "_source" = {
          "type" = "index-pattern"
          "index-pattern" = {
            "title"         = each.key
            "timeFieldName" = each.value
          }
        }
      }
    ]
  )
}

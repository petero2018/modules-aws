module "parameter" {
  for_each = var.parameters

  source = "../parameter"

  name           = each.key
  value          = each.value.value
  insecure_value = each.value.insecure_value
  type           = each.value.type

  dynamic               = each.value.dynamic
  dynamic_initial_value = each.value.dynamic_initial_value

  description = coalesce(each.value.description, var.description)
  tags        = merge(var.tags, each.value.tags)
}

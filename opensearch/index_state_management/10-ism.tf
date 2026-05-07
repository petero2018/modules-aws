module "body" {
  source = "../../../terraform/object_clean"

  object = jsonencode({
    policy = {
      description   = var.description
      default_state = var.default_state
      states        = var.states
      ism_template  = var.ism_template
    }
  })
}

resource "opensearch_ism_policy" "cleanup" {
  policy_id = var.policy_id
  body      = module.body.result
}

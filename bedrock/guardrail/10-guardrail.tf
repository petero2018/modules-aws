locals {
  # This somewhat convoluted logic is to ensure that the content policy config is ordered
  # in the way that the underlying AWS API expects. Iterating through keys does not
  # guarantee this order, which can lead to a perpetual diff. This may be get fixed in the
  # future in the provider, at which point this can be simplified.
  content_policy_config_ordered = [
    {
      type            = "violence"
      input_strength  = var.content_filters.violence.prompt
      output_strength = var.content_filters.violence.response
    },
    {
      type            = "prompt_attack"
      input_strength  = var.prompt_attack_threshold
      output_strength = "NONE"
    },
    {
      type            = "misconduct"
      input_strength  = var.content_filters.misconduct.prompt
      output_strength = var.content_filters.misconduct.response
    },
    {
      type            = "hate"
      input_strength  = var.content_filters.hate.prompt
      output_strength = var.content_filters.hate.response
    },
    {
      type            = "sexual"
      input_strength  = var.content_filters.sexual.prompt
      output_strength = var.content_filters.sexual.response
    },
    {
      type            = "insults"
      input_strength  = var.content_filters.insults.prompt
      output_strength = var.content_filters.insults.response
    },
  ]
}

resource "aws_bedrock_guardrail" "guardrail" {
  name                      = var.name
  blocked_input_messaging   = var.blocked_input_message
  blocked_outputs_messaging = var.blocked_output_message != null ? var.blocked_output_message : var.blocked_input_message
  description               = var.description
  kms_key_arn               = var.enable_encryption ? module.guardrail_key[0].key_arn : null

  content_policy_config {
    dynamic "filters_config" {
      for_each = local.content_policy_config_ordered
      iterator = filter

      content {
        input_strength  = filter.value.input_strength
        output_strength = filter.value.output_strength
        type            = upper(filter.value.type)
      }
    }
  }

  dynamic "sensitive_information_policy_config" {
    for_each = anytrue([
      length(var.pii_entities_config) > 0,
      length(var.regexes_config) > 0,
    ]) ? ["_"] : []

    content {
      dynamic "pii_entities_config" {
        for_each = var.pii_entities_config
        iterator = pii_config

        content {
          action = pii_config.value.action
          type   = pii_config.value.type
        }
      }

      dynamic "regexes_config" {
        for_each = var.regexes_config
        iterator = re_config

        content {
          action      = re_config.value.action
          description = re_config.value.description
          name        = re_config.value.name
          pattern     = re_config.value.pattern
        }
      }
    }
  }

  dynamic "topic_policy_config" {
    for_each = length(var.topic_policies) > 0 ? ["_"] : []

    content {
      dynamic "topics_config" {
        for_each = var.topic_policies
        iterator = policy

        content {
          name       = policy.value.name
          examples   = policy.value.examples
          type       = policy.value.type
          definition = policy.value.definition
        }
      }
    }
  }

  dynamic "word_policy_config" {
    for_each = anytrue([
      length(var.word_filters.managed_word_lists) > 0,
      length(var.word_filters.words) > 0,
    ]) ? ["_"] : []

    content {

      dynamic "managed_word_lists_config" {
        for_each = var.word_filters.managed_word_lists
        iterator = managed_word_list

        content {
          type = managed_word_list.value
        }
      }

      dynamic "words_config" {
        for_each = var.word_filters.words

        content {
          text = words_config.value
        }
      }
    }
  }

  dynamic "contextual_grounding_policy_config" {
    for_each = length(keys(var.contextual_grounding_policy_config)) > 0 ? ["_"] : []

    content {
      dynamic "filters_config" {
        for_each = var.contextual_grounding_policy_config
        iterator = fc

        content {
          type      = upper(fc.key)
          threshold = fc.value
        }
      }
    }
  }
}

resource "aws_bedrock_guardrail_version" "versions" {
  for_each = toset(var.published_versions)

  guardrail_arn = aws_bedrock_guardrail.guardrail.guardrail_arn
  description   = each.value
  skip_destroy  = false
}

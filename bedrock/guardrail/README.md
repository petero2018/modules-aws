# guardrail

This module defines a Bedrock Guardrail and its published versions.

Updating the configuration of this module and applying the changes will update
the "working draft" of the Guardrail in the console to allow for iterative testing.

To publish the current state of the module for use, include a new entry in the [published\_versions](#input\_published\_versions) list describing the version.

**NOTE:** Removing an entry from the list of published versions will delete that version number. Due
to how the Guardrail API works, subsequent entries will continue to increment.

For example, consider the initial setup with 2 published versions:

```terraform
# Initial state
published_versions = [
  "My first version", # <-- Will be Version 1 as returned by the API
  "My new version",   # <-- Will be Version 2 as returned by the API
]
```

Removing an element from the list will remove the associated version number:

```terraform
published_versions = [
                           # <-- Version 1 will be deleted
  "My new version",        # <-- Remains as Version 2
  "My even newer version", # <-- Will be Version 3 as returned by the API
]
```

A list of versions numbers and their descriptions is published as an output of the module.
It is recommended to use these values and not rely on indexing the `published_versions` list.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.63.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.63.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_guardrail_key"></a> [guardrail\_key](#module\_guardrail\_key) | ../../kms | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_bedrock_guardrail.guardrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_guardrail) | resource |
| [aws_bedrock_guardrail_version.versions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_guardrail_version) | resource |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blocked_input_message"></a> [blocked\_input\_message](#input\_blocked\_input\_message) | The message returned when a prompt is blocked | `string` | n/a | yes |
| <a name="input_blocked_output_message"></a> [blocked\_output\_message](#input\_blocked\_output\_message) | The message returned when a response is blocked. Defaults to the same as the input message | `string` | `null` | no |
| <a name="input_content_filters"></a> [content\_filters](#input\_content\_filters) | Configuration specifying how the Guardrail will filter content being provided to and returned from the model. | <pre>object({<br>    violence = optional(object({<br>      prompt   = string<br>      response = string<br>      }), {<br>      prompt   = "HIGH"<br>      response = "HIGH"<br>    })<br>    misconduct = optional(object({<br>      prompt   = string<br>      response = string<br>      }), {<br>      prompt   = "HIGH"<br>      response = "HIGH"<br>    })<br>    hate = optional(object({<br>      prompt   = string<br>      response = string<br>      }), {<br>      prompt   = "HIGH"<br>      response = "HIGH"<br>    })<br>    sexual = optional(object({<br>      prompt   = string<br>      response = string<br>      }), {<br>      prompt   = "HIGH"<br>      response = "HIGH"<br>    })<br>    insults = optional(object({<br>      prompt   = string<br>      response = string<br>      }), {<br>      prompt   = "HIGH"<br>      response = "HIGH"<br>    })<br>  })</pre> | <pre>{<br>  "hate": {<br>    "prompt": "HIGH",<br>    "response": "HIGH"<br>  },<br>  "insults": {<br>    "prompt": "HIGH",<br>    "response": "HIGH"<br>  },<br>  "misconduct": {<br>    "prompt": "HIGH",<br>    "response": "HIGH"<br>  },<br>  "sexual": {<br>    "prompt": "HIGH",<br>    "response": "HIGH"<br>  },<br>  "violence": {<br>    "prompt": "HIGH",<br>    "response": "HIGH"<br>  }<br>}</pre> | no |
| <a name="input_contextual_grounding_policy_config"></a> [contextual\_grounding\_policy\_config](#input\_contextual\_grounding\_policy\_config) | A map of contextual grounding types to their respective thresholds | `map(number)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the guardrail | `string` | n/a | yes |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | Whether to encrypt the guardrail | `bool` | `true` | no |
| <a name="input_guardrail_users"></a> [guardrail\_users](#input\_guardrail\_users) | A list of AWS principals who can use the guardrail | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the guardrail | `string` | n/a | yes |
| <a name="input_pii_entities_config"></a> [pii\_entities\_config](#input\_pii\_entities\_config) | A list of PII entities to ANONYMIZE or MASK. See https://docs.aws.amazon.com/bedrock/latest/APIReference/API_GuardrailPiiEntityConfig.html for a list of the relevant types | <pre>list(object({<br>    action = optional(string, "BLOCK")<br>    type   = string<br>  }))</pre> | `[]` | no |
| <a name="input_prompt_attack_threshold"></a> [prompt\_attack\_threshold](#input\_prompt\_attack\_threshold) | The threshold for prompt attack detection | `string` | `"HIGH"` | no |
| <a name="input_published_versions"></a> [published\_versions](#input\_published\_versions) | Each entry will create a published version of the guardrail for use. | `list(string)` | `[]` | no |
| <a name="input_regexes_config"></a> [regexes\_config](#input\_regexes\_config) | Regular expressions describing additional sensitive information to BLOCK or ANONYMIZE | <pre>list(object({<br>    action      = optional(string, "BLOCK")<br>    description = string<br>    name        = string<br>    pattern     = string<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the guardrail | `map(string)` | n/a | yes |
| <a name="input_topic_policies"></a> [topic\_policies](#input\_topic\_policies) | Up to 30 denied topics to block user inputs or model responses associated with the topic | <pre>list(object({<br>    name       = string<br>    type       = optional(string, "DENY")<br>    definition = string<br>    examples   = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_word_filters"></a> [word\_filters](#input\_word\_filters) | Managed word lists or custom words that will be filtered from the model's inputs and responses | <pre>object({<br>    managed_word_lists = optional(list(string), [])<br>    words              = optional(list(string), [])<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardrail_arn"></a> [guardrail\_arn](#output\_guardrail\_arn) | The ARN of the guardrail |
| <a name="output_guardrail_id"></a> [guardrail\_id](#output\_guardrail\_id) | The ID of the guardrail |
| <a name="output_published_versions"></a> [published\_versions](#output\_published\_versions) | The published versions of the guardrail |
| <a name="output_status"></a> [status](#output\_status) | The status of the guardrail |
| <a name="output_version"></a> [version](#output\_version) | The current version of the guardrail |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

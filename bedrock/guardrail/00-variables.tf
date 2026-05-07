variable "name" {
  type        = string
  description = "The name of the guardrail"
}

variable "description" {
  type        = string
  description = "The description of the guardrail"
}

variable "published_versions" {
  type        = list(string)
  description = "Each entry will create a published version of the guardrail for use."
  default     = []
}

variable "enable_encryption" {
  type        = bool
  description = "Whether to encrypt the guardrail"
  default     = true
}

variable "guardrail_users" {
  type        = list(string)
  description = "A list of AWS principals who can use the guardrail"
  default     = []
}

variable "blocked_input_message" {
  type        = string
  description = "The message returned when a prompt is blocked"
  nullable    = false
}

variable "blocked_output_message" {
  type        = string
  description = "The message returned when a response is blocked. Defaults to the same as the input message"
  default     = null
}

# Content and filtering variables

variable "content_filters" {
  type = object({
    violence = optional(object({
      prompt   = string
      response = string
      }), {
      prompt   = "HIGH"
      response = "HIGH"
    })
    misconduct = optional(object({
      prompt   = string
      response = string
      }), {
      prompt   = "HIGH"
      response = "HIGH"
    })
    hate = optional(object({
      prompt   = string
      response = string
      }), {
      prompt   = "HIGH"
      response = "HIGH"
    })
    sexual = optional(object({
      prompt   = string
      response = string
      }), {
      prompt   = "HIGH"
      response = "HIGH"
    })
    insults = optional(object({
      prompt   = string
      response = string
      }), {
      prompt   = "HIGH"
      response = "HIGH"
    })
  })
  default = {
    violence = {
      prompt   = "HIGH"
      response = "HIGH"
    }
    misconduct = {
      prompt   = "HIGH"
      response = "HIGH"
    }
    hate = {
      prompt   = "HIGH"
      response = "HIGH"
    }
    insults = {
      prompt   = "HIGH"
      response = "HIGH"
    }
    sexual = {
      prompt   = "HIGH"
      response = "HIGH"
    }
  }
  description = "Configuration specifying how the Guardrail will filter content being provided to and returned from the model."
  nullable    = false
}

variable "prompt_attack_threshold" {
  type        = string
  description = "The threshold for prompt attack detection"
  default     = "HIGH"
  nullable    = false
}

variable "contextual_grounding_policy_config" {
  type        = map(number)
  description = "A map of contextual grounding types to their respective thresholds"
  default     = {}
  nullable    = false

  validation {
    # The provider does not validate this during a plan, leading to apply-time errors
    condition = alltrue([
      for threshold in values(var.contextual_grounding_policy_config) :
      threshold < 1 && threshold >= 0
    ])
    error_message = "Thresholds must be >= 0 and < 1."
  }
}

variable "pii_entities_config" {
  type = list(object({
    action = optional(string, "BLOCK")
    type   = string
  }))
  description = "A list of PII entities to ANONYMIZE or MASK. See https://docs.aws.amazon.com/bedrock/latest/APIReference/API_GuardrailPiiEntityConfig.html for a list of the relevant types"
  default     = []
  nullable    = false
}

variable "regexes_config" {
  type = list(object({
    action      = optional(string, "BLOCK")
    description = string
    name        = string
    pattern     = string
  }))
  description = "Regular expressions describing additional sensitive information to BLOCK or ANONYMIZE"
  default     = []
  nullable    = false
}

variable "topic_policies" {
  type = list(object({
    name       = string
    type       = optional(string, "DENY")
    definition = string
    examples   = optional(list(string))
  }))
  description = "Up to 30 denied topics to block user inputs or model responses associated with the topic"
  default     = []
  nullable    = false

  # The provider does not validate this during a plan, leading to apply-time errors
  validation {
    condition     = alltrue([for topic in var.topic_policies : length(topic.examples) <= 5])
    error_message = "No more than 5 examples may be defined per topic policy"
  }
}

variable "word_filters" {
  type = object({
    managed_word_lists = optional(list(string), [])
    words              = optional(list(string), [])
  })
  description = "Managed word lists or custom words that will be filtered from the model's inputs and responses"
  default     = {}
  nullable    = false
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the guardrail"

  validation {
    condition     = contains(keys(var.tags), "team")
    error_message = "You must include a 'team' tag"
  }

  validation {
    condition     = contains(keys(var.tags), "service")
    error_message = "You must include a 'service' tag"
  }

  validation {
    condition     = contains(keys(var.tags), "impact")
    error_message = "You must include a 'impact' tag"
  }
}

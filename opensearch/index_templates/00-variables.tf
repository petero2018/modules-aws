variable "index_templates" {
  type = map(string)

  default = {}

  description = "Map of name => JSON index template to create."
}

variable "index_patterns" {
  type = map(string)

  default = {}

  description = "Map of index pattern => time field name to create."
}

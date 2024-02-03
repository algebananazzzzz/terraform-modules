variable "name" {
  description = "Friendly name for the IAM role"
  type        = string
}

variable "custom_policy" {
  description = "Configuration for creating a new custom policy to be attached to the role."
  type = object({
    name        = string
    description = optional(string)
    statements = map(object({
      effect    = string
      actions   = list(string)
      resources = list(string)
      conditions = optional(list(object({
        condition_operator = string
        condition_key      = string
        condition_value    = string
      })))
    }))
    tags = optional(map(string))
  })
  default = null
}

variable "assume_role_allowed_principals" {
  description = "Allowed principals for an assume role policy to assume the role. Defaults to a Lambda Service example."
  type = list(object({
    type        = string
    identifiers = list(string)
  }))
  default = [{
    type        = "Service"
    identifiers = ["lambda.amazonaws.com"]
  }]
}

variable "additional_policy_attachments" {
  description = "List of Arns for policies to be attached to the role. The policies must be managed outside this module."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map of tags to assign to the role and custom policy."
  type        = map(string)
  default     = {}
}

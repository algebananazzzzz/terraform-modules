variable "role_name" {
  type = string
}

variable "role_managed_policy_arns" {
  type        = list(string)
  description = "Set of exclusive IAM managed policy ARNs to attach to the IAM role"
  default     = null
}

variable "role_description" {
  type        = string
  description = "Description of the role"
  default     = null
}

variable "role_max_session_duration" {
  type        = number
  description = "Maximum session duration (in seconds) that you want to set for the specified role"
  default     = null
}

variable "role_permissions_boundary" {
  type        = string
  description = "ARN of the policy that is used to set the permissions boundary for the role"
  default     = null
}

variable "role_tags" {
  type    = map(string)
  default = null
}

variable "assume_role_policy" {
  type = map(list(string))
}

variable "policy_document" {
  type = object({
    name        = optional(string)
    description = optional(string)
    id          = optional(string)
    version     = optional(string)
    statements = map(object({
      effect    = string
      actions   = list(string)
      resources = optional(list(string))
      conditions = optional(map(object({
        context_variable = string
        values           = list(string)
      })))
    }))
    tags = optional(map(string))
  })
  default = null
}

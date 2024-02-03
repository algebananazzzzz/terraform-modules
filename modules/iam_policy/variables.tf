variable "name" {
  type        = string
  description = "The name of the policy. If omitted, Terraform will assign a random, unique name"
  default     = null
}

variable "description" {
  type        = string
  description = "Description of the IAM policy"
  default     = null
}

variable "document_version" {
  type        = string
  description = "IAM policy document version"
  default     = "2012-10-17"
}

variable "document_statements" {
  description = "Configuration block for a policy statement"
  type = map(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
    conditions = optional(list(object({
      condition_operator = string
      condition_key      = string
      condition_value    = string
    })))
  }))
}

variable "tags" {
  type        = map(string)
  description = "Map of resource tags for the IAM Policy"
  default     = null
}

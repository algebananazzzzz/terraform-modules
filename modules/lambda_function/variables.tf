variable "aliases" {
  type = map(object({
    alias_name  = string
    description = optional(string)
  }))
  default = {}
}

variable "execution_role_policy_document" {
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

variable "deployment_package" {
  type = object({
    local_path        = optional(string)
    s3_bucket         = optional(string)
    s3_key            = optional(string)
    s3_object_version = optional(string)
    s3_create_object_from_local = optional(object({
      local_path = string
    }))
  })
}

variable "vpc_config" {
  type = object({
    subnet_ids                  = list(string)
    security_group_ids          = list(string)
    ipv6_allowed_for_dual_stack = optional(bool)
  })
  default = null
}

variable "function_name" {
  type = string
}

variable "execution_role_name" {
  type = string
}

variable "architectures" {
  type    = list(string)
  default = null
}

variable "description" {
  type    = string
  default = null
}

variable "environment_variables" {
  type    = map(string)
  default = null
}

variable "ephemeral_storage_size" {
  type    = number
  default = 512
}

variable "handler" {
  type    = string
  default = null
}

variable "layers" {
  type    = list(string)
  default = null
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "reserved_concurrent_executions" {
  type    = number
  default = -1
}

variable "runtime" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "timeout" {
  type    = number
  default = 3
}

variable "logs_retention_in_days" {
  type    = number
  default = 30
}

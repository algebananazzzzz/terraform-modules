variable "lambda_integrations" {
  type = map(object({
    function_name         = string
    integration_uri       = string
    path                  = string
    alias_name_or_version = optional(string)
    description           = optional(string)
    request_parameters    = optional(map(string))
  }))
}

variable "stage_name" {
  type    = string
  default = "default"
}

variable "stage_description" {
  type    = string
  default = "Default stage managed by Terraform"
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Api Gateway Lambda integration"
}

variable "disable_execute_api_endpoint" {
  type    = bool
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "cors_configuration" {
  type = object({
    allow_credentials = optional(bool)
    allow_headers     = optional(list(string))
    allow_origins     = optional(list(string))
    allow_methods     = optional(list(string))
    expose_headers    = optional(list(string))
    max_age           = optional(number)
  })
  default = null
}

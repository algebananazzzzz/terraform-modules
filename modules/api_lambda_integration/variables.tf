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

variable "stage_configuration" {
  type = map(object({
    api_gateway_stage_name        = string
    api_gateway_stage_description = optional(string)
  }))
}

variable "api_gateway_name" {
  type = string
}

variable "api_gateway_stage_name" {
  type    = string
  default = "api"
}

variable "api_gateway_stage_description" {
  type    = string
  default = "Default stage"
}

variable "api_gateway_description" {
  type    = string
  default = "Api Gateway Lambda integration"
}

variable "api_gateway_disable_execute_api_endpoint" {
  type    = bool
  default = null
}

variable "api_gateway_tags" {
  type    = map(string)
  default = null
}

variable "api_gateway_cors_configuration" {
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

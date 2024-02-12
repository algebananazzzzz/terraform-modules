variable "name" {
  description = "Name of the API. Must be less than or equal to 128 characters in length."
  type        = string
}

variable "api_key_selection_expression" {
  type        = string
  description = "An API key selection expression. Valid values: $request.header.x-api-key (default), $context.authorizer.usageIdentifierKey (applicable for WebSocket APIs)."
  default     = "$request.header.x-api-key"
}

variable "cors_configuration" {
  description = "Cross-origin resource sharing (CORS) configuration. Applicable for HTTP APIs."
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

variable "default_stage_auto_deploy" {
  type        = bool
  description = "Whether updates to an API automatically trigger a new deployment for the default stage."
  default     = true
}

variable "default_stage_description" {
  type        = string
  description = "Description for the default stage."
  default     = null
}

variable "description" {
  type        = string
  description = "Description of the API."
  default     = null
}

variable "disable_execute_api_endpoint" {
  description = "Whether clients can invoke the API by using the default execute-api endpoint. To require that clients use a custom domain name to invoke the API, set this to true."
  type        = bool
  default     = false
}

variable "route_selection_expression" {
  description = "The route selection expression for the API. Applicable for WebSocket APIs."
  type        = string
  default     = "$request.method $request.path"
}

variable "protocol_type" {
  description = "API protocol. Valid values: HTTP, WEBSOCKET."
  type        = string
  default     = "HTTP"
}

variable "tags" {
  description = "Map of tags to assign to the API."
  type        = map(string)
  default     = null
}

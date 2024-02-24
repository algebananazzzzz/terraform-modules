variable "function_name" {
  description = "Name of the Lambda function."
  type        = string
}

variable "function_alias_or_version" {
  description = "Query parameter to specify function version or alias name."
  type        = string
  default     = null
}

variable "function_invoke_arn" {
  description = "URI of the Lambda function for the Lambda proxy integration."
  type        = string
}

variable "integration_description" {
  description = "Description of the Lambda integration."
  type        = string
  default     = null
}

variable "integration_path" {
  description = "Resource path for the Lambda integration e.g. api. Defaults to proxy+."
  type        = string
  default     = "{proxy+}"
}

variable "api_gateway_id" {
  description = "Identifier for the API."
  type        = string
}

variable "api_gateway_execution_arn" {
  description = "Execution arn of the API."
  type        = string
}

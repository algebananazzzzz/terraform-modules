variable "deployment_package" {
  description = "Configuration for the deployment package. Accepts an object with `local_path` specified"
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

variable "execution_role_name" {
  description = "Friendly name for the IAM execution role the lambda function will assume."
  type        = string
}

variable "function_name" {
  description = "Unique name for your Lambda Function"
  type        = string
}

variable "aliases" {
  description = "Configuration for aliases to be created for the function. Takes a map of object specifying `alias_name` and `description` (optional)."
  type = map(object({
    alias_name  = string
    description = optional(string)
  }))
  default = {}
}

variable "architectures" {
  description = "Instruction set architecture for your Lambda function. Valid values are [x86_64] and [arm64]"
  type        = list(string)
  default     = null
}

variable "description" {
  description = "Description of what your Lambda Function does."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Map of environment variables that are accessible from the function code during execution"
  type        = map(string)
  default     = null
}

variable "ephemeral_storage_size" {
  description = "The size of the Lambda function Ephemeral storage (/tmp) represented in MB."
  type        = number
  default     = 512
}

variable "execution_role_policy_document" {
  description = "Configuration for a custom policiy to be associated with the execution role. Takes `name`, `description`, `version` and `statements`."
  type = object({
    name        = optional(string)
    description = optional(string)
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

variable "handler" {
  description = "Function entrypoint in your code"
  type        = string
  default     = null
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function"
  type        = list(string)
  default     = null
}

variable "logs_retention_in_days" {
  description = "Number of days you want to retain log events in the Lambda log group."
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  type        = number
  default     = 128
}

variable "reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations"
  type        = number
  default     = -1
}

variable "runtime" {
  description = "Identifier of the function's runtime"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the Lambda function."
  type        = map(string)
  default     = null
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "vpc_config" {
  description = "VPC Configuration for the Lambda function. Takes `subnet_ids`, `security_group_ids` and `ipv6_allowed_for_dual_stack`"
  type = object({
    subnet_ids                  = list(string)
    security_group_ids          = list(string)
    ipv6_allowed_for_dual_stack = optional(bool)
  })
  default = null
}

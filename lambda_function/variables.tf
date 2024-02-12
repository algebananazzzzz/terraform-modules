variable "deployment_package" {
  description = "Configuration for the deployment package. One of `filename, image_uri, s3_bucket` must be specified."
  type = object({
    filename          = optional(string)
    source_code_hash  = optional(string)
    image_uri         = optional(string)
    s3_bucket         = optional(string)
    s3_key            = optional(string)
    s3_object_version = optional(string)
  })

  validation {
    condition = anytrue([
      var.deployment_package.filename != null,
      var.deployment_package.image_uri != null,
      var.deployment_package.s3_bucket != null
    ])

    error_message = "One of `filename, image_uri, s3_bucket` must be specified"
  }

  validation {
    condition = anytrue([
      var.deployment_package.s3_bucket == null,
      var.deployment_package.s3_key != null
    ])

    error_message = "`s3_key` must be specified when `s3_bucket` is set"
  }

  validation {
    condition = anytrue([
      var.deployment_package.source_code_hash == null,
      var.deployment_package.filename != null
    ])
    error_message = "`source_code_hash` can only be specified when `filename` is set"
  }

  validation {
    condition = anytrue([
      var.deployment_package.s3_key == null,
      var.deployment_package.s3_bucket != null
    ])

    error_message = "`s3_key` can only be specified when `s3_bucket` is set"
  }

  validation {
    condition = anytrue([
      var.deployment_package.s3_object_version == null,
      var.deployment_package.s3_bucket != null
    ])

    error_message = "`s3_object_version` can only be specified when `s3_bucket` is set"
  }

  validation {
    condition = anytrue([
      alltrue([
        var.deployment_package.filename != null,
        var.deployment_package.image_uri == null,
        var.deployment_package.s3_bucket == null
      ]),
      alltrue([
        var.deployment_package.filename == null,
        var.deployment_package.image_uri != null,
        var.deployment_package.s3_bucket == null
      ]),
      alltrue([
        var.deployment_package.filename == null,
        var.deployment_package.image_uri == null,
        var.deployment_package.s3_bucket != null
      ])
    ])
    error_message = "Only one of `filename, s3_bucket, image_uri` can be specified."
  }
}

variable "function_name" {
  description = "Unique name for your Lambda Function. Must follow naming convention."
  type        = string

  validation {
    condition     = can(regex("^(wogaa|sentiments|snowplow|common|inspect)-(ci|qe|stg|prd)(ez|iz|mz|dz)(web|app|db|it|gut|na)-(.*)$", var.function_name))
    error_message = "Function name does not follow naming convention. Please refer to Confluence page for more details."
  }
}

variable "execution_role_arn" {
  description = "Arn of the IAM execution role for the Lambda function."
  type        = string
}

variable "ignore_deployment_package_changes" {
  description = "Boolean controlling whether lifecycle should ignore changes to deployment package (local files/s3/image uri)."
  type        = bool
  default     = false
}

variable "image_config" {
  description = "Container image configuration values that override the values in the container image Dockerfile."
  type = object({
    command           = optional(list(string))
    entry_point       = optional(list(string))
    working_directory = optional(string)
  })
  default = null
}

variable "aliases" {
  description = "List of names of aliases to be created for the function."
  type        = list(string)
  default     = []
}

variable "vpc_config" {
  description = "Configuration specifying a list of security groups and subnets in the VPC."
  type = object({
    subnet_ids                  = list(string)
    security_group_ids          = list(string)
    ipv6_allowed_for_dual_stack = optional(bool)
  })
  default = null
}

variable "architectures" {
  description = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]."
  type        = list(string)
  default     = ["x86_64"]
}

variable "description" {
  description = "Description of what your Lambda Function does."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Map of environment variables that are accessible from the function code during execution. At least one key must be present."
  type        = map(string)
  default     = null
}

variable "ephemeral_storage_size" {
  description = "The size of the Lambda function Ephemeral storage (/tmp) represented in MB. Maximum supported value of 10240."
  type        = number
  default     = 512
}

variable "handler" {
  description = "Function entrypoint in your code. Required if the deployment package type is `filename` or `s3`"
  type        = string
  default     = null
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = []
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  type        = number
  default     = 128
}

variable "reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions. Value of 0 disables lambda from being triggered and -1 removes any concurrency limitations."
  type        = number
  default     = -1
}

variable "runtime" {
  description = "Identifier of the function's runtime. Required if the deployment package type is `filename` or `s3`"
  type        = string
  default     = null
}

variable "timeout" {
  description = "Amount of time your Lambda Function can run in seconds before returning a TaskTimeout error."
  type        = number
  default     = 3
}

variable "logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the Lambda log group."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Map of tags to assign to the Lambda function."
}

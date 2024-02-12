resource "aws_lambda_function" "lambda" {
  count         = var.ignore_deployment_package_changes ? 0 : 1
  function_name = var.function_name
  role          = var.execution_role_arn
  runtime       = var.runtime

  package_type      = var.deployment_package.image_uri == null ? "Zip" : "Image"
  filename          = var.deployment_package.filename
  source_code_hash  = var.deployment_package.source_code_hash
  s3_bucket         = var.deployment_package.s3_bucket
  s3_key            = var.deployment_package.s3_key
  s3_object_version = var.deployment_package.s3_object_version
  image_uri         = var.deployment_package.image_uri

  dynamic "image_config" {
    for_each = var.image_config != null ? [1] : []

    content {
      command           = var.image_config.command
      entry_point       = var.image_config.entry_point
      working_directory = var.image_config.working_directory
    }
  }

  # optional arguments
  architectures = var.architectures
  description   = var.description

  environment {
    variables = var.environment_variables
  }

  ephemeral_storage {
    size = var.ephemeral_storage_size
  }

  handler                        = var.handler
  layers                         = var.layers
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  tags                           = var.tags
  timeout                        = var.timeout

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [1] : []

    content {
      subnet_ids                  = var.vpc_config.subnet_ids
      security_group_ids          = var.vpc_config.security_group_ids
      ipv6_allowed_for_dual_stack = var.vpc_config.ipv6_allowed_for_dual_stack
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.logs
  ]
}

resource "aws_lambda_function" "lambda_with_lifecycle" {
  count         = var.ignore_deployment_package_changes ? 1 : 0
  function_name = var.function_name
  role          = var.execution_role_arn
  runtime       = var.runtime

  package_type      = var.deployment_package.image_uri == null ? "Zip" : "Image"
  filename          = var.deployment_package.filename
  source_code_hash  = var.deployment_package.source_code_hash
  s3_bucket         = var.deployment_package.s3_bucket
  s3_key            = var.deployment_package.s3_key
  s3_object_version = var.deployment_package.s3_object_version
  image_uri         = var.deployment_package.image_uri

  dynamic "image_config" {
    for_each = var.image_config != null ? [1] : []

    content {
      command           = var.image_config.command
      entry_point       = var.image_config.entry_point
      working_directory = var.image_config.working_directory
    }
  }

  # optional arguments
  architectures = var.architectures
  description   = var.description

  environment {
    variables = var.environment_variables
  }

  ephemeral_storage {
    size = var.ephemeral_storage_size
  }

  handler                        = var.handler
  layers                         = var.layers
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  tags                           = var.tags
  timeout                        = var.timeout

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [1] : []

    content {
      subnet_ids                  = var.vpc_config.subnet_ids
      security_group_ids          = var.vpc_config.security_group_ids
      ipv6_allowed_for_dual_stack = var.vpc_config.ipv6_allowed_for_dual_stack
    }
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      s3_bucket,
      s3_key,
      s3_object_version,
      image_uri
    ]
  }

  depends_on = [
    aws_cloudwatch_log_group.logs
  ]
}

resource "aws_lambda_alias" "aliases" {
  for_each = toset(var.aliases)

  name             = each.value
  function_name    = var.ignore_deployment_package_changes ? aws_lambda_function.lambda_with_lifecycle[0].function_name : aws_lambda_function.lambda[0].function_name
  function_version = var.ignore_deployment_package_changes ? aws_lambda_function.lambda_with_lifecycle[0].version : aws_lambda_function.lambda[0].version

  # Lifecycle to ignore change of function_version (Codedeploy)
  lifecycle {
    ignore_changes = [function_version, routing_config]
  }
}

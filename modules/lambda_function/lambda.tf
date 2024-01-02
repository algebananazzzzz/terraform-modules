data "archive_file" "zip_file" {
  count       = var.deployment_package.local_path != null ? 1 : 0
  type        = "zip"
  source_dir  = var.deployment_package.local_path
  output_path = "${path.root}/upload/${var.function_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  role          = module.lambda_execution_role.role_arn
  runtime       = var.runtime
  publish       = true

  filename         = var.deployment_package.local_path != null ? data.archive_file.zip_file[0].output_path : null
  source_code_hash = var.deployment_package.local_path != null ? data.archive_file.zip_file[0].output_base64sha256 : null

  s3_bucket         = var.deployment_package.s3_bucket
  s3_key            = var.deployment_package.s3_key
  s3_object_version = var.deployment_package.s3_object_version

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
    for_each = var.vpc_config != null ? { 1 : var.vpc_config } : {}

    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
      # ipv6_allowed_for_dual_stack = vpc_config.value.ipv6_allowed_for_dual_stack
    }
  }


  depends_on = [
    aws_s3_object.s3_deployment
  ]
}

resource "aws_lambda_alias" "aliases" {
  for_each = var.aliases

  name             = each.value.alias_name
  function_name    = aws_lambda_function.lambda.function_name
  function_version = aws_lambda_function.lambda.version

  description = each.value.description

  # To use CodeDeploy, ignore change of function_version
  lifecycle {
    ignore_changes = [function_version, routing_config]
  }
}

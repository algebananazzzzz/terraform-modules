# General Lambda + Apigw Configuration
locals {
  function_name                 = "${var.env}-app-func-simpleapi"
  deployment_package_local_path = "./build"
  environment_variables = {
    foo = "bar"
  }
  api_gateway_name = "${var.env}-web-apigw-simpleapi"
}

# Execution role config
locals {
  execution_role_name = "${var.env}-app-role-simpleapi"
  execution_role_policy_document = {
    name = "${var.env}-app-policy-simpleapi"
    statements = {
      allowCreateNetworkInterface = {
        effect = "Allow"
        actions = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ]
        resources = ["*"]
      }
    }
  }
}

module "lambda_function" {
  source        = "github.com/algebananazzzzz/terraform_modules/modules/lambda_function"
  function_name = local.function_name
  runtime       = "provided.al2"
  handler       = "bootstrap"

  # architectures                  = ["x86_64"]
  # description                    = "A simple function description"
  # environment_variables          = local.environment_variables
  # ephemeral_storage_size         = 512
  # layers                         = [""]
  # memory_size                    = 128
  # reserved_concurrent_executions = -1
  # timeout                        = 3

  execution_role_name            = local.execution_role_name
  execution_role_policy_document = local.execution_role_policy_document

  deployment_package = {
    local_path = local.deployment_package_local_path
  }

  vpc_config = {
    subnet_ids         = data.aws_subnets.private.ids
    security_group_ids = [data.aws_security_group.allow_nat.id]
  }

  tags = {
    Env = var.env
  }
}


module "api_lambda_integration" {
  source           = "github.com/algebananazzzzz/terraform_modules/modules/api_lambda_integration"
  api_gateway_name = local.api_gateway_name

  # `api_gateway_stage_name`: Name of default stage required to  deploy changes to api. We don't generally need to change this.
  # api_gateway_stage_name                   = "api"
  # api_gateway_stage_description            = ""
  #
  # api_gateway_disable_execute_api_endpoint = false
  # api_gateway_cors_configuration = {
  #   allow_credentials = true
  #   allow_headers     = ["Content-Type"]
  #   allow_origins     = ["*"]
  #   allow_methods     = ["GET", "POST"]
  #   expose_headers    = ["Content-Type"]
  #   max_age           = 6400
  # }

  lambda_integrations = {
    latest = {
      function_name   = module.lambda_function.function_name
      integration_uri = module.lambda_function.function_invoke_arn
      path            = "latest"

      # alias_name_or_version = ""
      # description           = ""
      # request_parameters = {
      #   "overwrite:header.Content-Type" = "application/json"
      # }
    }
  }
}

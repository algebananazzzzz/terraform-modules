# General Lambda + Apigw Configuration
locals {
  function_name                 = "${var.env}-app-func-multialiasapi"
  deployment_package_local_path = "./build"
  environment_variables = {
    foo = "bar"
  }
  api_gateway_name = "${var.env}-web-apigw-multialiasapi"
}

# Alias Configuration 
locals {
  aliases_config = {
    dev_alias = {
      alias_name = "DEV" # Name of alias in Lambda function
      path       = "dev" # Path of url to execute alias in apigw
      # request_parameters = {
      #   "overwrite:header.Content-Type" = "application/json"
      # }
    }
    prd_alias = {
      alias_name = "PRD" # Name of alias in Lambda function
      path       = "prd" # Path of url to execute alias in apigw
      # request_parameters = {
      #   "overwrite:header.Content-Type" = "application/json"
      # }
    }
  }
}

# Execution role config
locals {
  execution_role_name = "${var.env}-app-role-multialiasapi"
  execution_role_policy_document = {
    name = "${var.env}-app-policy-multialiasapi"
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

  aliases = {
    for key, value in local.aliases_config :
    key => {
      alias_name = value.alias_name
    }
  }
  # This block generates something like this:
  # {
  #   dev_alias = {
  #     alias_name = "DEV"
  #   }
  #   prd_alias = {
  #     alias_name = "PRD"
  #   }
  # }

  deployment_package = {
    local_path = local.deployment_package_local_path
  }

  vpc_config = {
    subnet_ids         = [data.aws_subnets.private.ids]
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
    for key, value in local.aliases_config :
    key => {
      function_name         = module.lambda_function.function_name
      alias_name_or_version = value.alias_name
      path                  = value.path
      integration_uri       = module.lambda_function.aliases_invoke_arn[key]
      request_parameters    = lookup(value, "request_parameters", null)
    }
  }
  # This block generates something like this:
  # lambda_integrations = {
  #   dev_alias = {
  #     function_name         = "dev-app-func-multialiasapi"
  #     alias_name_or_version = "DEV"
  #     path                  = "dev"
  #     integration_uri       = ""
  #     request_parameters = {
  #       "overwrite:header.Content-Type" = "application/json"
  #     }
  #   }
  #   prd_alias = {
  #     function_name         = "dev-app-func-multialiasapi"
  #     alias_name_or_version = "PRD"
  #     path                  = "prd"
  #     integration_uri       = ""
  #     request_parameters = {
  #       "overwrite:header.Content-Type" = "application/json"
  #     }
  #   }
  # }
}

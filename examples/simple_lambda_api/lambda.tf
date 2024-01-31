locals {
  function_name = "${var.env}-app-func-${var.project_code}"
  environment_variables = {
    REDIS_ADDR = "globalrediscache.internal.globalvpc:6379"
    REDIS_KEY  = "foo"
  }
  execution_role_name = "${var.env}-app-role-${var.project_code}"
  execution_role_policy_document = {
    name = "${var.env}-app-policy-${var.project_code}"
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
  source              = "github.com/algebananazzzzz/terraform_modules/modules/lambda_function"
  function_name       = "ExampleFunction"
  runtime             = "nodejs18.x"
  handler             = "index.js"
  execution_role_name = "ExampleFunctionExecutionRole"
  execution_role_policy_document = {
    name = "ExampleFunctionCustomPolicy"
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
  environment_variables = {
    foo = "bar"
  }
  vpc_config = {
    subnet_ids         = ["subnet-01234567890abcdef"]
    security_group_ids = ["sg-01234567890abcdef"]
  }
  deployment_package = {
    local_path = "./build"
  }
  aliases = {
    dev = {
      alias_name  = "dev"
      description = "Development alias"
    }
    prd = {
      alias_name  = "prd"
      description = "Production alias"
    }
  }

}

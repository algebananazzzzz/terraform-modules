module "lambda_function" {
  source              = "./modules/lambda_function"
  function_name       = "TestLambdaFunction"
  runtime             = "provided.al2"
  handler             = "bootstrap"
  execution_role_name = "TestLambdaFunctionExecutionRole"
  deployment_package = {
    local_path = "./src/build"
  }
}

module "api_lambda_integration" {
  source           = "./modules/api_lambda_integration"
  api_gateway_name = "TestApiGateway"
  lambda_integrations = {
    lambda = {
      function_name   = module.lambda_function.function_name
      path            = "latest"
      integration_uri = module.lambda_function.function_invoke_arn
    }
  }
}

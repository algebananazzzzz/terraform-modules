output "api_gateway_endpoint" {
  value = module.api_lambda_integration.api_endpoint
}

output "function_name" {
  value = module.lambda_function.function_name
}

output "function_latest_version" {
  value = module.lambda_function.function_version
}

output "aliases_current_version" {
  value = module.lambda_function.aliases_version
}

output "codedeploy_app_name" {
  value = module.lambda_codedeploy_resources.codedeploy_app_name
}

output "codedeploy_deployment_group_name" {
  value = module.lambda_codedeploy_resources.codedeploy_deployment_group_name
}

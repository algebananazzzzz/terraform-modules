output "integration" {
  description = "An object representing the created `aws_apigatewayv2_integration` resource."
  value       = aws_apigatewayv2_integration.api_integration
}

output "route" {
  description = "An object representing the created `aws_apigatewayv2_route` resource."
  value       = aws_apigatewayv2_route.api_integration
}

output "lambda_permission" {
  description = "An object representing the created `aws_lambda_permission` resource."
  value       = aws_lambda_permission.api_gw
}

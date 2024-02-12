output "api" {
  description = "An object representing the created `aws_apigatewayv2_api` resource."
  value       = aws_apigatewayv2_api.api_gateway
}

output "stage" {
  description = "An object representing the created default `aws_apigatewayv2_stage` resource."
  value       = aws_apigatewayv2_stage.default_stage
}

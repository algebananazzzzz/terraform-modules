output "api_integration" {
  value = aws_apigatewayv2_integration.api_integration
}

output "api_route" {
  value = aws_apigatewayv2_route.api_integration
}

output "lambda_permission" {
  value = aws_lambda_permission.api_gw
}

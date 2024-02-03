resource "aws_apigatewayv2_integration" "api_integration" {
  api_id      = var.api_gateway_id
  description = var.integration_description

  integration_method = "POST"
  integration_uri    = var.function_integration_uri
  integration_type   = "AWS_PROXY"
}

resource "aws_apigatewayv2_route" "api_integration" {
  api_id = var.api_gateway_id

  route_key = "ANY /${var.integration_path}"
  target    = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
}

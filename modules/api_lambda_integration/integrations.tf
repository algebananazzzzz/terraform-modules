resource "aws_apigatewayv2_integration" "api_integration" {
  for_each = var.lambda_integrations
  api_id   = aws_apigatewayv2_api.api_gateway.id

  integration_uri  = each.value.integration_uri
  integration_type = "AWS_PROXY"

  request_parameters = each.value.request_parameters
}

resource "aws_apigatewayv2_route" "api_integration" {
  for_each = var.lambda_integrations
  api_id   = aws_apigatewayv2_api.api_gateway.id

  route_key = "ANY /${each.value.path}"
  target    = "integrations/${aws_apigatewayv2_integration.api_integration[each.key].id}"
}

resource "aws_lambda_permission" "api_gw" {
  for_each      = var.lambda_integrations
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  qualifier     = each.value.alias_name_or_version
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

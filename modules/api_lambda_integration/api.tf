resource "aws_apigatewayv2_api" "api_gateway" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"

  description                  = var.api_gateway_description
  disable_execute_api_endpoint = var.api_gateway_disable_execute_api_endpoint
  tags                         = var.api_gateway_tags

  dynamic "cors_configuration" {
    for_each = var.api_gateway_cors_configuration != null ? { 1 : var.api_gateway_cors_configuration } : {}

    content {
      allow_credentials = cors_configuration.value.allow_credentials
      allow_origins     = cors_configuration.value.allow_origins
      allow_methods     = cors_configuration.value.allow_methods
      allow_headers     = cors_configuration.value.allow_headers
      max_age           = cors_configuration.value.max_age
      expose_headers    = cors_configuration.value.expose_headers
    }
  }
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = var.api_gateway_stage_name
  auto_deploy = true

  description = var.api_gateway_stage_description
  #   access_log_settings {
  #     destination_arn = aws_cloudwatch_log_group.api_gw.arn

  #     format = jsonencode({
  #       requestId               = "$context.requestId"
  #       sourceIp                = "$context.identity.sourceIp"
  #       requestTime             = "$context.requestTime"
  #       protocol                = "$context.protocol"
  #       httpMethod              = "$context.httpMethod"
  #       resourcePath            = "$context.resourcePath"
  #       routeKey                = "$context.routeKey"
  #       status                  = "$context.status"
  #       responseLength          = "$context.responseLength"
  #       integrationErrorMessage = "$context.integrationErrorMessage"
  #       }
  #     )
  #   }
}

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

  route_key = "ANY /${each.value.path}/{proxy+}"
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

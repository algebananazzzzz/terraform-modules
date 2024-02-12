resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = var.default_stage_auto_deploy

  description = var.default_stage_description
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
  tags = var.tags
}

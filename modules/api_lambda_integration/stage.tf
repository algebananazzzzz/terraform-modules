resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = var.stage_name
  auto_deploy = true

  description = var.stage_description
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

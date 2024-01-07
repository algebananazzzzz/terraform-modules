resource "aws_apigatewayv2_stage" "stage" {
  for_each    = var.stage_configuration
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = each.value.api_gateway_stage_name
  auto_deploy = true

  description = each.value.api_gateway_stage_description
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

output "api_gateway_arn" {
  value = aws_apigatewayv2_api.api_gateway.arn
}

output "api_gateway_id" {
  value = aws_apigatewayv2_api.api_gateway.id
}

output "api_gateway_name" {
  value = aws_apigatewayv2_api.api_gateway.name
}

output "api_endpoint" {
  value = aws_apigatewayv2_stage.stage.invoke_url
}

output "stage_ids" {
  value = {
    for key, value in aws_apigatewayv2_stage.stage :
    key => value.id
  }
}

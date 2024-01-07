resource "aws_apigatewayv2_domain_name" "domain" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.regional_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}


resource "aws_apigatewayv2_api_mapping" "example" {
  for_each    = var.api_mappings
  api_id      = each.value.api_id
  domain_name = aws_apigatewayv2_domain_name.domain.id
  stage       = each.value.stage_id
}

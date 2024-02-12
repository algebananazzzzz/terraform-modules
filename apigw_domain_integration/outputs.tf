output "api_mapping" {
  value = aws_apigatewayv2_api_mapping.mapping
}

output "apigw_domain_name" {
  value = aws_apigatewayv2_domain_name.domain
}

output "route53_record" {
  value = aws_route53_record.record
}


output "api_mapping" {
  description = "An object representing the created default `aws_apigatewayv2_api_mapping` resource."
  value       = aws_apigatewayv2_api_mapping.mapping
}

output "api_domain_name" {
  description = "An object representing the created default `aws_apigatewayv2_domain_name` resource."
  value       = aws_apigatewayv2_domain_name.domain
}

output "record" {
  description = "An object representing the created `aws_route53_record` resource."
  value       = aws_route53_record.record
}

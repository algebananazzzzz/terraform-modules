resource "aws_apigatewayv2_domain_name" "domain" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn                        = var.regional_certificate_arn
    endpoint_type                          = "REGIONAL"
    security_policy                        = "TLS_1_2"
    ownership_verification_certificate_arn = var.ownership_verification_certificate_arn
  }

  dynamic "mutual_tls_authentication" {
    for_each = var.mutual_tls_authentication != null ? [1] : []

    content {
      truststore_uri     = var.mutual_tls_authentication.truststore_uri
      truststore_version = var.mutual_tls_authentication.truststore_version
    }
  }
  tags = var.tags
}


resource "aws_apigatewayv2_api_mapping" "mapping" {
  api_id      = var.apigw_api_id
  domain_name = aws_apigatewayv2_domain_name.domain.id
  stage       = var.apigw_stage_id
  depends_on  = [aws_route53_record.record]
}

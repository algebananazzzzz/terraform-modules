resource "aws_route53_record" "record" {

  name    = aws_apigatewayv2_domain_name.domain.domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_apigatewayv2_domain_name.domain]
}

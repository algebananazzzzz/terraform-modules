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

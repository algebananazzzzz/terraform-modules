resource "aws_apigatewayv2_api" "api_gateway" {
  name          = var.name
  protocol_type = "HTTP"

  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  tags                         = var.tags

  dynamic "cors_configuration" {
    for_each = var.cors_configuration != null ? { 1 : var.cors_configuration } : {}

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

resource "aws_apigatewayv2_api" "api_gateway" {
  name = var.name

  protocol_type                = var.protocol_type
  api_key_selection_expression = var.api_key_selection_expression
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  route_selection_expression   = var.route_selection_expression

  dynamic "cors_configuration" {
    for_each = var.cors_configuration != null ? [1] : []

    content {
      allow_credentials = var.cors_configuration.allow_credentials
      allow_origins     = var.cors_configuration.allow_origins
      allow_methods     = var.cors_configuration.allow_methods
      allow_headers     = var.cors_configuration.allow_headers
      max_age           = var.cors_configuration.max_age
      expose_headers    = var.cors_configuration.expose_headers
    }
  }

  tags = var.tags
}

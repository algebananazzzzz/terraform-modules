output "api_gateway_endpoint" {
  value = format("%s/latest/", module.api_lambda_integration.api_endpoints["latest"])
}

output "custom_domain_endpoint" {
  value = "${local.domain_name}/latest/"
}

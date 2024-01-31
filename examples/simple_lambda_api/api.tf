locals {
  domain_name                 = "${var.project_code}.algebananazzzzz.com"
  regional_certificate_domain = "*.algebananazzzzz.com"
  route53_zone_name           = "algebananazzzzz.com"
  api_gateway_name            = "${var.env}-web-apigw-${var.project_code}"
}

data "aws_acm_certificate" "issued" {
  domain      = local.regional_certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "zone" {
  name         = local.route53_zone_name
  private_zone = false
}

module "api_lambda_integration" {
  source                                   = "github.com/algebananazzzzz/terraform_modules/modules/api_lambda_integration"
  api_gateway_name                         = ""
  api_gateway_disable_execute_api_endpoint = true
  lambda_integrations = {
    latest = {
      function_name   = module.lambda_function.function_name
      path            = "latest"
      integration_uri = module.lambda_function.function_invoke_arn
    }
  }
  stage_configuration = {
    latest = {
      api_gateway_stage_name        = "latest"
      api_gateway_stage_description = "Default stage"
    }
  }
}

module "api_domain_integration" {
  source                   = "github.com/algebananazzzzz/terraform_modules/modules/api_domain_integration"
  domain_name              = local.domain_name
  regional_certificate_arn = data.aws_acm_certificate.issued.arn
  route53_zone_id          = data.aws_route53_zone.zone.id
  api_mappings = {
    latest = {
      api_id   = module.api_lambda_integration.api_gateway_id
      stage_id = module.api_lambda_integration.stage_ids["latest"]
    }
  }
}

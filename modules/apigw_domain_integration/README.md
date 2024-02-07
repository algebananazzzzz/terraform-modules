# Apigw Domain Integration module

## Full Configuration Example
```hcl
module "domain_integration" {
  source                   = "./modules/apigw-domain-integration"
  apigw_api_id             = module.api.apigw.id
  apigw_stage_id           = module.api.default_stage.id
  domain_name              = "test.example.com"
  regional_certificate_arn = "arn:aws:acm:region:account:certificate/certificate_ID"
  zone_id                  = "Z123456789"

  # Optional variables
  ownership_verification_certificate_arn = ""
  mutual_tls_authentication = {
    truststore_uri     = ""
    truststore_version = ""
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api_mapping.mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_domain_name.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apigw_api_id"></a> [apigw\_api\_id](#input\_apigw\_api\_id) | Identifier for the API which stage belongs to. | `string` | n/a | yes |
| <a name="input_apigw_stage_id"></a> [apigw\_stage\_id](#input\_apigw\_stage\_id) | Identifier for the stage to map domain name to. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Custom Domain name which is a subdomain to the domain of the hosted zone provided in `zone_id`. | `string` | n/a | yes |
| <a name="input_regional_certificate_arn"></a> [regional\_certificate\_arn](#input\_regional\_certificate\_arn) | ARN of an AWS-managed certificate that will be used by the endpoint for the domain name. | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 hosted zone id to create a record for your provided domain name. | `string` | n/a | yes |
| <a name="input_mutual_tls_authentication"></a> [mutual\_tls\_authentication](#input\_mutual\_tls\_authentication) | Mutual TLS authentication configuration for the domain name. | <pre>object({<br>    truststore_uri     = string<br>    truststore_version = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_ownership_verification_certificate_arn"></a> [ownership\_verification\_certificate\_arn](#input\_ownership\_verification\_certificate\_arn) | ARN of the AWS-issued certificate used to validate custom domain ownership. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to apigw domain name resource. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_mapping"></a> [api\_mapping](#output\_api\_mapping) | n/a |
| <a name="output_apigw_domain_name"></a> [apigw\_domain\_name](#output\_apigw\_domain\_name) | n/a |
| <a name="output_route53_record"></a> [route53\_record](#output\_route53\_record) | n/a |
<!-- END_TF_DOCS -->
# Apigw Domain Integration module

## Full Configuration Example
```terraform
module "lambda_integration" {
  source                    = "github.com/algebananazzzzz/terraform-modules/apigw-lambda-integration"
  api_gateway_id            = module.apigw.api.id
  api_gateway_execution_arn = module.apigw.api.execution_arn
  function_name             = module.lambda_function.function.function_name
  function_invoke_arn       = module.lambda_function.function.invoke_arn

  # Optional variables with examples
  function_alias_or_version = "dev"
  integration_description   = ""
  integration_path          = "api"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.57.0 |

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_integration.api_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.api_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_lambda_permission.api_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_gateway_execution_arn"></a> [api\_gateway\_execution\_arn](#input\_api\_gateway\_execution\_arn) | Execution arn of the API. | `string` | n/a | yes |
| <a name="input_api_gateway_id"></a> [api\_gateway\_id](#input\_api\_gateway\_id) | Identifier for the API. | `string` | n/a | yes |
| <a name="input_function_invoke_arn"></a> [function\_invoke\_arn](#input\_function\_invoke\_arn) | URI of the Lambda function for the Lambda proxy integration. | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Lambda function. | `string` | n/a | yes |
| <a name="input_function_alias_or_version"></a> [function\_alias\_or\_version](#input\_function\_alias\_or\_version) | Query parameter to specify function version or alias name. | `string` | `null` | no |
| <a name="input_integration_description"></a> [integration\_description](#input\_integration\_description) | Description of the Lambda integration. | `string` | `null` | no |
| <a name="input_integration_path"></a> [integration\_path](#input\_integration\_path) | Resource path for the Lambda integration e.g. api. Defaults to proxy+. | `string` | `"{proxy+}"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_integration"></a> [integration](#output\_integration) | An object representing the created `aws_apigatewayv2_integration` resource. |
| <a name="output_lambda_permission"></a> [lambda\_permission](#output\_lambda\_permission) | An object representing the created `aws_lambda_permission` resource. |
| <a name="output_route"></a> [route](#output\_route) | An object representing the created `aws_apigatewayv2_route` resource. |
<!-- END_TF_DOCS -->
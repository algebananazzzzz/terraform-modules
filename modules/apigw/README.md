# Apigw module

## Basic Example
```hcl
module "api" {
  source = "./modules/apigw"
  name   = "dev-web-apigw-example"
}
```

## Full Configuration Example 
```hcl
module "api" {
  source = "./modules/apigw"
  name   = "dev-web-apigw-example"

  # Optional variables for default stage
  default_stage_auto_deploy = true
  default_stage_description = ""

  # Optional variables with examples
  api_key_selection_expression = "$request.header.x-api-key"
  cors_configuration = {
    allow_credentials = true
    allow_headers     = ["*"]
    allow_origins     = ["*"]
    allow_methods     = ["POST", "GET"]
    expose_headers    = ["*"]
    max_age           = 3600
  }
  description                  = ""
  disable_execute_api_endpoint = false
  route_selection_expression   = "$request.method $request.path"
  protocol_type                = "HTTP"
}
```

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_stage.default_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the API. Must be less than or equal to 128 characters in length. | `string` | n/a | yes |
| <a name="input_api_key_selection_expression"></a> [api\_key\_selection\_expression](#input\_api\_key\_selection\_expression) | An API key selection expression. Valid values: $request.header.x-api-key (default), $context.authorizer.usageIdentifierKey (applicable for WebSocket APIs). | `string` | `"$request.header.x-api-key"` | no |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | Cross-origin resource sharing (CORS) configuration. Applicable for HTTP APIs. | <pre>object({<br>    allow_credentials = optional(bool)<br>    allow_headers     = optional(list(string))<br>    allow_origins     = optional(list(string))<br>    allow_methods     = optional(list(string))<br>    expose_headers    = optional(list(string))<br>    max_age           = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_default_stage_auto_deploy"></a> [default\_stage\_auto\_deploy](#input\_default\_stage\_auto\_deploy) | Whether updates to an API automatically trigger a new deployment for the default stage. | `bool` | `true` | no |
| <a name="input_default_stage_description"></a> [default\_stage\_description](#input\_default\_stage\_description) | Description for the default stage. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the API. | `string` | `null` | no |
| <a name="input_disable_execute_api_endpoint"></a> [disable\_execute\_api\_endpoint](#input\_disable\_execute\_api\_endpoint) | Whether clients can invoke the API by using the default execute-api endpoint. To require that clients use a custom domain name to invoke the API, set this to true. | `bool` | `false` | no |
| <a name="input_protocol_type"></a> [protocol\_type](#input\_protocol\_type) | API protocol. Valid values: HTTP, WEBSOCKET. | `string` | `"HTTP"` | no |
| <a name="input_route_selection_expression"></a> [route\_selection\_expression](#input\_route\_selection\_expression) | The route selection expression for the API. Applicable for WebSocket APIs. | `string` | `"$request.method $request.path"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the API. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apigw"></a> [apigw](#output\_apigw) | n/a |
<!-- END_TF_DOCS -->
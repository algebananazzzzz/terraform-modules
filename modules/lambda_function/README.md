<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_alias.aliases](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.lambda_with_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_package"></a> [deployment\_package](#input\_deployment\_package) | Configuration for the deployment package. One of `filename, image_uri, s3_bucket` must be specified. | <pre>object({<br>    filename          = optional(string)<br>    source_code_hash  = optional(string)<br>    image_uri         = optional(string)<br>    s3_bucket         = optional(string)<br>    s3_key            = optional(string)<br>    s3_object_version = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | Arn of the IAM execution role for the Lambda function. | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Unique name for your Lambda Function. Must follow naming convention. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the Lambda function. | `any` | n/a | yes |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | List of names of aliases to be created for the function. | `list(string)` | `[]` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture for your Lambda function. Valid values are ["x86\_64"] and ["arm64"]. | `list(string)` | <pre>[<br>  "x86_64"<br>]</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what your Lambda Function does. | `string` | `null` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Map of environment variables that are accessible from the function code during execution. At least one key must be present. | `map(string)` | `null` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | The size of the Lambda function Ephemeral storage (/tmp) represented in MB. Maximum supported value of 10240. | `number` | `512` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Function entrypoint in your code. Required if the deployment package type is `filename` or `s3` | `string` | `null` | no |
| <a name="input_ignore_deployment_package_changes"></a> [ignore\_deployment\_package\_changes](#input\_ignore\_deployment\_package\_changes) | Boolean controlling whether lifecycle should ignore changes to deployment package (local files/s3/image uri). | `bool` | `false` | no |
| <a name="input_image_config"></a> [image\_config](#input\_image\_config) | Container image configuration values that override the values in the container image Dockerfile. | <pre>object({<br>    command           = optional(list(string))<br>    entry_point       = optional(list(string))<br>    working_directory = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. | `list(string)` | `[]` | no |
| <a name="input_logs_retention_in_days"></a> [logs\_retention\_in\_days](#input\_logs\_retention\_in\_days) | Specifies the number of days you want to retain log events in the Lambda log group. | `number` | `30` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. | `number` | `128` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Amount of reserved concurrent executions. Value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. | `number` | `-1` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Identifier of the function's runtime. Required if the deployment package type is `filename` or `s3` | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Amount of time your Lambda Function can run in seconds before returning a TaskTimeout error. | `number` | `3` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration specifying a list of security groups and subnets in the VPC. | <pre>object({<br>    subnet_ids                  = list(string)<br>    security_group_ids          = list(string)<br>    ipv6_allowed_for_dual_stack = optional(bool)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#output\_cloudwatch\_log\_group) | n/a |
| <a name="output_function"></a> [function](#output\_function) | n/a |
| <a name="output_function_aliases"></a> [function\_aliases](#output\_function\_aliases) | n/a |
<!-- END_TF_DOCS -->
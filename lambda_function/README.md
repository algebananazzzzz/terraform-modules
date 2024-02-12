# Lambda Function Module

## Basic Example 
```terraform 
module "lambda_function" {
  source             = "github.com/algebananazzzzz/terraform-modules/lambda-function"
  function_name      = "dev-app-lambdafn-example"
  execution_role_arn = "arn:aws:role:us-east-1:123456789012:my-role"
  
  # Example deployment package using local files
  deployment_package = {
    filename         = data.archive_file.zip_file.output_path
    source_code_hash = data.archive_file.zip_file.output_base64sha256
  }
}

data "archive_file" "zip_file" {
  type        = "zip"
  source_dir  = local.deployment_package_location
  output_path = "${path.root}/upload/${local.function_name}.zip"
}
```

## Full Configuration Example 
```terraform
module "lambda_function" {
  source             = "github.com/algebananazzzzz/terraform-modules/lambda-function"
  function_name      = "dev-app-lambdafn-example"
  env                = "prd"
  execution_role_arn = "arn:aws:role:us-east-1:123456789012:my-role"

  # Example deployment package using local files
  deployment_package = {
    filename         = data.archive_file.zip_file.output_path
    source_code_hash = data.archive_file.zip_file.output_base64sha256
  }
  
  # Example deployment package using an existing image in aws ecr
  # deployment_package = {
  #  image_uri = "aws_account_id.dkr.ecr.us-west-2.amazonaws.com/repo:tag"
  # }

  # Example deployment package using a zip file in an s3 location
  # deployment_package = {
  #  s3_bucket         = "my-bucket"
  #  s3_key            = "deployment.zip"
  #  s3_object_version = "2"
  # }

  # Optional variables with examples
  aliases       = ["dev", "prd"]
  architectures = ["x86_64"]
  description   = "Some description"
  environment_variables = {
    foo = "bar"
  }
  ephemeral_storage_size = 512
  handler                           = "bootstrap"
  ignore_deployment_package_changes = false
  image_config = {
    command           = ["--argument"]
    entry_point       = ["/go/bin/app"]
    working_directory = "/go/src/app"
  }
  layers                         = ["arn:aws:lambda:us-east-1:123456789012:layer:my-layer"]
  logs_retention_in_days         = 30
  memory_size                    = 128
  reserved_concurrent_executions = -1
  runtime                        = "provided.al2023"
  timeout                        = 3
  vpc_config = {
    subnet_ids                  = ["subnet-123456789", "subnet-234567891"]
    security_group_ids          = ["sg-123456789", "sg-234567891"]
    ipv6_allowed_for_dual_stack = false
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.57.0 |

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
| <a name="output_function"></a> [function](#output\_function) | Object representing the created `aws_lambda_function` resource. |
| <a name="output_function_aliases"></a> [function\_aliases](#output\_function\_aliases) | Map of object representing the created `aws_lambda_alias` resources. |
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | Object representing the created `aws_cloudwatch_log_group` resource. |
<!-- END_TF_DOCS -->
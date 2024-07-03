# IAM Role Module

## Basic Example 
```terraform 
module "lambda_execution_role" {
  source = "github.com/algebananazzzzz/terraform-modules/iam_role"
  name = "mgmt-na-iamrole-example"

  # Optional variables with examples
  custom_policy = {
    name = "iam-policy-wogaa-prdmzna-custompolicy"
    statements = {
      networkInterfacePermissions = {
        effect = "Allow"
        actions = [
          "ec2:CreateNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
        ]
        resources = ["*"]
      }
    }
  }
}
```

## Full Configuration Example 
```terraform
module "lambda_execution_role" {
  source = "github.com/algebananazzzzz/terraform-modules/iam_role"
  name = "mgmt-na-iamrole-example"

  # Optional variables with examples
  policy_attachments = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  assume_role_allowed_principals = [{
    type        = "Service"
    identifiers = ["lambda.amazonaws.com"]
  }]
  custom_policy = {
    name = "iam-policy-wogaa-prdmzna-custompolicy"
    statements = {
      networkInterfacePermissions = {
        effect = "Allow"
        actions = [
          "ec2:CreateNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
        ]
        resources = ["*"]
      }
    }
  }
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
| [aws_iam_policy.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.policy_attachments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Friendly name for the IAM role | `string` | n/a | yes |
| <a name="input_assume_role_allowed_principals"></a> [assume\_role\_allowed\_principals](#input\_assume\_role\_allowed\_principals) | Allowed principals for an assume role policy to assume the role. Defaults to a Lambda Service example. | <pre>list(object({<br>    type        = string<br>    identifiers = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "identifiers": [<br>      "lambda.amazonaws.com"<br>    ],<br>    "type": "Service"<br>  }<br>]</pre> | no |
| <a name="input_custom_policy"></a> [custom\_policy](#input\_custom\_policy) | Configuration for creating a new custom policy to be attached to the role. | <pre>object({<br>    name        = string<br>    description = optional(string)<br>    statements = map(object({<br>      effect    = string<br>      actions   = list(string)<br>      resources = list(string)<br>      conditions = optional(list(object({<br>        condition_operator = string<br>        condition_key      = string<br>        condition_values   = list(string)<br>      })))<br>    }))<br>    tags = optional(map(string))<br>  })</pre> | `null` | no |
| <a name="input_policy_attachments"></a> [policy\_attachments](#input\_policy\_attachments) | List of Arns for policies to be attached to the role. The policies must be managed outside this module. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the role and custom policy. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_policy"></a> [custom\_policy](#output\_custom\_policy) | Object representing the created custom `aws_iam_policy` resource. Returns null if `custom_policy` is not set. |
| <a name="output_json"></a> [json](#output\_json) | String representing the `json` document of the policy specified for the created custom `aws_iam_policy` resource. Returns null if `custom_policy` is not set. |
| <a name="output_role"></a> [role](#output\_role) | Object representing the created `aws_iam_role` resource. |
<!-- END_TF_DOCS -->
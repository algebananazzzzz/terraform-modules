<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.policy_attachments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Friendly name for the IAM role | `string` | n/a | yes |
| <a name="input_additional_policy_attachments"></a> [additional\_policy\_attachments](#input\_additional\_policy\_attachments) | List of Arns for policies to be attached to the role. The policies must be managed outside this module. | `list(string)` | `[]` | no |
| <a name="input_assume_role_allowed_principals"></a> [assume\_role\_allowed\_principals](#input\_assume\_role\_allowed\_principals) | Allowed principals for an assume role policy to assume the role. Defaults to a Lambda Service example. | <pre>list(object({<br>    type        = string<br>    identifiers = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "identifiers": [<br>      "lambda.amazonaws.com"<br>    ],<br>    "type": "Service"<br>  }<br>]</pre> | no |
| <a name="input_custom_policy"></a> [custom\_policy](#input\_custom\_policy) | Configuration for creating a new custom policy to be attached to the role. | <pre>object({<br>    name        = string<br>    description = optional(string)<br>    statements = map(object({<br>      effect    = string<br>      actions   = list(string)<br>      resources = list(string)<br>      conditions = optional(list(object({<br>        condition_operator = string<br>        condition_key      = string<br>        condition_value    = string<br>      })))<br>    }))<br>    tags = optional(map(string))<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the role and custom policy. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_created_custom_policy"></a> [created\_custom\_policy](#output\_created\_custom\_policy) | n/a |
| <a name="output_role"></a> [role](#output\_role) | n/a |
<!-- END_TF_DOCS -->
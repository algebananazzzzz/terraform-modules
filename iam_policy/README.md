# IAM Policy Module

## Full Configuration Example 
```hcl
module "policy" {
  source = "github.com/algebananazzzzz/terraform-modules/iam_policy"
  name = "mgmt-na-iampolicy-example"

  # Optional variables with examples
  description = ""
  version = "2012-10-17"
  document_statements = {
    networkInterfacePermissions = {
        effect = "Allow"
        actions = [
          "ec2:CreateNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
        ]
        resources = ["*"]
        conditions = [
            {
                condition_operator = "ArnLike"
                condition_key = "aws:SourceArn"
                condition_value = "arn:aws:cloudtrail:*:111122223333:trail/*"
            }
        ]
      }
    }
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.57.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_document_statements"></a> [document\_statements](#input\_document\_statements) | Configuration block for a policy statement | <pre>map(object({<br>    effect    = string<br>    actions   = list(string)<br>    resources = list(string)<br>    conditions = optional(list(object({<br>      condition_operator = string<br>      condition_key      = string<br>      condition_value    = string<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the IAM policy | `string` | `null` | no |
| <a name="input_document_version"></a> [document\_version](#input\_document\_version) | IAM policy document version | `string` | `"2012-10-17"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the policy. If omitted, Terraform will assign a random, unique name | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of resource tags for the IAM Policy | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_json"></a> [json](#output\_json) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->
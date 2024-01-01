data "aws_iam_policy_document" "policy" {
  policy_id = var.policy_document_id
  version   = var.policy_document_version

  dynamic "statement" {
    for_each = var.policy_document_statements

    content {
      sid       = statement.key
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = statement.value.conditions != null ? statement.value.conditions : {}

        content {
          test     = condition.key
          variable = condition.value["context_variable"]
          values   = condition.value["values"]
        }
      }
    }
  }
}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  name_prefix = var.policy_name_prefix
  path        = var.policy_path
  description = var.policy_description
  tags        = var.policy_tags

  policy = data.aws_iam_policy_document.policy.json
}

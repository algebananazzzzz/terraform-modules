data "aws_iam_document" "policy" {
  version = var.document_version

  dynamic "statement" {
    for_each = var.document_statements

    content {
      sid       = statement.key
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = statement.value.conditions != null ? statement.value.conditions : []
        content {
          test     = condition.value.condition_operator
          variable = condition.value.condition_key
          values   = condition.value.condition_value
        }
      }
    }
  }
}

resource "aws_iam_policy" "policy" {
  name        = var.name
  description = var.description
  tags        = var.tags

  policy = data.aws_iam_document.policy.json
}

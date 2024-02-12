data "aws_iam_policy_document" "custom_policy" {
  count = var.custom_policy != null ? 1 : 0

  dynamic "statement" {
    for_each = var.custom_policy.statements

    content {
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

resource "aws_iam_policy" "custom_policy" {
  count       = var.custom_policy != null ? 1 : 0
  name        = var.custom_policy.name
  description = var.custom_policy.description

  policy = data.aws_iam_policy_document.custom_policy[0].json

  tags = merge({
    Name = var.custom_policy.name
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "custom_policy" {
  count      = var.custom_policy != null ? 1 : 0
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.custom_policy[0].arn
}

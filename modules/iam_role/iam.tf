
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    dynamic "principals" {
      for_each = var.assume_role_policy

      content {
        type        = principals.key
        identifiers = principals.value
      }
    }

    actions = ["sts:AssumeRole"]
  }
}

module "iam_policy" {
  count       = var.policy_document != null ? 1 : 0
  source      = "../iam_policy"
  name        = var.policy_document.name
  description = var.policy_document.description
  tags        = var.policy_document.tags

  document_id         = var.policy_document.id
  document_version    = var.policy_document.version
  document_statements = var.policy_document.statements
}

resource "aws_iam_role" "role" {
  name                 = var.name
  description          = var.description
  permissions_boundary = var.permissions_boundary
  max_session_duration = var.max_session_duration
  tags                 = var.tags

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "role-attachment" {
  count      = var.policy_document != null ? 1 : 0
  role       = aws_iam_role.role.name
  policy_arn = module.iam_policy[0].arn
}

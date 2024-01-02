
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
  count              = var.policy_document != null ? 1 : 0
  source             = "../iam_policy"
  policy_name        = var.policy_document.name
  policy_description = var.policy_document.description
  policy_tags        = var.policy_document.tags

  policy_document_id         = var.policy_document.id
  policy_document_version    = var.policy_document.version
  policy_document_statements = var.policy_document.statements
}

resource "aws_iam_role" "role" {
  name                 = var.role_name
  description          = var.role_description
  permissions_boundary = var.role_permissions_boundary
  max_session_duration = var.role_max_session_duration
  tags                 = var.role_tags

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  for_each   = toset(var.role_managed_policy_arns)
  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "role-attachment" {
  count      = var.policy_document != null ? 1 : 0
  role       = aws_iam_role.role.name
  policy_arn = module.iam_policy[0].arn
}

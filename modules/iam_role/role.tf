data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    dynamic "principals" {
      for_each = var.assume_role_allowed_principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name = var.name

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge({
    Name = var.name
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  for_each   = toset(var.policy_attachments)
  role       = aws_iam_role.role.name
  policy_arn = each.value
}

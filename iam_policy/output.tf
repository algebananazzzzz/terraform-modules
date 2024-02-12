output "id" {
  value = aws_iam_policy.policy.policy_id
}

output "arn" {
  value = aws_iam_policy.policy.arn
}

output "name" {
  value = aws_iam_policy.policy.name
}

output "json" {
  value = data.aws_iam_policy_document.policy.json
}

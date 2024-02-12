output "id" {
  description = "String representing the `id` of the created `aws_iam_policy` resource."
  value       = aws_iam_policy.policy.policy_id
}

output "arn" {
  description = "String representing the `arn` of the created `aws_iam_policy` resource."
  value       = aws_iam_policy.policy.arn
}

output "name" {
  description = "String representing the `name` of the created `aws_iam_policy` resource."
  value       = aws_iam_policy.policy.name
}

output "json" {
  description = "String representing the `json` document of the policy specified for the created `aws_iam_policy` resource."
  value       = data.aws_iam_policy_document.policy.json
}

output "role" {
  description = "Object representing the created `aws_iam_role` resource."
  value       = aws_iam_role.role
}

output "custom_policy" {
  description = "Object representing the created custom `aws_iam_policy` resource. Returns null if `custom_policy` is not set."
  value       = local.create_custom_policy ? aws_iam_policy.custom : null
}

output "json" {
  description = "String representing the `json` document of the policy specified for the created custom `aws_iam_policy` resource. Returns null if `custom_policy` is not set."
  value       = local.create_custom_policy ? data.aws_iam_policy_document.custom.json : null
}

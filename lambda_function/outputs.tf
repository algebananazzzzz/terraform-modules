output "log_group" {
  description = "Object representing the created `aws_cloudwatch_log_group` resource."
  value       = aws_cloudwatch_log_group.logs
}

output "function" {
  description = "Object representing the created `aws_lambda_function` resource."
  value       = var.ignore_deployment_package_changes ? aws_lambda_function.lambda_with_lifecycle[0] : aws_lambda_function.lambda[0]
}

output "function_aliases" {
  description = "Map of object representing the created `aws_lambda_alias` resources."
  value = {
    for key, alias in aws_lambda_alias.aliases :
    key => alias
  }
}

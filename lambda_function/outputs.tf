output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.logs
}

output "function" {
  value = var.ignore_deployment_package_changes ? aws_lambda_function.lambda_with_lifecycle[0] : aws_lambda_function.lambda[0]
}

output "function_aliases" {
  value = {
    for key, alias in aws_lambda_alias.aliases :
    key => alias
  }
}

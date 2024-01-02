output "execution_role_arn" {
  value = module.lambda_execution_role.role_arn
}

output "execution_role_name" {
  value = module.lambda_execution_role.role_name
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "function_invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "function_version" {
  value = aws_lambda_function.lambda.version
}

output "aliases_name" {
  value = {
    for key, alias in aws_lambda_alias.aliases :
    key => alias.name
  }
}

output "aliases_version" {
  value = {
    for key, alias in aws_lambda_alias.aliases :
    key => alias.function_version
  }
}

output "aliases_arn" {
  value = {
    for key, alias in aws_lambda_alias.aliases :
    key => alias.arn
  }
}

output "aliases_invoke_arn" {
  value = {
    for key, alias in aws_lambda_alias.aliases :
    key => alias.invoke_arn
  }
}

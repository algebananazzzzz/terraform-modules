output "codedeploy_app_arn" {
  value = aws_codedeploy_app.deploy.arn
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.deploy.name
}

output "codedeploy_app_application_id" {
  value = aws_codedeploy_app.deploy.application_id
}

output "codedeploy_deployment_group_arn" {
  value = aws_codedeploy_deployment_group.deploy.arn
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.deploy.deployment_group_name
}

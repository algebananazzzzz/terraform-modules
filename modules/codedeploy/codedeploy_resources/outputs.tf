output "codedeploy_deployment_group_arn" {
  value = aws_codedeploy_deployment_group.deploy.arn
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.deploy.deployment_group_name
}

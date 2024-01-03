locals {
  lambda_managed_policy = var.compute_platform == "Lambda" ? "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda" : ""
  ecs_managed_policy    = var.compute_platform == "ECS" ? "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS" : ""
  managed_policy_arn    = coalesce(local.lambda_managed_policy, local.ecs_managed_policy)
}


resource "aws_iam_role" "codedeploy_service_role" {
  count = var.create_codedeploy_service_role ? 1 : 0
  name  = var.codedeploy_service_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    local.managed_policy_arn
  ]
}

data "aws_iam_role" "codedeploy_service_role" {
  count = var.create_codedeploy_service_role ? 0 : 1
  name  = var.codedeploy_service_role_name
}

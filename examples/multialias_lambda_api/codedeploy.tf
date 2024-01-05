locals {
  codedeploy_service_role_name     = "${var.env}-mgmt-role-multialiasapi-codedeploysvcrole"
  codedeploy_app_name              = "${var.env}-mgmt-deployapp-multialiasapi"
  codedeploy_deployment_group_name = "${var.env}-mgmt-deploygrp-multialiasapi"
}

module "lambda_codedeploy_resources" {
  source                            = "github.com/algebananazzzzz/terraform_modules/modules/codedeploy_resources"
  compute_platform                  = "Lambda"
  codedeploy_service_role_name      = local.codedeploy_service_role_name
  codedeploy_app_name               = local.codedeploy_app_name
  codedeploy_deployment_group_name  = local.codedeploy_deployment_group_name
  codedeploy_deployment_config_name = "CodeDeployDefault.LambdaAllAtOnce"

  deployment_style = {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration = {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  create_codedeploy_service_role = true
  create_codedeploy_app          = true
}

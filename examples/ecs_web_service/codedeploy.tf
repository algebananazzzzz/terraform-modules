locals {
  codedeploy_service_role_name     = "test-app-role-apolloweb-codedeployservicerole"
  codedeploy_app_name              = "test-app-deployapp-apolloweb"
  codedeploy_deployment_group_name = "test-app-deploygrp-apolloweb"
}

module "codedeploy_resources" {
  source                            = "./modules/codedeploy/codedeploy_resources"
  compute_platform                  = "ECS"
  codedeploy_service_role_name      = local.codedeploy_service_role_name
  codedeploy_app_name               = local.codedeploy_app_name
  codedeploy_deployment_group_name  = local.codedeploy_deployment_group_name
  codedeploy_deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  deployment_style = {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration = {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  ecs_service = {
    cluster_name = aws_ecs_cluster.cluster.name
    service_name = aws_ecs_service.service.name
  }

  ecs_load_balancer_info = {
    prod_traffic_route_listener_arns = [aws_lb_listener.prd.arn]
    test_traffic_route_listener_arns = [aws_lb_listener.test.arn]
    target_group_1_name              = aws_lb_target_group.blue.name
    target_group_2_name              = aws_lb_target_group.green.name
  }

  blue_green_deployment_config = {
    deployment_ready_option = {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
      # wait_time_in_minutes = 5
    }
    terminate_blue_instances_on_deployment_success = {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  create_codedeploy_service_role = true
  create_codedeploy_app          = true
}

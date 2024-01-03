resource "aws_codedeploy_app" "deploy" {
  count            = var.create_codedeploy_app ? 1 : 0
  compute_platform = var.compute_platform
  name             = var.codedeploy_app_name
}

resource "aws_codedeploy_deployment_config" "deployment_config" {
  count = var.create_codedeploy_deployment_config == null ? 0 : 1

  deployment_config_name = var.codedeploy_deployment_config_name
  compute_platform       = var.compute_platform

  traffic_routing_config {
    type = var.create_codedeploy_deployment_config.type

    dynamic "time_based_canary" {
      for_each = var.create_codedeploy_deployment_config.time_based_canary != null ? { 1 : var.create_codedeploy_deployment_config.time_based_canary } : {}
      content {
        interval   = time_based_canary.value.interval
        percentage = time_based_canary.value.percentage
      }
    }

    dynamic "time_based_linear" {
      for_each = var.create_codedeploy_deployment_config.time_based_linear != null ? { 1 : var.create_codedeploy_deployment_config.time_based_linear } : {}
      content {
        interval   = time_based_linear.value.interval
        percentage = time_based_linear.value.percentage
      }
    }
  }
}

resource "aws_codedeploy_deployment_group" "deploy" {
  app_name               = var.codedeploy_app_name
  deployment_group_name  = var.codedeploy_deployment_group_name
  service_role_arn       = var.create_codedeploy_service_role ? aws_iam_role.codedeploy_service_role[0].arn : data.aws_iam_role.codedeploy_service_role[0].arn
  deployment_config_name = var.codedeploy_deployment_config_name

  deployment_style {
    deployment_option = var.deployment_style.deployment_option
    deployment_type   = var.deployment_style.deployment_type
  }

  dynamic "auto_rollback_configuration" {
    for_each = var.auto_rollback_configuration != null ? [true] : []
    content {
      enabled = var.auto_rollback_configuration.enabled
      events  = var.auto_rollback_configuration.events
    }
  }

  dynamic "blue_green_deployment_config" {
    for_each = var.blue_green_deployment_config != null ? [true] : []
    content {
      deployment_ready_option {
        action_on_timeout    = var.blue_green_deployment_config.deployment_ready_option.action_on_timeout
        wait_time_in_minutes = var.blue_green_deployment_config.deployment_ready_option.wait_time_in_minutes
      }

      terminate_blue_instances_on_deployment_success {
        action                           = var.blue_green_deployment_config.terminate_blue_instances_on_deployment_success.action
        termination_wait_time_in_minutes = var.blue_green_deployment_config.terminate_blue_instances_on_deployment_success.termination_wait_time_in_minutes
      }
    }
  }

  dynamic "ecs_service" {
    for_each = var.ecs_service != null ? [true] : []
    content {
      cluster_name = var.ecs_service.cluster_name
      service_name = var.ecs_service.service_name
    }
  }

  dynamic "load_balancer_info" {
    for_each = var.ecs_load_balancer_info != null ? [true] : []

    content {
      target_group_pair_info {
        prod_traffic_route {
          listener_arns = var.ecs_load_balancer_info.prod_traffic_route_listener_arns
        }

        dynamic "test_traffic_route" {
          for_each = var.ecs_load_balancer_info.test_traffic_route_listener_arns != null ? [true] : []
          content {
            listener_arns = var.ecs_load_balancer_info.test_traffic_route_listener_arns
          }
        }

        target_group {
          name = var.ecs_load_balancer_info.target_group_1_name
        }

        target_group {
          name = var.ecs_load_balancer_info.target_group_2_name
        }
      }
    }
  }

  depends_on = [
    aws_codedeploy_deployment_config.deployment_config,
    aws_codedeploy_app.deploy
  ]
}

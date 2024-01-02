resource "aws_codedeploy_app" "deploy" {
  compute_platform = var.compute_platform
  name             = var.codedeploy_app_name
}

resource "aws_codedeploy_deployment_config" "deployment_config" {
  count = var.codedeploy_deployment_config.new_routing_config == null ? 0 : 1

  deployment_config_name = var.codedeploy_deployment_config.name
  compute_platform       = var.compute_platform

  traffic_routing_config {
    type = var.codedeploy_deployment_config.new_routing_config.type

    dynamic "time_based_canary" {
      for_each = var.codedeploy_deployment_config.new_routing_config.time_based_canary != null ? { 1 : var.codedeploy_deployment_config.new_routing_config.time_based_canary } : {}
      content {
        interval   = time_based_canary.value.interval
        percentage = time_based_canary.value.percentage
      }
    }

    dynamic "time_based_linear" {
      for_each = var.codedeploy_deployment_config.new_routing_config.time_based_linear != null ? { 1 : var.codedeploy_deployment_config.new_routing_config.time_based_linear } : {}
      content {
        interval   = time_based_linear.value.interval
        percentage = time_based_linear.value.percentage
      }
    }
  }
}

resource "aws_codedeploy_deployment_group" "deploy" {
  app_name               = aws_codedeploy_app.deploy.name
  deployment_group_name  = var.codedeploy_deployment_group_name
  service_role_arn       = var.create_codedeploy_service_role ? aws_iam_role.codedeploy_service_role[0].arn : data.aws_iam_role.codedeploy_service_role[0].arn
  deployment_config_name = var.codedeploy_deployment_config.name

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  dynamic "blue_green_deployment_config" {
    for_each = var.blue_green_deployment_config != null ? { "ecs" : var.blue_green_deployment_config } : {}
    content {
      deployment_ready_option {
        action_on_timeout = blue_green_deployment_config.value.deployment_ready_action_on_timeout_option
      }

      terminate_blue_instances_on_deployment_success {
        action                           = "TERMINATE"
        termination_wait_time_in_minutes = 5
      }
    }
  }

  dynamic "ecs_service" {
    for_each = var.ecs_service != null ? { "ecs" : var.ecs_service } : {}
    content {
      cluster_name = ecs_service.value.cluster_name
      service_name = ecs_service.value.service_name
    }
  }

  dynamic "load_balancer_info" {
    for_each = var.load_balancer_info != null ? { "lb" : var.load_balancer_info } : {}

    content {
      target_group_pair_info {
        prod_traffic_route {
          listener_arns = load_balancer_info.value.prod_traffic_route_listener_arns
        }

        test_traffic_route {
          listener_arns = load_balancer_info.value.test_traffic_route_listener_arns
        }

        target_group {
          name = load_balancer_info.value.target_group_blue
        }

        target_group {
          name = load_balancer_info.value.target_group_green
        }
      }
    }
  }

  depends_on = [aws_codedeploy_deployment_config.deployment_config]
}

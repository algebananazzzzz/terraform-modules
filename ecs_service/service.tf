resource "aws_ecs_service" "this" {
  name                               = var.service_name
  cluster                            = var.cluster_id
  task_definition                    = var.task_definition_arn
  desired_count                      = var.desired_count
  launch_type                        = var.launch_type
  scheduling_strategy                = var.scheduling_strategy
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  platform_version                   = var.platform_version
  force_new_deployment               = var.force_new_deployment
  wait_for_steady_state              = var.wait_for_steady_state
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  propagate_tags                     = var.propagate_tags
  enable_execute_command             = var.enable_execute_command

  deployment_controller {
    type = var.deployment_controller_type
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer_config != null ? [var.load_balancer_config] : []
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  dynamic "service_registries" {
    for_each = var.service_registry_config != null ? [var.service_registry_config] : []
    content {
      registry_arn   = service_registries.value.registry_arn
      port           = service_registries.value.port
      container_name = service_registries.value.container_name
      container_port = service_registries.value.container_port
    }
  }

  deployment_circuit_breaker {
    enable   = var.enable_deployment_circuit_breaker
    rollback = var.enable_rollback
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      type       = placement_constraints.value.type
      expression = placement_constraints.value.expression
    }
  }

  lifecycle {
    ignore_changes = var.deployment_controller_type == "CODE_DEPLOY" ? [
      task_definition,
      load_balancer,
      desired_count,
      platform_version
    ] : []
  }

  tags = var.tags
}

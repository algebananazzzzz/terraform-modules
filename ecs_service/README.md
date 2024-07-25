# ECS Service Terraform Module

This Terraform module creates an Amazon ECS service with support for various configurations, including integration with Application Load Balancers and CodeDeploy for blue/green deployments.

## Basic Example

```hcl
module "ecs_service" {
  source = "path/to/ecs_service_module"

  service_name        = "my-service"
  cluster_id          = "arn:aws:ecs:us-west-2:123456789012:cluster/my-cluster"
  task_definition_arn = "arn:aws:ecs:us-west-2:123456789012:task-definition/my-task:1"
  desired_count       = 2
  
  subnet_ids          = ["subnet-12345678", "subnet-23456789"]
  security_group_ids  = ["sg-12345678"]

  # Optional
  load_balancer_config = {
    target_group_arn = "arn:aws:elasticloadbalancing:us-west-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067"
    container_name   = "my-container"
    container_port   = 8080
  }
}
```

## Basic Example with CodeDeploy (Blue/Green Deployment)
```
module "ecs_service" {
  source = "path/to/ecs_service_module"

  service_name        = "my-service"
  cluster_id          = "arn:aws:ecs:us-west-2:123456789012:cluster/my-cluster"
  task_definition_arn = "arn:aws:ecs:us-west-2:123456789012:task-definition/my-task:1"
  desired_count       = 2
  
  subnet_ids          = ["subnet-12345678", "subnet-23456789"]
  security_group_ids  = ["sg-12345678"]

  deployment_controller_type = "CODE_DEPLOY"

  load_balancer_config = {
    target_group_arn = "arn:aws:elasticloadbalancing:us-west-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067"
    container_name   = "my-container"
    container_port   = 8080
  }

  enable_deployment_circuit_breaker = true
  enable_rollback                   = true
}
```

## Full Configuration Example
```
module "ecs_service" {
  source = "path/to/ecs_service_module"

  service_name                        = "my-service"
  cluster_id                          = "arn:aws:ecs:us-west-2:123456789012:cluster/my-cluster"
  task_definition_arn                 = "arn:aws:ecs:us-west-2:123456789012:task-definition/my-task:1"
  desired_count                       = 3
  launch_type                         = "FARGATE"
  scheduling_strategy                 = "REPLICA"
  deployment_maximum_percent          = 200
  deployment_minimum_healthy_percent  = 100
  health_check_grace_period_seconds   = 60
  platform_version                    = "1.4.0"
  force_new_deployment                = true
  wait_for_steady_state               = true
  enable_ecs_managed_tags             = true
  propagate_tags                      = "SERVICE"
  enable_execute_command              = true

  deployment_controller_type          = "CODE_DEPLOY"

  subnet_ids                          = ["subnet-12345678", "subnet-23456789"]
  security_group_ids                  = ["sg-12345678"]
  assign_public_ip                    = false

  load_balancer_config = {
    target_group_arn = "arn:aws:elasticloadbalancing:us-west-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067"
    container_name   = "my-container"
    container_port   = 8080
  }

  service_registry_config = {
    registry_arn   = "arn:aws:servicediscovery:us-west-2:123456789012:service/srv-12345678901234567"
    container_name = "my-container"
    container_port = 8080
  }

  enable_deployment_circuit_breaker = true
  enable_rollback                   = true

  ordered_placement_strategy = [
    {
      type  = "binpack"
      field = "memory"
    },
    {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    }
  ]

  placement_constraints = [
    {
      type       = "memberOf"
      expression = "attribute:ecs.instance-type =~ t3.*"
    }
  ]

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
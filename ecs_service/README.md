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


## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | ARN of the ECS cluster | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs associated with the ECS service | `list(string)` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS service | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs associated with the ECS service | `list(string)` | n/a | yes |
| <a name="input_task_definition_arn"></a> [task\_definition\_arn](#input\_task\_definition\_arn) | ARN of the task definition | `string` | n/a | yes |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Assign a public IP address to the ENI | `bool` | `false` | no |
| <a name="input_deployment_controller_type"></a> [deployment\_controller\_type](#input\_deployment\_controller\_type) | Type of deployment controller | `string` | `"ECS"` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment | `number` | `100` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Number of instances of the task definition to place and keep running | `number` | `1` | no |
| <a name="input_enable_deployment_circuit_breaker"></a> [enable\_deployment\_circuit\_breaker](#input\_enable\_deployment\_circuit\_breaker) | Enable deployment circuit breaker | `bool` | `false` | no |
| <a name="input_enable_ecs_managed_tags"></a> [enable\_ecs\_managed\_tags](#input\_enable\_ecs\_managed\_tags) | Specifies whether to enable Amazon ECS managed tags for the tasks within the service | `bool` | `false` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Specifies whether to enable Amazon ECS Exec for the tasks within the service | `bool` | `false` | no |
| <a name="input_enable_rollback"></a> [enable\_rollback](#input\_enable\_rollback) | Enable rollback on deployment failure | `bool` | `false` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Enable to force a new task deployment of the service | `bool` | `false` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown | `number` | `0` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | Launch type on which to run your service | `string` | `"FARGATE"` | no |
| <a name="input_load_balancer_config"></a> [load\_balancer\_config](#input\_load\_balancer\_config) | Load balancer configuration for the service | <pre>object({<br>    target_group_arn = string<br>    container_name   = string<br>    container_port   = number<br>  })</pre> | `null` | no |
| <a name="input_ordered_placement_strategy"></a> [ordered\_placement\_strategy](#input\_ordered\_placement\_strategy) | Service level strategy rules that are taken into consideration during task placement | <pre>list(object({<br>    type  = string<br>    field = string<br>  }))</pre> | `[]` | no |
| <a name="input_placement_constraints"></a> [placement\_constraints](#input\_placement\_constraints) | Rules that are taken into consideration during task placement | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | Platform version on which to run your service | `string` | `"LATEST"` | no |
| <a name="input_propagate_tags"></a> [propagate\_tags](#input\_propagate\_tags) | Specifies whether to propagate the tags from the task definition or the service to the tasks | `string` | `"NONE"` | no |
| <a name="input_scheduling_strategy"></a> [scheduling\_strategy](#input\_scheduling\_strategy) | Scheduling strategy to use for the service | `string` | `"REPLICA"` | no |
| <a name="input_service_registry_config"></a> [service\_registry\_config](#input\_service\_registry\_config) | Service discovery registry configuration for the service | <pre>object({<br>    registry_arn   = string<br>    port           = optional(number)<br>    container_name = optional(string)<br>    container_port = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the ECS service | `map(string)` | `{}` | no |
| <a name="input_wait_for_steady_state"></a> [wait\_for\_steady\_state](#input\_wait\_for\_steady\_state) | Whether to wait for the service to reach a steady state before continuing | `bool` | `false` | no |
<!-- END_TF_DOCS -->
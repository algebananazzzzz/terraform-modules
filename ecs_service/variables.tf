variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "cluster_id" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN of the task definition"
  type        = string
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

variable "launch_type" {
  description = "Launch type on which to run your service"
  type        = string
  default     = "FARGATE"
}

variable "scheduling_strategy" {
  description = "Scheduling strategy to use for the service"
  type        = string
  default     = "REPLICA"
}

variable "deployment_maximum_percent" {
  description = "Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
  default     = 100
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown"
  type        = number
  default     = 0
}

variable "platform_version" {
  description = "Platform version on which to run your service"
  type        = string
  default     = "LATEST"
}

variable "force_new_deployment" {
  description = "Enable to force a new task deployment of the service"
  type        = bool
  default     = false
}

variable "wait_for_steady_state" {
  description = "Whether to wait for the service to reach a steady state before continuing"
  type        = bool
  default     = false
}

variable "enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service"
  type        = bool
  default     = false
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks"
  type        = string
  default     = "NONE"
}

variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service"
  type        = bool
  default     = false
}

variable "deployment_controller_type" {
  description = "Type of deployment controller"
  type        = string
  default     = "ECS"
}

variable "subnet_ids" {
  description = "List of subnet IDs associated with the ECS service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs associated with the ECS service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign a public IP address to the ENI"
  type        = bool
  default     = false
}

variable "load_balancer_config" {
  description = "Load balancer configuration for the service"
  type = object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
  default = null
}

variable "service_registry_config" {
  description = "Service discovery registry configuration for the service"
  type = object({
    registry_arn   = string
    port           = optional(number)
    container_name = optional(string)
    container_port = optional(number)
  })
  default = null
}

variable "enable_deployment_circuit_breaker" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = false
}

variable "enable_rollback" {
  description = "Enable rollback on deployment failure"
  type        = bool
  default     = false
}

variable "ordered_placement_strategy" {
  description = "Service level strategy rules that are taken into consideration during task placement"
  type = list(object({
    type  = string
    field = string
  }))
  default = []
}

variable "placement_constraints" {
  description = "Rules that are taken into consideration during task placement"
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to add to the ECS service"
  type        = map(string)
  default     = {}
}

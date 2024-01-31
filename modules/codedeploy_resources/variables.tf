variable "compute_platform" {
  type = string
}

variable "codedeploy_service_role_name" {
  type = string
}

variable "create_codedeploy_service_role" {
  type    = bool
  default = false
}

variable "codedeploy_app_name" {
  type = string
}

variable "create_codedeploy_app" {
  type    = bool
  default = false
}

variable "codedeploy_deployment_config_name" {
  type = string
}

variable "create_codedeploy_deployment_config" {
  type = object({
    type = string
    time_based_linear = optional(object({
      interval   = number
      percentage = number
    }))
    time_based_canary = optional(object({
      interval   = number
      percentage = number
    }))
  })
  default = null
}

variable "codedeploy_deployment_group_name" {
  type = string
}

variable "deployment_style" {
  type = object({
    deployment_option = string
    deployment_type   = string
  })
}

variable "auto_rollback_configuration" {
  type = object({
    enabled = bool
    events  = list(string)
  })
  default = null
}

variable "ecs_service" {
  type = object({
    cluster_name = string
    service_name = string
  })
  default = null
}

variable "ecs_load_balancer_info" {
  type = object({
    prod_traffic_route_listener_arns = list(string)
    test_traffic_route_listener_arns = optional(list(string))
    target_group_1_name              = string
    target_group_2_name              = string
  })
  default = null
}

variable "blue_green_deployment_config" {
  type = object({
    deployment_ready_option = object({
      action_on_timeout    = string
      wait_time_in_minutes = optional(number)
    })
    terminate_blue_instances_on_deployment_success = object({
      action                           = string
      termination_wait_time_in_minutes = optional(number)
    })
  })
  default = null
}

variable "compute_platform" {
  type = string
}

variable "codedeploy_service_role_name" {
  type = string
}

variable "codedeploy_app_name" {
  type = string
}

variable "create_codedeploy_service_role" {
  type    = bool
  default = false
}

variable "codedeploy_deployment_config" {
  type = object({
    name = string
    new_routing_config = optional(object({
      type = string
      time_based_linear = optional(object({
        interval   = number
        percentage = number
      }))
      time_based_canary = optional(object({
        interval   = number
        percentage = number
      }))
    }))
  })
}

variable "codedeploy_deployment_group_name" {
  type = string
}

variable "ecs_service" {
  type = object({
    cluster_name = string
    service_name = string
  })
  default = null
}

variable "load_balancer_info" {
  type = object({
    prod_traffic_route_listener_arns = list(string)
    test_traffic_route_listener_arns = optional(list(string))
    target_group_blue                = string
    target_group_green               = string
  })
  default = null
}


variable "blue_green_deployment_config" {
  type = object({
    deployment_ready_action_on_timeout_option                          = string
    terminate_blue_instances_on_deployment_succes_wait_time_in_minutes = number
  })
  default = null
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "container_port" {
  description = "Port on which the container is listening"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol to use for routing traffic to the targets"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering the target unhealthy"
  type        = number
  default     = 3
}

variable "health_check_timeout" {
  description = "Amount of time, in seconds, during which no response means a failed health check"
  type        = number
  default     = 5
}

variable "health_check_path" {
  description = "Destination for the health check request"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
  default     = 30
}

variable "alb_arn" {
  description = "ARN of the ALB"
  type        = string
}

variable "listener_port" {
  description = "Port on which the load balancer is listening"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for connections from clients to the load balancer"
  type        = string
  default     = "HTTP"
}

variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
  default     = ""
}

variable "enable_blue_green" {
  description = "Enable blue/green deployment"
  type        = bool
  default     = false
}

variable "cognito_auth_config" {
  description = "Cognito authentication configuration"
  type = object({
    user_pool_arn                       = string
    user_pool_client_id                 = string
    user_pool_domain                    = string
    authentication_request_extra_params = optional(map(string))
    on_unauthenticated_request          = optional(string)
    scope                               = optional(string)
    session_cookie_name                 = optional(string)
    session_timeout                     = optional(number)
  })
  default = null
}

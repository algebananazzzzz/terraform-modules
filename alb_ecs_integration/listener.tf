# Create ALB Listener with optional SSL certificate
resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = var.alb_arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.listener_protocol == "HTTPS" ? var.ssl_policy : null
  certificate_arn   = var.listener_protocol == "HTTPS" ? var.certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = var.enable_blue_green ? aws_lb_target_group.blue[0].arn : aws_lb_target_group.single[0].arn
  }

  dynamic "default_action" {
    for_each = var.cognito_auth_config != null ? [var.cognito_auth_config] : []
    content {
      type = "authenticate-cognito"

      authenticate_cognito {
        user_pool_arn                       = default_action.value.user_pool_arn
        user_pool_client_id                 = default_action.value.user_pool_client_id
        user_pool_domain                    = default_action.value.user_pool_domain
        authentication_request_extra_params = default_action.value.authentication_request_extra_params
        on_unauthenticated_request          = default_action.value.on_unauthenticated_request
        scope                               = default_action.value.scope
        session_cookie_name                 = default_action.value.session_cookie_name
        session_timeout                     = default_action.value.session_timeout
      }
    }
  }
}

# ALB-ECS Integration Terraform Module

This Terraform module creates an integration between an Application Load Balancer (ALB) and an Amazon ECS service. It supports both single and blue/green deployment configurations, as well as optional Cognito authentication.

## Basic Example

```terraform
module "alb_ecs_integration" {
  source = "path/to/alb_ecs_integration"

  target_group_name    = "dev-web-tgrp-example"
  container_port       = 8080
  vpc_id               = "vpc-12345678"
  alb_arn              = "arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/app/my-load-balancer/1234567890123456"
  listener_port        = 80
  listener_protocol    = "HTTP"
}
```

## Full Configuration Example 
```terraform
module "alb_ecs_integration" {
  source = "path/to/alb_ecs_integration"

  target_group_name    = "dev-web-tgrp-example"
  container_port       = 8080
  target_group_protocol = "HTTPS"
  vpc_id               = "vpc-12345678"
  alb_arn              = "arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/app/my-load-balancer/1234567890123456"
  listener_port        = 443
  listener_protocol    = "HTTPS"
  ssl_policy           = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn      = "arn:aws:acm:us-west-2:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  enable_blue_green    = true

  health_check_path     = "/healthz"
  health_check_interval = 60
  health_check_timeout  = 10
  health_check_healthy_threshold = 5
  health_check_unhealthy_threshold = 2

  cognito_auth_config = {
    user_pool_arn       = "arn:aws:cognito-idp:us-west-2:123456789012:userpool/us-west-2_abcdefgh"
    user_pool_client_id = "12345678901234567890123456"
    user_pool_domain    = "my-cognito-domain"
    authentication_request_extra_params = {
      prompt = "login"
    }
    on_unauthenticated_request = "authenticate"
    scope                      = "openid profile email"
    session_cookie_name        = "AWSELBAuthSessionCookie"
    session_timeout            = 3600
  }
}
```
<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
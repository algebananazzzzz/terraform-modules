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


## Resources

| Name | Type |
|------|------|
| [aws_lb_listener.ecs_alb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.blue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.green](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.single](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | ARN of the ALB | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port on which the container is listening | `number` | n/a | yes |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Name of the target group | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the SSL certificate | `string` | `""` | no |
| <a name="input_cognito_auth_config"></a> [cognito\_auth\_config](#input\_cognito\_auth\_config) | Cognito authentication configuration | <pre>object({<br>    user_pool_arn                       = string<br>    user_pool_client_id                 = string<br>    user_pool_domain                    = string<br>    authentication_request_extra_params = optional(map(string))<br>    on_unauthenticated_request          = optional(string)<br>    scope                               = optional(string)<br>    session_cookie_name                 = optional(string)<br>    session_timeout                     = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_enable_blue_green"></a> [enable\_blue\_green](#input\_enable\_blue\_green) | Enable blue/green deployment | `bool` | `false` | no |
| <a name="input_health_check_healthy_threshold"></a> [health\_check\_healthy\_threshold](#input\_health\_check\_healthy\_threshold) | Number of consecutive health checks successes required before considering an unhealthy target healthy | `number` | `3` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | Approximate amount of time, in seconds, between health checks of an individual target | `number` | `30` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Destination for the health check request | `string` | `"/"` | no |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | Amount of time, in seconds, during which no response means a failed health check | `number` | `5` | no |
| <a name="input_health_check_unhealthy_threshold"></a> [health\_check\_unhealthy\_threshold](#input\_health\_check\_unhealthy\_threshold) | Number of consecutive health check failures required before considering the target unhealthy | `number` | `3` | no |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | Port on which the load balancer is listening | `number` | `80` | no |
| <a name="input_listener_protocol"></a> [listener\_protocol](#input\_listener\_protocol) | Protocol for connections from clients to the load balancer | `string` | `"HTTP"` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | The name of the SSL Policy for the listener | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | Protocol to use for routing traffic to the targets | `string` | `"HTTP"` | no |
<!-- END_TF_DOCS -->
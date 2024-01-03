locals {
  load_balancer_name                = "test-web-alb-apolloweb"
  security_group_from_internet_name = "test-web-sg-apolloweb-allowinternet"
  security_group_from_lb_name       = "test-app-sg-apolloweb-allowfromalb"
  target_group_blue_name            = "test-web-targetgrp-apolloweb-1"
  target_group_green_name           = "test-web-targetgrp-apolloweb-2"

}

module "load_balancer" {
  source                                         = "./modules/alb"
  load_balancer_name                             = local.load_balancer_name
  security_group_from_internet_name              = local.security_group_from_internet_name
  security_group_from_internet_allowed_tcp_ports = [80, 443, 8080]
  security_group_from_lb_name                    = local.security_group_from_lb_name
  subnet_ids                                     = ["subnet-06087312cf04c54f5", "subnet-09b4e055d0cbd6189"]
  vpc_id                                         = "vpc-04e1513ba931c6b05"
}

resource "aws_lb_target_group" "blue" {
  name        = local.target_group_blue_name
  port        = 4000
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = module.load_balancer.vpc_id

  health_check {
    port     = 4000
    path     = "/health"
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group" "green" {
  name        = local.target_group_green_name
  port        = 4000
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = module.load_balancer.vpc_id

  health_check {
    port     = 4000
    path     = "/health"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "prd" {
  load_balancer_arn = module.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = module.load_balancer.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}

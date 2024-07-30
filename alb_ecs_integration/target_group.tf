# Conditional creation of Target Groups (Blue and Green)
resource "aws_lb_target_group" "blue" {
  count       = var.enable_blue_green ? 1 : 0
  name        = "${var.target_group_name}-blue"
  port        = var.container_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    interval            = var.health_check_interval
  }
}

resource "aws_lb_target_group" "green" {
  count       = var.enable_blue_green ? 1 : 0
  name        = "${var.target_group_name}-green"
  port        = var.container_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    interval            = var.health_check_interval
  }
}

# Conditional creation of a single Target Group
resource "aws_lb_target_group" "single" {
  count       = var.enable_blue_green ? 0 : 1
  name        = var.target_group_name
  port        = var.container_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    interval            = var.health_check_interval
  }
}

resource "aws_security_group" "allow_internet" {
  name        = var.security_group_from_internet_name
  description = "Allow inbound internet traffic to ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_from_internet_allowed_tcp_ports
    content {
      description      = "Allow TCP traffic from internet on port ${ingress.value}"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "allow_from_lb" {
  name        = var.security_group_from_lb_name
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Traffic from ALB"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.allow_internet.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


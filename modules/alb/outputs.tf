output "arn" {
  value = aws_lb.load_balancer.arn
}

output "dns_name" {
  value = aws_lb.load_balancer.dns_name
}

output "security_group_from_lb_id" {
  value = aws_security_group.allow_from_lb.id
}

output "security_group_from_internet_id" {
  value = aws_security_group.allow_internet.id
}

output "subnet_ids" {
  value = var.subnet_ids
}

output "vpc_id" {
  value = var.vpc_id
}

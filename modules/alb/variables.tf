variable "security_group_from_internet_name" {
  type = string
}

variable "security_group_from_internet_allowed_tcp_ports" {
  type    = list(number)
  default = [80, 443]
}


variable "security_group_from_lb_name" {
  type = string
}

variable "load_balancer_name" {
  type = string
}

variable "load_balancer_internal" {
  type    = bool
  default = false
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

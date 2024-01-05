locals {
  allow_from_nat_instance_sg_name = "shd-app-sg-allownat"
  private_subnets = [
    "${var.env}-app-subnet-private-1a",
    "${var.env}-app-subnet-private-1b"
  ]
}

# Get private subnet ids to deploy lambda in
data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = local.private_subnets
  }
}

# Get security group allowing NAT connection
data "aws_security_group" "allow_nat" {
  filter {
    name   = "tag:Name"
    values = [local.allow_from_nat_instance_sg_name]
  }
}

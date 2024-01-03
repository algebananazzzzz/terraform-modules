locals {
  task_definition_name = "test-app-taskdefn-apolloweb"
  cluster_name         = "test-app-ecscluster-apolloweb"
  service_name         = "test-app-ecsservice-apolloweb"
}


# resource "aws_ecs_task_definition" "service" {
#   family                   = local.task_definition_name
#   cpu                      = 512
#   memory                   = 1024
#   network_mode             = "awsvpc"
#   task_role_arn            = "arn:aws:iam::399042951453:role/ECS-task-role"
#   execution_role_arn       = "arn:aws:iam::399042951453:role/ecsTaskExecutionRole"
#   requires_compatibilities = ["FARGATE"]
#   container_definitions = jsonencode([
#     {
#       name      = "apollojs"
#       image     = "399042951453.dkr.ecr.us-east-1.amazonaws.com/apollojs:v1"
#       cpu       = 0
#       essential = true
#       portMappings = [
#         {
#           containerPort = 4000
#           hostPort      = 4000
#           protocol      = "tcp"
#           appProtocol   = "http"
#         }
#       ]
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-create-group  = "true"
#           awslogs-group         = "/ecs/task-definition-1"
#           awslogs-region        = "us-east-1"
#           awslogs-stream-prefix = "ecs"
#         }
#       }
#     }
#   ])
# }

resource "aws_ecs_cluster" "cluster" {
  name = local.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_ecs_service" "service" {
  name    = local.service_name
  cluster = aws_ecs_cluster.cluster.id
  # task_definition = aws_ecs_task_definition.service.arn
  desired_count = 1
  # launch_type     = "FARGATE"

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }

  network_configuration {
    subnets          = module.load_balancer.subnet_ids
    security_groups  = [module.load_balancer.security_group_from_lb_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "apollojs"
    container_port   = 4000
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "apollojs"
}

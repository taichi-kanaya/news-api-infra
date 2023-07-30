# ECSクラスター
resource "aws_ecs_cluster" "app" {
  name = var.app_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECSタスク定義
resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  execution_role_arn       = var.ecs_task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      "name" : var.app_name,
      "image" : "${var.ecr_repository_url}:latest",
      "cpu" : 0,
      "portMappings" : [
        {
          "name" : "${var.app_name}-8080-tcp",
          "containerPort" : 8080,
          "hostPort" : 8080,
          "protocol" : "tcp",
          "appProtocol" : "http"
        }
      ],
      "essential" : true,
      "secrets" : var.ecs_secrets,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : "/ecs/${var.app_name}",
          "awslogs-region" : "ap-northeast-1",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
}

# ECSサービス
resource "aws_ecs_service" "app" {
  launch_type     = "FARGATE"
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = var.ecs_target_group_arn
    container_name   = var.app_name
    container_port   = 8080
  }

  network_configuration {
    subnets          = [for s in var.private_subnets : s.id]
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  enable_ecs_managed_tags = true
}

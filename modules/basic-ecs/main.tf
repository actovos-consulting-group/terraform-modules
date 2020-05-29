resource "aws_ecs_cluster" "cluster" {
  name = var.name
}

resource "aws_ecr_repository" "repo" {
  name = var.name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.name}-task"
  container_definitions    = file("./task.json")
  task_role_arn            = aws_iam_role.ecs_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  volume {
    name = "app"
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.lb_subnet_ids
    assign_public_ip = true
    security_groups  = [aws_security_group.sg.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tg.arn
    container_name   = "nginx"
    container_port   = 80
  }
}

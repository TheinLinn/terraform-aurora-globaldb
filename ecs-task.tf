# ECS Task Definition
resource "aws_ecs_task_definition" "dc_taskdf" {

  family = var.app_name

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = 256
  memory = 512

  execution_role_arn = data.aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "Primary Task-Definition"

      image = "${aws_ecr_repository.app.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}


resource "aws_ecs_task_definition" "dr_taskdf" {

  family = var.app_name

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = 256
  memory = 512

  execution_role_arn = data.aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "DR Task-Definition"

      image = "${aws_ecr_repository.app.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}
# ECS Task Definition
resource "aws_ecs_task_definition" "dc_taskdf" {

  family = "dc-web-App"

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = data.aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "dc-web-App"

      image = "${aws_ecr_repository.app.repository_url}:v1"

      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80

        }
      ]
    }
  ])
}


resource "aws_ecs_task_definition" "dr_taskdf" {

  provider = aws.dr

  family = "dr-web-App"

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = data.aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "dr-web-App"

      image = "${aws_ecr_repository.app.repository_url}:v1"

      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80

        }
      ]
    }
  ])
}
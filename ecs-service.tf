# ECS Service for DC
resource "aws_ecs_service" "dc_esc" {

  name = "${var.project_name}-service"

  cluster = aws_ecs_cluster.dc_cluster.id

  task_definition = aws_ecs_task_definition.dc_taskdf.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {

    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]

    security_groups = [
      aws_security_group.ecs_sg.id
    ]

    assign_public_ip = false
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.dc_tg.arn

    container_name = "dc-web-App"

    container_port = 80
  }

  depends_on = [
    aws_lb_listener.http
  ]
}

# ECS service for DR
resource "aws_ecs_service" "dr_esc" {

  provider = aws.dr

  name = "${var.project_name}-service-dr"

  cluster = aws_ecs_cluster.dr_cluster.id

  task_definition = aws_ecs_task_definition.dr_taskdf.arn

  desired_count = 0

  launch_type = "FARGATE"

  network_configuration {

    subnets = [
      aws_subnet.dr_private_a.id,
      aws_subnet.dr_private_b.id
    ]

    security_groups = [
      aws_security_group.dr_ecs_sg.id
    ]

    assign_public_ip = false
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.secondary_tg.arn

    container_name = "dr-web-App"

    container_port = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [
    aws_lb_listener.dr_http
  ]
}
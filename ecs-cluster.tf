# ECS Cluster at primary region
resource "aws_ecs_cluster" "dc-ecs-cluster" {
  name = "${var.project_name}-ecs-cluster"
}

# ECS Cluster at DR region
resource "aws_ecs_cluster" "dr-ecs-cluster" {
  provider = aws.dr
  name     = "${var.project_name}-ecs-cluster"
}
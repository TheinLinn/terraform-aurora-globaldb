# ECS Cluster at primary region
resource "aws_ecs_cluster" "dc_cluster" {
  name = "dc-ecs-cluster"
}

# ECS Cluster at DR region
resource "aws_ecs_cluster" "dr_cluster" {
  provider = aws.dr
  name     = "dr-ecs-cluster"
}
# ECR Repository
resource "aws_ecr_repository" "app" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"

  force_delete = true
}

# ECR Repository at DR region
resource "aws_ecr_repository" "app_dr" {
  provider             = aws.dr
  name                 = var.dr_app_name
  image_tag_mutability = "MUTABLE"

  force_delete = true
}
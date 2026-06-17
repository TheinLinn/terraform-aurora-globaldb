# Application Load Balancer
resource "aws_lb" "dc_alb" {

  name = "${var.project_name}-alb"

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

# Application Load Balancer for DR
resource "aws_lb" "dr_alb" {

  provider = aws.dr

  name = "${var.project_name}-dr-alb"

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.dr_alb_sg.id
  ]

  subnets = [
    aws_subnet.dr_public_a.id,
    aws_subnet.dr_public_b.id
  ]
}

# Target Group for primary
resource "aws_lb_target_group" "dc_tg" {

  name = "${var.project_name}-tg"

  port     = 3000
  protocol = "HTTP"

  target_type = "ip"

  vpc_id = aws_vpc.primary.id

  health_check {

    path = "/"

    matcher = "200"
  }
}

# Target Group for dr
resource "aws_lb_target_group" "secondary_tg" {

  name = "${var.project_name}-tg"

  port     = 3000
  protocol = "HTTP"

  target_type = "ip"

  vpc_id = aws_vpc.dr.id

  health_check {

    path = "/"

    matcher = "200"
  }
}

# Listener for primary
resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.dc_alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.dc_tg.arn
  }
}

# Listener for dr
resource "aws_lb_listener" "dr_http" {

  load_balancer_arn = aws_lb.dr_alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.secondary_tg.arn
  }
}

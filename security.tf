resource "aws_security_group" "aurora_sg" {
  name        = "${var.project_name}-aurora-sg"
  description = "Aurora security group"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "dr_aurora_sg" {
  provider = aws.dr

  name        = "${var.project_name}-dr-aurora-sg"
  description = "DR Aurora security group"
  vpc_id      = aws_vpc.dr.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Add security group for bastion host
resource "aws_security_group" "bastion_sg" {
  name   = "${var.project_name}-bastion-sg"
  vpc_id = aws_vpc.primary.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.233.207.98/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
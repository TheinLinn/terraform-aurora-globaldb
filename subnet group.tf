# Primary subnet group
resource "aws_db_subnet_group" "primary" {
  name = "primary-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

# DR subnet group
resource "aws_db_subnet_group" "dr" {
  provider = aws.dr

  name = "dr-db-subnet-group"

  subnet_ids = [
    aws_subnet.dr_private_a.id,
    aws_subnet.dr_private_b.id
  ]
  tags = {
    Name = "dr-db-subnet-group"
  }
}
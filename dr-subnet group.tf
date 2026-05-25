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
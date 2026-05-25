resource "aws_db_subnet_group" "primary" {
  name = "primary-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

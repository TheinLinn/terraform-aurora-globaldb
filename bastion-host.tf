# Primary Bastion host (Amazon Linux OS)
resource "aws_instance" "bastion" {
  ami                    = "ami-05b741ae2ab9f1742"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = aws_key_pair.bastion_key.key_name

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

# DR Bastion host (Amazon Linux OS)
resource "aws_instance" "dr_bastion" {
  provider = aws.dr

  ami           = "ami-0c036b62d1a414d7f"
  instance_type = "t3.micro"

  subnet_id = aws_subnet.dr_public_a.id

  vpc_security_group_ids = [
    aws_security_group.dr_bastion_sg.id
  ]

  key_name = aws_key_pair.dr_bastion_key.key_name

  associate_public_ip_address = true

  tags = {
    Name = "dr-bastion"
  }
}
# Primary Bastion host
resource "aws_instance" "bastion" {
  ami                    = "ami-0df7a207adb9748c7"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = aws_key_pair.bastion_key.key_name

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

# DR Bastion host
resource "aws_instance" "dr_bastion" {
  provider = aws.dr

  ami           = "YOUR_TOKYO_UBUNTU_AMI"
  instance_type = "t3.micro"

  subnet_id = aws_subnet.dr_public_a.id

  vpc_security_group_ids = [
    aws_security_group.dr_bastion_sg.id
  ]

  key_name = aws_key_pair.bastion_key.key_name

  associate_public_ip_address = true

  tags = {
    Name = "dr-bastion"
  }
}
/*# key pair for ssh of primary bastion hosts
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file("C:/Users/25-00102/.ssh/bastion_host_rsa.pub")
}

# key pair for ssh of dr bastion hosts
resource "aws_key_pair" "dr_bastion_key" {
  provider = aws.dr

  key_name   = "dr-bastion-key"
  public_key = file("C:/Users/25-00102/.ssh/dr_bastion_host_rsa.pub")
}*/
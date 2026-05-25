# key pair for ssh of primary and dr bastion hosts
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file("C:/Users/25-00102/.ssh/bastion_host_rsa.pub")
}
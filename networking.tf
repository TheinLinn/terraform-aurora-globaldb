resource "aws_vpc" "primary" {
  cidr_block           = var.primary_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_vpc" "dr" {
  provider             = aws.dr
  cidr_block           = var.dr_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# create private subnet-a
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "${var.primary_region}a"

  map_public_ip_on_launch = false
}

# create private subnet-b
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "${var.primary_region}b"

  map_public_ip_on_launch = false
}

# create private dr-subnet_a
resource "aws_subnet" "dr_private_a" {
  provider = aws.dr

  vpc_id            = aws_vpc.dr.id
  cidr_block        = "10.20.1.0/24"
  availability_zone = "${var.dr_region}a"

  map_public_ip_on_launch = false
}

# create private dr-subnet_b
resource "aws_subnet" "dr_private_b" {
  provider = aws.dr

  vpc_id            = aws_vpc.dr.id
  cidr_block        = "10.20.2.0/24"
  availability_zone = "${var.dr_region}c"

  map_public_ip_on_launch = false
}
# create VPC for primary
resource "aws_vpc" "primary" {
  cidr_block           = var.primary_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# create VPC for dr
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

# create public subnet-a (Use for bastion host and ALB)
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.10.100.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

# create internet gateway for bastion host
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "primary-igw"
  }
}

# create public route table for bastion host
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# to associate route table for bastion host
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# create public subnet for dr bastion host
resource "aws_subnet" "dr_public_a" {
  provider = aws.dr

  vpc_id                  = aws_vpc.dr.id
  cidr_block              = "10.20.100.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dr-public-subnet-a"
  }
}

# create internet gateway for dr bastion host
resource "aws_internet_gateway" "dr_igw" {
  provider = aws.dr

  vpc_id = aws_vpc.dr.id

  tags = {
    Name = "dr-igw"
  }
}

# create public route table for dr bastion host
resource "aws_route_table" "dr_public" {
  provider = aws.dr

  vpc_id = aws_vpc.dr.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dr_igw.id
  }
}

# to associate route table for dr bastion host
resource "aws_route_table_association" "dr_public_a" {
  provider = aws.dr

  subnet_id      = aws_subnet.dr_public_a.id
  route_table_id = aws_route_table.dr_public.id
}

# Public subnet-b for ALB
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.10.101.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

# DR public subnet-b for ALB
resource "aws_subnet" "dr_public_b" {

  provider = aws.dr

  vpc_id                  = aws_vpc.dr.id
  cidr_block              = "10.20.101.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "dr-public-subnet-b"
  }
}

# Create Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# Associate Private Subnets
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}
/* This Terraform deployment creates the following resources:
VPC, Subnet, Internet Gateway, Route Table, Default Route, Security Group, SSH Key, and EC2 with userdata script intsalling httpd
*/

# Create VPC Resources

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ec2_vpc"
  }
}

resource "aws_subnet" "my_public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}

resource "aws_route_table_association" "my_public_assoc" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_public_rt.id
}


# Create EC2 Security Group and Security Rules

resource "aws_security_group" "my_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create SSH Keys for EC2 Remote Access

resource "tls_private_key" "public_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "web_tier_EC2_rsa_key" {
  default     = "web_tier_EC2_rsa_key"
  description = "RSA Key variable"
  type        = string
}

resource "aws_key_pair" "web_tier_EC2_rsa_key" {
  key_name   = var.web_tier_EC2_rsa_key
  public_key = tls_private_key.public_key.public_key_openssh
}


# Create EC2 Instance

resource "aws_instance" "ec2_dev" {
  instance_type          = "t2.medium"
  ami                    = data.aws_ami.server_ami.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = aws_subnet.my_public_subnet.id
  key_name               = "web_tier_EC2_rsa_key"
  user_data              = file("install-apache.sh")

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "dev-node"
  }
}
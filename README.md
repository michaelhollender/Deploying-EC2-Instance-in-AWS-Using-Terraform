# Deploying-EC2-Instance-in-AWS-Using-Terraform
---

Deploying an EC2 Instance in AWS Using Terraform

Terraform is a terrific IaC tool that allows you to automate deploying not only on-premise but also Cloud Infrastructure.
It is very tedious to create and tear-down AWS infrastructure from within the AWS management console, you need to know what the dependencies of the underlying resources are before you can do either. Terraform handles all of the dependencies for you! We just need to know what we want to deploy.
Objectives:
Create main.tf, providers.tf, datasoures.tf, and install-apache.sh to manage your Terraform deployment.
Deploy 1 EC2 Instance (Amazon Linux 2) running Ubuntu into a new VPC.
Bootstrap the EC2 instance with a script that will install Apache and configure a test Website.
Create and assign a Security Group that allows traffic to the webserver on port 80.

Prerequisites:
AWS account with Administrator Access permissions
AWS CLI installed and configured with your programmatic access credentials
Terraform installed
VScode

---

Step 1: Create The Providers.tf File
# Terraform Providers

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
The terraform block specifies the provider we are downloading from the Terraform Registry and their version constraint.
We are specifying that we will be using an AWS provider. The shared_credentials_file argument could be used here or you could specify your access key and secret access key. I opted to store them under ~/.aws/credentials on my Fedora Linux VM, and omitting the shared_credentials_file argument, Terraform is still able to find the credentials on my system. For more information on setting up your AWS credentials, please see: https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html.

---

Step 2: Create the Main.tf, Providers.tf, Datasources.tf, and Install-apache.sh Files
In the main.tf file, we will need to configure the network-backbone that will distribute the network traffic in our private section of the AWS network and security groups that will allow/block traffic in/out of the EC2 instance. The resources needed are:
1. A VPC (Virtual Private Cloud)
2. Subnet
3. Internet Gateway
4. Route Table
5. Route
6. Route Table Association
7. Security Group
8. Instance AMI
9. Key Pair
10. EC2 Instance
main.tf
/* This Terraform deployment creates the following resources:
VPC, Subnet, Internet Gateway, Default Route, Security Group, SSH Key, and EC2 with userdata script intsalling httpd
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
providers.tf
# Terraform Providers

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
datasources.tf
# Use Data Sources to Query the AWS API to gather the AMI information needed for deploying the EC2 Instance

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
install-apache.sh
#!/bin/bash

# Use this Shell Script to Install apache2 on the EC2 Instance to Configure the EC2 Instance as a Webserver

apt update -y
apt install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<html><body><h1>WEB Tier EC2 Instance Deployed</h1></body></html>" > /var/www/html/index.html
We will want to check that all files were created. I need to run the "ls" command since I am working on a Fedora Linux VM.
ls
Note: I have the terraform.tfstate and terraform.tfstate.backup files in my directory because I have already ran terraform init and these files are created when that command is ran.

---

Step 3: Run the Terraform Commands to Create the EC2 Instance and the Underlying Infrastructure
Finally, we are now ready to deploy our AWS resources using Terraform. We must run "terraform init" to initialize the working directory that is holding the Terraform configuration files.
terraform init
To make sure that the Terraform code is formatted correctly we will need to run "terraform fmt". When I ran this command all of my Terraform configuration files were formatted correctly, if some files needed to have the formatting corrected, Terraform would correct the formatting, then display the file names at the prompt.
terraform fmt
Next, best practices dictates that, we must run "terraform plan" to see a preview of the changes Terraform will make to our infrastructure.
terraform plan
As can be seen from the screenshot above, Terraform will create 10 resources in AWS.
Now, let's deploy our resources:
terraform apply
You will be prompted to confirm that you want to perform these actions.
Enter "yes".
Once the command completes, you should see an output similar to below:
Congratulations! You have successfully deployed an EC2 instance running a webserver using Terraform.

---

Step 4: Verify Infrastructure Has Been Deployed
To verify, we can go to the management console and check!
We can copy the Public IP address from the management console and paste it in a web browser.

---

Step 5: Tear-down AWS Infrastructure
Run "terraform destroy" to terminate all the resources that were deployed during this lab.
The code for this project can be found at:
GitHub - michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform
Contribute to michaelhollender/Deploying-EC2-Instance-in-AWS-Using-Terraform development by creating an account on…github.com
That completes this project! Thank you for reading!

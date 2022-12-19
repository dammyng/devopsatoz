# Configure the AWS provider
provider "aws" {
  region = var.region
}

# Create a new VPC
resource "aws_vpc" "kubernetes_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a new public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.kubernetes_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "kubernetes_public_subnet"
  }
}

# Create a new security group for the Kubernetes control plane
resource "aws_security_group" "kubernetes_control_plane_sg" {
  name_prefix = "kubernetes_control_plane_"
  vpc_id = aws_vpc.kubernetes_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allowed_cidr_blocks]
  }

  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = [var.allowed_cidr_blocks]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Provision a Kubernetes control plane
module "kubernetes" {
  source = "terraform-aws-modules/kubernetes/aws"

  cluster_name = var.cluster_name
  subnets      = [aws_subnet.public_subnet.id]
  vpc_id       = aws_vpc.kubernetes_vpc.id

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }

  # Use the security group created above
  control_plane_security_group_id = aws_security_group.kubernetes_control_plane_sg.id
}

# Output the Kubernetes control plane endpoint
output "kubernetes_control_plane_endpoint" {
  value = module.kubernetes.control_plane_endpoint
}


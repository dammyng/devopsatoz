# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Set the default machine type for the worker nodes
variable "instance_type" {
  default = "t2.micro"
}

# Create an Amazon EKS cluster
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name = "example-cluster"
  subnets      = ["subnet-12345678", "subnet-87654321"]
  vpc_id       = "vpc-12345678"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  node_groups_launch_template = [
    {
      name                 = "workers"
      instance_type        = var.instance_type
      asg_desired_capacity = 2
    },
  ]
}

# Connect to the cluster
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = module.eks.cluster_token
}

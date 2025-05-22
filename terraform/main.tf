
provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "ecommerce-cluster"
  cluster_version = "1.29"
  subnets         = ["subnet-018a0920ef1cc9d97", "subnet-09bdf95b8d7f564c3", "subnet-08eef8b9289a093e4"]
  vpc_id          = "vpc-030180ef7b3372ec4"
  enable_irsa     = true
  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }
}

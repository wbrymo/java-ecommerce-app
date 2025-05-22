resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::<your-account-id>:role/EKS-Role"
  vpc_config {
    subnet_ids = [
      "subnet-018a0920ef1cc9d97",
      "subnet-09bdf95b8d7f564c3",
      "subnet-08eef8b9289a093e4",
      "subnet-06b173943f477146f",
      "subnet-0e933f24483da798c"
    ]
  }
}

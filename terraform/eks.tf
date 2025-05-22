
resource "aws_eks_cluster" "this" {
  name     = "java-ecomm-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      "subnet-018a0920ef1cc9d97",
      "subnet-09bdf95b8d7f564c3",
      "subnet-08eef8b9289a093e4",
      "subnet-06b173943f477146f",
      "subnet-0e933f24483da798c"
    ]
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  depends_on = [aws_iam_role.eks_cluster_role]
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Node Group Role
resource "aws_iam_role" "eks_node_group_role" {
  name = "eksNodeGroupRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_attach1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_attach2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_attach3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "java-ecomm-nodes"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = [
    "subnet-018a0920ef1cc9d97",
    "subnet-09bdf95b8d7f564c3",
    "subnet-08eef8b9289a093e4",
    "subnet-06b173943f477146f",
    "subnet-0e933f24483da798c"
  ]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

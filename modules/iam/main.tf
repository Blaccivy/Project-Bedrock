resource "aws_iam_role" "eks_cluster" {
  name = "project-bedrock-eks-cluster-role"

  tags = {
    Name = "barakat-2025-capstone"
   }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "node_group" {
  name = "project-bedrock-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# Replace with your GitHub repo info
locals {
  github_owner = "Blaccivy"  
  github_repo  = "Project-Bedrock"    
}

# IAM role for GitHub Actions OIDC
resource "aws_iam_role" "github_actions" {
  name = "github-actions-terraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::805206611230:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:sub" = "repo:${local.github_owner}/${local.github_repo}:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

# Attach a policy (example: AdministratorAccess for testing)
resource "aws_iam_role_policy_attachment" "github_actions_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

provider "aws" {
  alias  = "admin"
  region = "us-east-1"
  # Use admin account credentials here
}

resource "aws_iam_role" "read_only_cross_account" {
  provider = aws.admin
  name     = "read-only-cross-account"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::805206611230:user/bedrock-dev-view"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AWS managed ReadOnlyAccess policy
resource "aws_iam_role_policy_attachment" "read_only_attach" {
  provider  = aws.admin
  role      = aws_iam_role.read_only_cross_account.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

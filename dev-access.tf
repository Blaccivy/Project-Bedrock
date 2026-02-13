# IAM user for Bedrock developers with Read-only access

resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"

  tags = {
    Name = "barakat-2025-capstone"
   }
}

resource "aws_iam_user_login_profile" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name

  password_length = 20
  password_reset_required = true
}


# IAM policy with read-only access to EC2, EKS, and CloudWatch
resource "aws_iam_policy" "bedrock_dev_readonly" {
  name        = "BedrockDevReadOnly"
  description = "Read-only access to EC2, EKS, and CloudWatch for Bedrock developers"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          # EC2
          "ec2:Describe*",
          "elasticloadbalancing:Describe*",
          "autoscaling:Describe*",

          # EKS
          "eks:Describe*",
          "eks:List*",

          # CloudWatch / Logs
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "cloudwatch:Describe*",
          "logs:Get*",
          "logs:List*",
          "logs:Describe*",

          # IAM read access
          "iam:ListUsers",
          "iam:GetUser",
          "iam:ListGroups",
          "iam:GetGroup",
          "iam:ListRoles",
          "iam:GetRole",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "readonly" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = aws_iam_policy.bedrock_dev_readonly.arn
}

resource "aws_iam_access_key" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name
}


resource "kubernetes_role_binding_v1" "bedrock_dev_view" {
  metadata {
    name      = "bedrock-dev-view"
    namespace = "retail-app"
  }

  subject {
    kind      = "User"
    name      = "bedrock-dev-view"
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "view"
    api_group = "rbac.authorization.k8s.io"
  }
}

data "aws_caller_identity" "current" {}

# variables.tf




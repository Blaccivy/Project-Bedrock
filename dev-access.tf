# IAM user for Bedrock developers with Read-only access

resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"
}

resource "aws_iam_user_login_profile" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name

  password_length = 20
  password_reset_required = true
}


resource "aws_iam_user_policy_attachment" "readonly" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_access_key" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name
}

# Kubernetes provider to manage aws-auth config map

# data "aws_eks_cluster" "this" {
#   name = var.cluster_name
# }

# data "aws_eks_cluster_auth" "this" {
#   name = var.cluster_name
# }



# resource "kubernetes_config_map_v1" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapUsers = yamlencode([
#       {
#         userarn  = aws_iam_user.bedrock_dev_view.arn
#         username = "bedrock-dev-view"
#         groups   = ["bedrock-dev-view"]
#       }
#     ])
#   }
# }

# RBAC RoleBinding for Bedrock developers to have view access in retail-app namespace

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


# Outputs for IAM user credentials and console signin URL

output "bedrock_dev_view_access_key_id" {
  value = aws_iam_access_key.bedrock_dev_view.id
}

output "bedrock_dev_view_secret_access_key" {
  value     = aws_iam_access_key.bedrock_dev_view.secret
  sensitive = true
}

output "console_username" {
  value = aws_iam_user.bedrock_dev_view.name
}

output "console_password" {
  value     = aws_iam_user_login_profile.bedrock_dev_view.password
  sensitive = true
}

output "console_signin_url" {
  value = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
}

data "aws_caller_identity" "current" {}

# variables.tf




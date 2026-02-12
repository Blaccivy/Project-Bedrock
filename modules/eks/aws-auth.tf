# data "aws_eks_cluster" "this" {
#   name = aws_eks_cluster.this.name
# }

# data "aws_eks_cluster_auth" "this" {
#   name = aws_eks_cluster.this.name
# }

# resource "kubernetes_config_map_v1" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = var.node_group_role_arn
#         username = "system:node:{{EC2PrivateDNSName}}"
#         groups   = [
#           "system:bootstrappers",
#           "system:nodes"
#         ]
#       }
#     ])
#   }

#   depends_on = [
#     aws_eks_cluster.this
#   ]
# }

# # provider "kubernetes" {
# #   host                   = data.aws_eks_cluster.this.endpoint
# #   cluster_ca_certificate = base64decode(
# #     data.aws_eks_cluster.this.certificate_authority[0].data
# #   )
# #   token = data.aws_eks_cluster_auth.this.token
# # }

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn = module.iam.node_group_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
  }

depends_on = [
    module.eks
  ] # <-- ensures cluster is created first

}


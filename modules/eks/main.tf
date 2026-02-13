resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}



resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "bedrock-ng"
  node_role_arn  = var.node_group_role_arn
  subnet_ids     = var.private_subnets
   ami_type = "BOTTLEROCKET_x86_64"

   tags = {
    Name = "barakat-2025-capstone"
  }


  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 5
  }

 

}


resource "aws_security_group_rule" "cluster_to_nodes" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id         = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  source_security_group_id  = var.node_security_group_id
}

resource "aws_security_group_rule" "nodes_to_cluster" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id         = var.node_security_group_id
  source_security_group_id  = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "cluster_to_nodes_kubelet" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "nodes_to_cluster_kubelet" {
  type                     = "egress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = var.node_security_group_id
  source_security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}


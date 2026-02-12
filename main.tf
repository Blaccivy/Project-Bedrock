module "vpc" {
  source = "./modules/vpc"

  region = "us-east-1"
  vpc_name          = "project-bedrock-vpc"
  cidr              = "10.0.0.0/16"
  # module will create and output subnet IDs
}

module "iam" {
  source = "./modules/iam"
}

module "lambda" {
  source = "./modules/lambda"
}

module "eks" {
  source = "./modules/eks"

  cluster_name      = "project-bedrock-cluster"
  cluster_version   = "1.34"

  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnet_ids

  cluster_role_arn  = module.iam.eks_cluster_role_arn
  node_role_arn     = module.iam.node_group_role_arn
  
  node_group_role_arn     = module.iam.node_group_role_arn
  
  node_security_group_id = module.vpc.eks_node_sg_id
  # cluster security group is produced by the EKS resource inside this module

  depends_on = [
    module.iam
  ]
}

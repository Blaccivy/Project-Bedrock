output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID hosting the EKS cluster"
  value       = module.vpc.vpc_id
}

output "assests_bucket_name" {
    description = "S3 bucket for application assets"
  value = aws_s3_bucket.assets.bucket
}
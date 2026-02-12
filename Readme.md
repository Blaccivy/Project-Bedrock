## Project Bedrock – EKS Infrastructure

This repository provisions a secure Amazon EKS cluster using Terraform.

### Features
- Remote state with S3 + DynamoDB
- Private EKS cluster (no public API)
- Least-privilege IAM roles
- Multi-AZ VPC with public & private subnets
- Managed node groups

### Usage
```bash
terraform init
terraform plan
terraform apply

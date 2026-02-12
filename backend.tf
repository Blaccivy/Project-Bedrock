terraform {
  backend "s3" {
    bucket       = "bedrock-assets-tf-state"
    key          = "eks/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

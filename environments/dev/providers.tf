provider "aws" {
  region = local.aws_region

  default_tags {
    tags = {
      Project     = local.project
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}

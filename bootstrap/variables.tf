variable "aws_region" {
  description = "AWS region to create the Terraform state bucket in."
  type        = string
  default     = "eu-west-1"
}

variable "state_bucket_name" {
  description = "Globally unique name for the S3 bucket that stores Terraform state. e.g. \"acme-tfstate-123456789012\"."
  type        = string
}

variable "tags" {
  description = "Tags applied to the state bucket."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "terraform-remote-state"
  }
}

variable "project" {
  description = "Project/organization short name used across all accounts."
  type        = string
  default     = "acme"
}

variable "aws_region" {
  description = "AWS region to deploy into for every account."
  type        = string
  default     = "eu-west-1"
}

# Replace these placeholders with your real AWS account IDs. They are referenced
# by the cross-account role ARNs in providers.tf.
variable "dev_account_id" {
  description = "AWS account ID for the dev environment."
  type        = string
  default     = "111111111111"
}

variable "staging_account_id" {
  description = "AWS account ID for the staging environment."
  type        = string
  default     = "222222222222"
}

variable "prod_account_id" {
  description = "AWS account ID for the prod environment."
  type        = string
  default     = "333333333333"
}

variable "deployment_role_name" {
  description = "Name of the IAM role Terraform assumes in each member account (must already exist, e.g. created by AWS Organizations as OrganizationAccountAccessRole)."
  type        = string
  default     = "OrganizationAccountAccessRole"
}

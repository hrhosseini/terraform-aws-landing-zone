output "state_bucket_name" {
  description = "Name of the S3 bucket created to store Terraform state. Use this as the `bucket` value in each environment's backend block."
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "ARN of the Terraform state bucket."
  value       = aws_s3_bucket.terraform_state.arn
}

output "region" {
  description = "Region the state bucket was created in. Use this as the `region` value in each environment's backend block."
  value       = var.aws_region
}

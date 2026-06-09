output "dev_vpc_id" {
  description = "VPC ID in the dev account."
  value       = module.dev.vpc_id
}

output "staging_vpc_id" {
  description = "VPC ID in the staging account."
  value       = module.staging.vpc_id
}

output "prod_vpc_id" {
  description = "VPC ID in the prod account."
  value       = module.prod.vpc_id
}

output "prod_cloudtrail_arn" {
  description = "CloudTrail ARN in the prod account."
  value       = module.prod.cloudtrail_arn
}

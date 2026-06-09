output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.landing_zone.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.landing_zone.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.landing_zone.private_subnet_ids
}

output "admin_role_arn" {
  description = "ARN of the baseline admin role."
  value       = module.landing_zone.admin_role_arn
}

output "log_bucket_id" {
  description = "Central log bucket name."
  value       = module.landing_zone.log_bucket_id
}

output "cloudtrail_arn" {
  description = "CloudTrail trail ARN."
  value       = module.landing_zone.cloudtrail_arn
}

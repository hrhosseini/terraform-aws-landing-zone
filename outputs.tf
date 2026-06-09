# --- Networking ---
output "vpc_id" {
  description = "ID of the VPC."
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = module.networking.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.networking.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways (empty when disabled)."
  value       = module.networking.nat_gateway_ids
}

# --- IAM ---
output "admin_role_arn" {
  description = "ARN of the baseline admin role (null when not created)."
  value       = try(module.iam[0].admin_role_arn, null)
}

output "readonly_role_arn" {
  description = "ARN of the baseline read-only role (null when not created)."
  value       = try(module.iam[0].readonly_role_arn, null)
}

output "developer_role_arn" {
  description = "ARN of the developer role (null when not created)."
  value       = try(module.iam[0].developer_role_arn, null)
}

# --- Logging ---
output "log_bucket_id" {
  description = "Name of the central log bucket."
  value       = module.logging.bucket_id
}

output "log_bucket_arn" {
  description = "ARN of the central log bucket."
  value       = module.logging.bucket_arn
}

# --- Security ---
output "kms_key_arn" {
  description = "ARN of the log-encryption KMS key (null when not created)."
  value       = module.security.kms_key_arn
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail trail (null when disabled)."
  value       = module.security.cloudtrail_arn
}

output "cloudtrail_bucket_id" {
  description = "Name of the CloudTrail S3 bucket (null when disabled)."
  value       = module.security.cloudtrail_bucket_id
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector (null when disabled)."
  value       = module.security.guardduty_detector_id
}

# --- Monitoring ---
output "alarm_sns_topic_arn" {
  description = "ARN of the alarm SNS topic (null when monitoring disabled)."
  value       = try(module.monitoring[0].sns_topic_arn, null)
}

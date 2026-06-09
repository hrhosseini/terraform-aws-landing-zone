output "vpc_id" {
  description = "VPC ID."
  value       = module.landing_zone.vpc_id
}

output "log_bucket_id" {
  description = "Central log bucket name."
  value       = module.landing_zone.log_bucket_id
}

output "cloudtrail_arn" {
  description = "CloudTrail trail ARN."
  value       = module.landing_zone.cloudtrail_arn
}

output "guardduty_detector_id" {
  description = "GuardDuty detector ID."
  value       = module.landing_zone.guardduty_detector_id
}

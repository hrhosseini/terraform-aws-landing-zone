output "kms_key_arn" {
  description = "ARN of the KMS key used for log encryption (null when not created)."
  value       = try(aws_kms_key.this[0].arn, null)
}

output "kms_key_id" {
  description = "ID of the KMS key (null when not created)."
  value       = try(aws_kms_key.this[0].key_id, null)
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail trail (null when disabled)."
  value       = try(aws_cloudtrail.this[0].arn, null)
}

output "cloudtrail_bucket_id" {
  description = "Name of the CloudTrail S3 bucket (null when disabled)."
  value       = try(aws_s3_bucket.trail[0].id, null)
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector (null when disabled)."
  value       = try(aws_guardduty_detector.this[0].id, null)
}

output "config_recorder_name" {
  description = "Name of the AWS Config recorder (null when disabled)."
  value       = try(aws_config_configuration_recorder.this[0].name, null)
}

output "securityhub_account_id" {
  description = "ID of the Security Hub account resource (null when disabled)."
  value       = try(aws_securityhub_account.this[0].id, null)
}

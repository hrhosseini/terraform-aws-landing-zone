output "sns_topic_arn" {
  description = "ARN of the alarm SNS topic (null when not created)."
  value       = try(aws_sns_topic.this[0].arn, null)
}

output "alarm_names" {
  description = "Names of the generic CloudWatch alarms created."
  value       = [for a in aws_cloudwatch_metric_alarm.this : a.alarm_name]
}

output "billing_alarm_name" {
  description = "Name of the billing alarm (null when disabled)."
  value       = try(aws_cloudwatch_metric_alarm.billing[0].alarm_name, null)
}

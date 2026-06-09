variable "name_prefix" {
  description = "Prefix applied to the names of monitoring resources (e.g. \"acme-dev\")."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}

variable "create_sns_topic" {
  description = "Create an SNS topic to receive alarm notifications."
  type        = bool
  default     = true
}

variable "alarm_email_addresses" {
  description = "Email addresses subscribed to the alarm SNS topic. Each subscriber must confirm via email. Use placeholders, never commit real addresses you do not own."
  type        = list(string)
  default     = []
}

variable "alarms" {
  description = <<-EOT
    Map of CloudWatch metric alarms to create. Key is the alarm name suffix.
    Example:
      {
        high-cpu = {
          namespace           = "AWS/EC2"
          metric_name         = "CPUUtilization"
          statistic           = "Average"
          comparison_operator = "GreaterThanThreshold"
          threshold           = 80
          period              = 300
          evaluation_periods  = 2
          dimensions          = { InstanceId = "i-0123456789abcdef0" }
        }
      }
  EOT
  type = map(object({
    namespace           = string
    metric_name         = string
    statistic           = optional(string, "Average")
    comparison_operator = optional(string, "GreaterThanThreshold")
    threshold           = number
    period              = optional(number, 300)
    evaluation_periods  = optional(number, 1)
    description         = optional(string, "")
    dimensions          = optional(map(string), {})
    treat_missing_data  = optional(string, "missing")
  }))
  default = {}
}

variable "enable_billing_alarm" {
  description = "Create a billing (EstimatedCharges) alarm. NOTE: billing metrics only exist in us-east-1, so the AWS provider passed to this module must target us-east-1 for this alarm to fire."
  type        = bool
  default     = false
}

variable "billing_alarm_threshold_usd" {
  description = "USD threshold for the billing alarm."
  type        = number
  default     = 50
}

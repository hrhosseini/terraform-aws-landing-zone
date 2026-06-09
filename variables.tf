# ===========================================================================
# General
# ===========================================================================
variable "project" {
  description = "Project/organization short name. Used as the first part of every resource name."
  type        = string
  default     = "landing-zone"
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod). Used in resource names and tags."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "environment must contain only lowercase letters, numbers and hyphens."
  }
}

variable "aws_region" {
  description = "AWS region to deploy regional resources into."
  type        = string
  default     = "eu-west-1"
}

variable "tags" {
  description = "Additional tags merged into the default tags applied to every resource."
  type        = map(string)
  default     = {}
}

# ===========================================================================
# Networking
# ===========================================================================
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of Availability Zones to spread subnets across."
  type        = number
  default     = 2
}

variable "availability_zones" {
  description = "Explicit list of AZs. When empty, the first az_count AZs in the region are used."
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (one per AZ). Empty = auto-derive from vpc_cidr."
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (one per AZ). Empty = auto-derive from vpc_cidr."
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Create NAT Gateway(s) for private subnet egress. COST: hourly + data charges. Disabled by default."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use a single shared NAT Gateway instead of one per AZ (cheaper, not HA)."
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs to CloudWatch Logs. COST: CloudWatch Logs charges apply."
  type        = bool
  default     = false
}

# ===========================================================================
# IAM
# ===========================================================================
variable "create_iam_baseline" {
  description = "Create the baseline IAM roles (admin / read-only / optional developer)."
  type        = bool
  default     = true
}

variable "iam_trusted_principal_arns" {
  description = "Principal ARNs allowed to assume the baseline roles. Empty = current account root."
  type        = list(string)
  default     = []
}

variable "iam_require_mfa" {
  description = "Require MFA to assume the baseline roles."
  type        = bool
  default     = true
}

variable "create_developer_role" {
  description = "Also create a developer role (PowerUserAccess)."
  type        = bool
  default     = false
}

# ===========================================================================
# Logging
# ===========================================================================
variable "log_bucket_name" {
  description = "Override name for the central log bucket. Empty = derived as <project>-<env>-logs-<account_id>."
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "Days before central log objects are expired. 0 = never."
  type        = number
  default     = 365
}

variable "force_destroy_buckets" {
  description = "Allow Terraform to delete log/trail buckets that still contain objects. Keep false in production."
  type        = bool
  default     = false
}

# ===========================================================================
# Security
# ===========================================================================
variable "enable_cloudtrail" {
  description = "Enable a multi-region CloudTrail trail with a dedicated hardened bucket."
  type        = bool
  default     = true
}

variable "cloudtrail_bucket_name" {
  description = "Override name for the CloudTrail bucket. Empty = derived as <project>-<env>-cloudtrail-<account_id>."
  type        = string
  default     = ""
}

variable "create_kms_key" {
  description = "Create a customer-managed KMS key to encrypt CloudTrail logs."
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Enable AWS Config. COST: per configuration item recorded."
  type        = bool
  default     = false
}

variable "config_bucket_name" {
  description = "Override name for the AWS Config bucket. Empty = derived as <project>-<env>-config-<account_id>."
  type        = string
  default     = ""
}

variable "enable_guardduty" {
  description = "Enable Amazon GuardDuty. COST: per analyzed event/log volume."
  type        = bool
  default     = false
}

variable "enable_securityhub" {
  description = "Enable AWS Security Hub. COST: per check and finding."
  type        = bool
  default     = false
}

# ===========================================================================
# Monitoring
# ===========================================================================
variable "create_monitoring" {
  description = "Create the monitoring baseline (SNS topic + alarms)."
  type        = bool
  default     = true
}

variable "alarm_email_addresses" {
  description = "Email addresses subscribed to the alarm SNS topic. Each must confirm via email."
  type        = list(string)
  default     = []
}

variable "alarms" {
  description = "Map of custom CloudWatch metric alarms. See modules/monitoring/variables.tf for the object shape."
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
  description = "Create a billing alarm in us-east-1 via the aliased provider."
  type        = bool
  default     = false
}

variable "billing_alarm_threshold_usd" {
  description = "USD threshold for the billing alarm."
  type        = number
  default     = 50
}

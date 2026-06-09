variable "name_prefix" {
  description = "Prefix applied to the names of security resources (e.g. \"acme-dev\")."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}

# --- KMS ---------------------------------------------------------------------
variable "create_kms_key" {
  description = "Create a customer-managed KMS key used to encrypt CloudTrail logs (and reusable for other log encryption)."
  type        = bool
  default     = true
}

variable "kms_deletion_window_days" {
  description = "Waiting period (in days) before a scheduled KMS key deletion completes."
  type        = number
  default     = 30
}

# --- CloudTrail --------------------------------------------------------------
variable "enable_cloudtrail" {
  description = "Enable an account-wide, multi-region CloudTrail trail."
  type        = bool
  default     = true
}

variable "cloudtrail_bucket_name" {
  description = "Name of the dedicated S3 bucket that stores CloudTrail logs. Required when enable_cloudtrail is true. Must be globally unique."
  type        = string
  default     = null
}

variable "cloudtrail_force_destroy" {
  description = "Allow Terraform to destroy the CloudTrail bucket even when it contains logs. Keep false in production."
  type        = bool
  default     = false
}

variable "cloudtrail_retention_days" {
  description = "Days after which CloudTrail log objects are deleted from S3. Set to 0 to keep forever."
  type        = number
  default     = 365
}

# --- AWS Config (optional, COST) --------------------------------------------
variable "enable_config" {
  description = "Enable AWS Config recorder. COST: AWS Config charges per configuration item recorded."
  type        = bool
  default     = false
}

variable "config_bucket_name" {
  description = "Name of the S3 bucket for AWS Config snapshots. Required when enable_config is true. Must be globally unique."
  type        = string
  default     = null
}

# --- GuardDuty (optional, COST) ---------------------------------------------
variable "enable_guardduty" {
  description = "Enable Amazon GuardDuty threat detection. COST: GuardDuty is billed on analyzed events/logs."
  type        = bool
  default     = false
}

# --- Security Hub (optional, COST) ------------------------------------------
variable "enable_securityhub" {
  description = "Enable AWS Security Hub. COST: Security Hub is billed per security check and finding ingested."
  type        = bool
  default     = false
}

variable "securityhub_enable_default_standards" {
  description = "Subscribe to the default Security Hub standards (e.g. AWS Foundational Security Best Practices)."
  type        = bool
  default     = true
}

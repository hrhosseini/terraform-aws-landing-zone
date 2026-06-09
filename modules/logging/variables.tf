variable "bucket_name" {
  description = "Name of the centralized log bucket. Must be globally unique across all of AWS S3."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "ARN of a KMS key used to encrypt objects at rest. When null, SSE-S3 (AES256) is used instead."
  type        = string
  default     = null
}

variable "enable_lifecycle" {
  description = "Enable lifecycle rules to transition and expire old log objects to control storage cost."
  type        = bool
  default     = true
}

variable "transition_to_ia_days" {
  description = "Days after which objects transition to STANDARD_IA storage."
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Days after which objects transition to GLACIER storage."
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "Days after which objects are permanently deleted. Set to 0 to disable expiration."
  type        = number
  default     = 365
}

variable "force_destroy" {
  description = "Allow Terraform to destroy the bucket even when it still contains objects. Keep false in production to avoid accidental log loss."
  type        = bool
  default     = false
}

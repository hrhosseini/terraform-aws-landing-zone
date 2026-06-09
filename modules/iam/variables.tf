variable "name_prefix" {
  description = "Prefix applied to the names of all IAM roles (e.g. \"acme-dev\")."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}

variable "trusted_principal_arns" {
  description = "IAM principal ARNs (users/roles/accounts) allowed to assume the baseline roles. If empty, the current account root is trusted, meaning any IAM principal in this account with sts:AssumeRole permission can assume them."
  type        = list(string)
  default     = []
}

variable "require_mfa" {
  description = "Require multi-factor authentication when assuming the baseline roles."
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) for the assumed roles. Between 3600 (1h) and 43200 (12h)."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }
}

variable "create_admin_role" {
  description = "Create an administrator role (AdministratorAccess)."
  type        = bool
  default     = true
}

variable "create_readonly_role" {
  description = "Create a read-only role (ReadOnlyAccess)."
  type        = bool
  default     = true
}

variable "create_developer_role" {
  description = "Create a developer role (PowerUserAccess by default)."
  type        = bool
  default     = false
}

variable "developer_managed_policy_arns" {
  description = "Managed policy ARNs attached to the developer role. Defaults to PowerUserAccess."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}

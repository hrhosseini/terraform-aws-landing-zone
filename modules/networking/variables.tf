variable "name_prefix" {
  description = "Prefix applied to the names of all networking resources (e.g. \"acme-dev\")."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "List of Availability Zones to spread subnets across. If empty, the first `az_count` AZs in the region are used automatically."
  type        = list(string)
  default     = []
}

variable "az_count" {
  description = "Number of Availability Zones to use when `availability_zones` is not set explicitly. Ignored when `availability_zones` is provided."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 1 && var.az_count <= 6
    error_message = "az_count must be between 1 and 6."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets. One per AZ. If empty, subnets are derived automatically from vpc_cidr."
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets. One per AZ. If empty, subnets are derived automatically from vpc_cidr."
  type        = list(string)
  default     = []
}

variable "enable_dns_support" {
  description = "Whether DNS resolution is enabled for the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether instances launched in the VPC receive public DNS hostnames."
  type        = bool
  default     = true
}

# --- NAT Gateway (COST WARNING) ---------------------------------------------
# NAT Gateways are billed per hour AND per GB processed. They are disabled by
# default to keep this landing zone free to stand up. Enable only when private
# subnets need outbound internet access.
variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway(s) so private subnets can reach the internet. COST: NAT Gateways incur hourly + data processing charges."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "When enable_nat_gateway is true, create a single shared NAT Gateway instead of one per AZ. Cheaper, but not highly available."
  type        = bool
  default     = true
}

# --- VPC Flow Logs (optional) -----------------------------------------------
variable "enable_flow_logs" {
  description = "Whether to enable VPC Flow Logs to CloudWatch Logs. COST: CloudWatch Logs ingestion/storage charges apply."
  type        = bool
  default     = false
}

variable "flow_logs_retention_days" {
  description = "Retention period in days for the VPC Flow Logs CloudWatch log group."
  type        = number
  default     = 90
}

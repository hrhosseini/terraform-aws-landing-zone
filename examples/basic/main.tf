# ===========================================================================
# Basic example — a single-account landing zone with only the free baseline
# enabled: VPC (no NAT), IAM roles, secure log + CloudTrail buckets, KMS,
# and a monitoring SNS topic. All paid add-ons (NAT, GuardDuty, Config,
# Security Hub, flow logs) are left OFF.
#
# Uses the default LOCAL backend — state is written to ./terraform.tfstate.
# ===========================================================================

module "landing_zone" {
  source = "../../"

  project     = var.project
  environment = var.environment
  aws_region  = var.aws_region

  # Networking: small VPC, no NAT (free).
  vpc_cidr           = "10.0.0.0/16"
  az_count           = 2
  enable_nat_gateway = false
  enable_flow_logs   = false

  # IAM baseline.
  create_iam_baseline = true
  iam_require_mfa     = true

  # Security baseline: CloudTrail + KMS on, paid services off.
  enable_cloudtrail  = true
  create_kms_key     = true
  enable_config      = false
  enable_guardduty   = false
  enable_securityhub = false

  # Monitoring baseline.
  create_monitoring    = true
  enable_billing_alarm = false
}

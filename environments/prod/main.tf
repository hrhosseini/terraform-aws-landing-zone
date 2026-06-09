# ===========================================================================
# PROD environment. Hardened: NAT per-AZ (HA), flow logs, GuardDuty, Config,
# Security Hub, MFA required. Buckets are NOT force-destroyable.
#
# COST WARNING: this environment enables several paid services. Review
# docs/costs.md before applying.
# ===========================================================================

locals {
  project    = "acme"
  aws_region = "eu-west-1"
}

module "landing_zone" {
  source = "../../"

  project     = local.project
  environment = "prod"
  aws_region  = local.aws_region

  vpc_cidr           = "10.30.0.0/16"
  az_count           = 3
  enable_nat_gateway = true
  single_nat_gateway = false # one NAT per AZ for high availability
  enable_flow_logs   = true

  create_iam_baseline   = true
  create_developer_role = false
  iam_require_mfa       = true

  enable_cloudtrail  = true
  create_kms_key     = true
  enable_config      = true
  enable_guardduty   = true
  enable_securityhub = true

  create_monitoring     = true
  alarm_email_addresses = [] # e.g. ["sre-oncall@example.com"]

  force_destroy_buckets = false
}

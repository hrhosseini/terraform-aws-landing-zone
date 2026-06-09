# ===========================================================================
# STAGING environment. Closer to prod: NAT (single) + flow logs on, paid
# security services still off to control cost.
# ===========================================================================

locals {
  project    = "acme"
  aws_region = "eu-west-1"
}

module "landing_zone" {
  source = "../../"

  project     = local.project
  environment = "staging"
  aws_region  = local.aws_region

  vpc_cidr           = "10.20.0.0/16"
  az_count           = 2
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_flow_logs   = true

  create_iam_baseline   = true
  create_developer_role = true
  iam_require_mfa       = true

  enable_cloudtrail  = true
  create_kms_key     = true
  enable_config      = false
  enable_guardduty   = true
  enable_securityhub = false

  create_monitoring = true
}

# ===========================================================================
# DEV environment. Lean and cheap: no NAT, no paid security add-ons.
# State is stored remotely (see backend.tf). Edit the values below to taste.
# ===========================================================================

locals {
  project    = "acme"
  aws_region = "eu-west-1"
}

module "landing_zone" {
  source = "../../"

  project     = local.project
  environment = "dev"
  aws_region  = local.aws_region

  vpc_cidr           = "10.10.0.0/16"
  az_count           = 2
  enable_nat_gateway = false
  enable_flow_logs   = false

  create_iam_baseline   = true
  create_developer_role = true
  iam_require_mfa       = true

  enable_cloudtrail  = true
  create_kms_key     = true
  enable_config      = false
  enable_guardduty   = false
  enable_securityhub = false

  create_monitoring = true
}

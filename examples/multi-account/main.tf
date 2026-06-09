# ===========================================================================
# Multi-account example — the SAME landing zone module deployed into three
# separate AWS accounts (dev / staging / prod) by passing a different aliased
# provider to each instance.
#
# Production hardens the baseline: NAT + flow logs + GuardDuty + Config on.
# Dev/staging stay lean to control cost. Adjust to taste.
#
# NOTE: This single state file manages all three accounts. In a real setup you
# would more commonly give each account its own state (see environments/), but
# this shows the wiring clearly in one place.
# ===========================================================================

module "dev" {
  source = "../../"

  providers = { aws = aws.dev }

  project            = var.project
  environment        = "dev"
  aws_region         = var.aws_region
  vpc_cidr           = "10.10.0.0/16"
  enable_nat_gateway = false
  enable_guardduty   = false
  enable_config      = false
}

module "staging" {
  source = "../../"

  providers = { aws = aws.staging }

  project            = var.project
  environment        = "staging"
  aws_region         = var.aws_region
  vpc_cidr           = "10.20.0.0/16"
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_flow_logs   = true
}

module "prod" {
  source = "../../"

  providers = { aws = aws.prod }

  project            = var.project
  environment        = "prod"
  aws_region         = var.aws_region
  vpc_cidr           = "10.30.0.0/16"
  enable_nat_gateway = true
  single_nat_gateway = false # one NAT per AZ for high availability
  enable_flow_logs   = true
  enable_guardduty   = true
  enable_config      = true
  enable_securityhub = true
  iam_require_mfa    = true
}

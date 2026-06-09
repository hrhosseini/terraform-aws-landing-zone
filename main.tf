# ===========================================================================
# AWS Landing Zone — root composition
# Wires the reusable building-block modules into a single account baseline.
# Tags are applied globally via the provider default_tags block (see
# providers.tf / locals.tf), so they are not threaded into every module.
# ===========================================================================

module "networking" {
  source = "./modules/networking"

  name_prefix          = local.name_prefix
  tags                 = local.common_tags
  vpc_cidr             = var.vpc_cidr
  az_count             = var.az_count
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_flow_logs     = var.enable_flow_logs
}

module "iam" {
  source = "./modules/iam"
  count  = var.create_iam_baseline ? 1 : 0

  name_prefix            = local.name_prefix
  tags                   = local.common_tags
  trusted_principal_arns = var.iam_trusted_principal_arns
  require_mfa            = var.iam_require_mfa
  create_developer_role  = var.create_developer_role
}

module "logging" {
  source = "./modules/logging"

  bucket_name     = local.log_bucket_name
  tags            = local.common_tags
  kms_key_arn     = var.create_kms_key ? module.security.kms_key_arn : null
  expiration_days = var.log_retention_days
  force_destroy   = var.force_destroy_buckets
}

module "security" {
  source = "./modules/security"

  name_prefix               = local.name_prefix
  tags                      = local.common_tags
  create_kms_key            = var.create_kms_key
  enable_cloudtrail         = var.enable_cloudtrail
  cloudtrail_bucket_name    = local.cloudtrail_bucket_name
  cloudtrail_force_destroy  = var.force_destroy_buckets
  cloudtrail_retention_days = var.log_retention_days
  enable_config             = var.enable_config
  config_bucket_name        = local.config_bucket_name
  enable_guardduty          = var.enable_guardduty
  enable_securityhub        = var.enable_securityhub
}

module "monitoring" {
  source = "./modules/monitoring"
  count  = var.create_monitoring ? 1 : 0

  name_prefix                 = local.name_prefix
  tags                        = local.common_tags
  alarm_email_addresses       = var.alarm_email_addresses
  alarms                      = var.alarms
  enable_billing_alarm        = var.enable_billing_alarm
  billing_alarm_threshold_usd = var.billing_alarm_threshold_usd
}

data "aws_caller_identity" "current" {}

locals {
  # Consistent naming: <project>-<environment> prefixes every resource.
  name_prefix = "${var.project}-${var.environment}"

  account_id = data.aws_caller_identity.current.account_id

  # Tags applied to everything via the provider default_tags block.
  common_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags,
  )

  # Bucket names must be globally unique; default to including the account ID.
  log_bucket_name        = var.log_bucket_name != "" ? var.log_bucket_name : "${local.name_prefix}-logs-${local.account_id}"
  cloudtrail_bucket_name = var.cloudtrail_bucket_name != "" ? var.cloudtrail_bucket_name : "${local.name_prefix}-cloudtrail-${local.account_id}"
  config_bucket_name     = var.config_bucket_name != "" ? var.config_bucket_name : "${local.name_prefix}-config-${local.account_id}"
}

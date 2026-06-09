# ---------------------------------------------------------------------------
# AWS Security Hub (optional) — aggregates security findings.
# COST: billed per security check and per finding ingested.
# ---------------------------------------------------------------------------
resource "aws_securityhub_account" "this" {
  count = var.enable_securityhub ? 1 : 0

  enable_default_standards = var.securityhub_enable_default_standards
}

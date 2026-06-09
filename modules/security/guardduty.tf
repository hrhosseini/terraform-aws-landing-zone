# ---------------------------------------------------------------------------
# Amazon GuardDuty (optional) — managed threat detection.
# COST: billed on the volume of analyzed events and logs.
# ---------------------------------------------------------------------------
resource "aws_guardduty_detector" "this" {
  count = var.enable_guardduty ? 1 : 0

  enable = true

  tags = var.tags
}

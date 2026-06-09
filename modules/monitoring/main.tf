locals {
  sns_topic_arns = var.create_sns_topic ? [aws_sns_topic.this[0].arn] : []
}

# --- SNS topic for notifications --------------------------------------------
resource "aws_sns_topic" "this" {
  count = var.create_sns_topic ? 1 : 0

  name = "${var.name_prefix}-alarms"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  for_each = var.create_sns_topic ? toset(var.alarm_email_addresses) : []

  topic_arn = aws_sns_topic.this[0].arn
  protocol  = "email"
  endpoint  = each.value
}

# --- Generic metric alarms --------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = var.alarms

  alarm_name          = "${var.name_prefix}-${each.key}"
  namespace           = each.value.namespace
  metric_name         = each.value.metric_name
  statistic           = each.value.statistic
  comparison_operator = each.value.comparison_operator
  threshold           = each.value.threshold
  period              = each.value.period
  evaluation_periods  = each.value.evaluation_periods
  dimensions          = each.value.dimensions
  treat_missing_data  = each.value.treat_missing_data
  alarm_description   = each.value.description

  alarm_actions = local.sns_topic_arns
  ok_actions    = local.sns_topic_arns

  tags = var.tags
}

# --- Billing alarm (optional) -----------------------------------------------
# Billing metrics are published only in us-east-1.
resource "aws_cloudwatch_metric_alarm" "billing" {
  count = var.enable_billing_alarm ? 1 : 0

  alarm_name          = "${var.name_prefix}-estimated-charges"
  namespace           = "AWS/Billing"
  metric_name         = "EstimatedCharges"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.billing_alarm_threshold_usd
  period              = 21600 # 6 hours
  evaluation_periods  = 1
  dimensions = {
    Currency = "USD"
  }
  alarm_description  = "Estimated AWS charges exceeded $${var.billing_alarm_threshold_usd}."
  treat_missing_data = "missing"

  alarm_actions = local.sns_topic_arns
  ok_actions    = local.sns_topic_arns

  tags = var.tags
}

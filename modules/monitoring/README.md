# Module: monitoring

Creates an optional SNS topic for notifications, a map-driven set of custom
CloudWatch metric alarms, and an optional billing alarm.

## Usage

```hcl
module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix           = "acme-dev"
  alarm_email_addresses = ["alerts@example.com"]

  alarms = {
    high-cpu = {
      namespace   = "AWS/EC2"
      metric_name = "CPUUtilization"
      threshold   = 80
      dimensions  = { InstanceId = "i-0123456789abcdef0" }
    }
  }

  tags = { Project = "acme" }
}
```

## Key inputs

| Name | Default | Description |
|------|---------|-------------|
| `name_prefix` | _(required)_ | Prefix for resource names |
| `create_sns_topic` | `true` | SNS topic for alarm actions |
| `alarm_email_addresses` | `[]` | Email subscribers (must confirm) |
| `alarms` | `{}` | Map of metric alarms (see variable for shape) |
| `enable_billing_alarm` | `false` | EstimatedCharges alarm |
| `billing_alarm_threshold_usd` | `50` | Billing threshold |

## Key outputs

`sns_topic_arn`, `alarm_names`, `billing_alarm_name`.

## Notes

`AWS/Billing` metrics exist **only in us-east-1**, so the billing alarm only
works when this module is deployed in that region.

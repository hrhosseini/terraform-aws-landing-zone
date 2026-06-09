# Module: security

Account security baseline: a customer-managed KMS key, a multi-region CloudTrail
trail with its own hardened bucket, and optional AWS Config, GuardDuty, and
Security Hub. Each optional service is independently toggled and **off by
default**.

## Usage

```hcl
module "security" {
  source = "../../modules/security"

  name_prefix            = "acme-dev"
  cloudtrail_bucket_name = "acme-dev-cloudtrail-123456789012"  # globally unique
  create_kms_key         = true
  enable_cloudtrail      = true
  enable_guardduty       = false   # paid
  enable_config          = false   # paid
  enable_securityhub     = false   # paid
  tags                   = { Project = "acme" }
}
```

## Key inputs

| Name | Default | Description |
|------|---------|-------------|
| `name_prefix` | _(required)_ | Prefix for resource names |
| `create_kms_key` | `true` | KMS key (rotation on) for log encryption |
| `enable_cloudtrail` | `true` | Multi-region trail + dedicated bucket |
| `cloudtrail_bucket_name` | `null` | Required when CloudTrail enabled |
| `cloudtrail_retention_days` | `365` | Expire trail logs (0 = keep) |
| `enable_config` | `false` | AWS Config recorder (**paid**) |
| `config_bucket_name` | `null` | Required when Config enabled |
| `enable_guardduty` | `false` | GuardDuty detector (**paid**) |
| `enable_securityhub` | `false` | Security Hub (**paid**) |

## Key outputs

`kms_key_arn`, `cloudtrail_arn`, `cloudtrail_bucket_id`,
`guardduty_detector_id`, `config_recorder_name`, `securityhub_account_id`.

## Notes

GuardDuty, Security Hub, and the Config recorder are **per-account-per-region
singletons** — only one stack should manage each in a given region. See
[docs/costs.md](../../docs/costs.md) and
[docs/troubleshooting.md](../../docs/troubleshooting.md).

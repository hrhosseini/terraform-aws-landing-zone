# Cost Guide

> Prices below are **rough, region-dependent** ballparks for orientation only.
> Always check the [official AWS pricing pages](https://aws.amazon.com/pricing/)
> and your own bill. This project is configured so that **nothing with an hourly
> charge is enabled by default**.

## Free / near-free by default

| Resource | Cost |
|----------|------|
| VPC, subnets, route tables, Internet Gateway | Free |
| IAM roles | Free |
| S3 buckets (state, logs, CloudTrail) | Pennies/month for small log volumes |
| KMS customer-managed key | ~$1/month per key + per-request charges |
| CloudTrail (first management-event trail) | Free for management events; S3 storage applies |
| SNS topic | Free until you publish/deliver at volume |
| CloudWatch alarms | A few standard alarms are within/near the free tier |

A default deployment (basic example / `dev` environment) therefore costs on the
order of **~$1–2/month**, dominated by the KMS key.

## Opt-in, paid features

| Feature | Variable | Typical cost driver |
|---------|----------|---------------------|
| NAT Gateway | `enable_nat_gateway` | **Hourly** per gateway (~$0.045/h ≈ $32/mo each) **plus** per-GB data processed |
| NAT per-AZ (HA) | `single_nat_gateway = false` | Multiplies the above by the number of AZs |
| VPC Flow Logs | `enable_flow_logs` | CloudWatch Logs ingestion + storage per GB |
| AWS Config | `enable_config` | Per configuration item recorded |
| GuardDuty | `enable_guardduty` | Per GB of analyzed logs/events |
| Security Hub | `enable_securityhub` | Per security check + per finding ingested |

### Biggest surprise: NAT Gateway
A single NAT Gateway left running is ~$32/month **before** any data charges.
Per-AZ NAT in a 3-AZ prod setup is ~$96/month baseline. Keep it off unless
private subnets genuinely need outbound internet.

## Controlling cost

- Leave paid toggles `false` in `dev`; enable selectively in `staging`/`prod`.
- Use `single_nat_gateway = true` for non-prod when you do need NAT.
- Set lifecycle/retention (`log_retention_days`) to expire old logs.
- Enable the **billing alarm** for an early warning:
  ```hcl
  # deploy this stack in us-east-1 (where billing metrics live)
  enable_billing_alarm        = true
  billing_alarm_threshold_usd = 50
  alarm_email_addresses       = ["alerts@example.com"]
  ```
- Run `terraform destroy` on throwaway environments when you are done.

## Estimating before apply

```bash
terraform plan      # review exactly what will be created
# optional, third-party:
# infracost breakdown --path .
```

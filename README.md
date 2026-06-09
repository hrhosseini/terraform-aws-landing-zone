# terraform-aws-landing-zone

Setting up a new AWS account always starts with the same chores: a VPC, some IAM
roles, CloudTrail, a place to put logs, a bit of monitoring. This repo does that
groundwork for you. Clone it, set a handful of variables, and you get a secure
account baseline you can actually build on — networking, IAM, centralized
logging, CloudTrail, KMS encryption, optional threat detection, and monitoring.

The defaults are deliberately safe and cheap: nothing public, encryption on
everywhere, and every paid service switched **off** until you ask for it.

> ⚠️ **Heads up — this creates real AWS resources.** A few optional features cost
> money once enabled, so skim [docs/costs.md](docs/costs.md) before you apply.
> And please don't commit real secrets, account IDs, or state files — see
> [Security notes](#security-notes).

---

## What this project does

Think of it as a tidy starting point for a well-architected AWS account (or a
fleet of them). Each piece — networking, IAM, security, logging, monitoring — is
its own small Terraform module, and the repo root stitches them together into one
landing zone. Deploy it per environment (dev / staging / prod), per account, or
both.

## Architecture overview

```
                          ┌─────────────────────────────────────────┐
                          │              AWS Account                 │
                          │                                          │
   ┌──────────┐           │   ┌────────────┐     ┌───────────────┐  │
   │ Terraform│──apply──▶ │   │ Networking │     │ IAM baseline  │  │
   │   CLI    │           │   │ VPC/subnets│     │ admin/ro/dev  │  │
   └──────────┘           │   │ IGW / NAT* │     └───────────────┘  │
                          │   └────────────┘                        │
                          │   ┌────────────┐     ┌───────────────┐  │
                          │   │  Security  │     │   Logging     │  │
                          │   │ CloudTrail │────▶│ central S3    │  │
                          │   │ KMS / GD*  │     │ (encrypted)   │  │
                          │   │ Config*/SH*│     └───────────────┘  │
                          │   └────────────┘                        │
                          │   ┌────────────┐                        │
                          │   │ Monitoring │  SNS topic + alarms    │
                          │   └────────────┘                        │
                          └─────────────────────────────────────────┘
                              * = optional, off by default
```

See [docs/architecture.md](docs/architecture.md) for detail.

## Features

- **Networking** — VPC, public/private subnets across multiple AZs, route
  tables, Internet Gateway, optional NAT Gateway(s), optional VPC Flow Logs,
  fully configurable CIDRs.
- **IAM** — baseline assume-roles (admin, read-only, optional developer), MFA
  enforced by default, least-privilege, no hardcoded users or secrets.
- **Security** — multi-region CloudTrail with a hardened bucket, customer-
  managed KMS key with rotation, optional AWS Config, GuardDuty, Security Hub.
- **Logging** — encrypted, versioned, public-access-blocked central log bucket
  with lifecycle rules to control cost.
- **Monitoring** — SNS topic, custom CloudWatch alarms, optional billing alarm.
- **Multi-account ready** — same module deployed per environment/account;
  optional AWS Organizations integration kept out of the critical path.
- **Cost-aware** — every paid service is opt-in and off by default.

## Repository structure

```
.
├── main.tf / variables.tf / outputs.tf / locals.tf / versions.tf
│                         # Root module: composes everything (a reusable module)
├── terraform.tfvars.example
├── bootstrap/            # One-time: creates the S3 remote-state bucket
├── modules/
│   ├── networking/       # VPC, subnets, routing, NAT, flow logs
│   ├── iam/              # Baseline assume-roles
│   ├── logging/          # Secure central log bucket
│   ├── security/         # KMS, CloudTrail, Config, GuardDuty, Security Hub
│   └── monitoring/       # SNS + CloudWatch alarms
├── environments/
│   ├── dev/ staging/ prod/   # Deployable stacks, one remote state each
├── examples/
│   ├── basic/            # Single account, local backend, free baseline
│   └── multi-account/    # Same module into dev/staging/prod accounts
├── docs/                 # architecture, security, costs, deployment, troubleshooting
├── .github/workflows/    # fmt / validate / lint / security scan (no auto-deploy)
├── Makefile
├── LICENSE (MIT)
└── CONTRIBUTING / CODE_OF_CONDUCT / SECURITY / CHANGELOG
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) **>= 1.5**
  (>= 1.10 recommended for S3-native state locking).
- AWS account + credentials configured (`aws configure`, SSO, or environment
  variables). **Do not** hardcode credentials in any file.
- AWS CLI (optional, for verification).

## AWS permissions needed

The deploying identity needs permission to create the resources you enable.
For the full baseline that includes EC2/VPC, IAM, S3, KMS, CloudTrail, and
(optionally) Config, GuardDuty, Security Hub, CloudWatch and SNS. For a first
run, an administrator identity is simplest; for ongoing use, scope a deployment
role down to the services in use. See [docs/security.md](docs/security.md).

## Usage

### Quickest: the basic example (local state, free baseline)

```bash
git clone https://github.com/hrhosseini/terraform-aws-landing-zone.git
cd terraform-aws-landing-zone/examples/basic

terraform init
terraform plan
terraform apply
```

### Recommended: remote state + per-environment stacks

```bash
# 1. Create the shared state bucket once.
cd bootstrap
cp terraform.tfvars.example terraform.tfvars   # set a unique bucket name
terraform init && terraform apply

# 2. Point an environment at that bucket and deploy it.
cd ../environments/dev
#   edit backend.tf and set `bucket` to the name printed in step 1
terraform init
terraform plan
terraform apply
```

### As a module in your own configuration

```hcl
module "landing_zone" {
  source = "github.com/hrhosseini/terraform-aws-landing-zone"

  project     = "acme"
  environment = "dev"
  aws_region  = "eu-west-1"

  enable_nat_gateway = false   # paid, off by default
  enable_guardduty   = false   # paid, off by default
}
```

## Example deployment

See [examples/basic](examples/basic/) (single account) and
[examples/multi-account](examples/multi-account/) (dev/staging/prod).

## Input variables

Full reference in [variables.tf](variables.tf). Most-used:

| Variable | Default | Description |
|----------|---------|-------------|
| `project` | `landing-zone` | Name prefix for all resources |
| `environment` | _(required)_ | e.g. `dev`, `staging`, `prod` |
| `aws_region` | `eu-west-1` | Region for regional resources |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR |
| `az_count` | `2` | Number of AZs |
| `enable_nat_gateway` | `false` | NAT Gateway (**paid**) |
| `enable_flow_logs` | `false` | VPC Flow Logs (**paid**) |
| `enable_cloudtrail` | `true` | Multi-region CloudTrail |
| `create_kms_key` | `true` | KMS key for log encryption |
| `enable_config` | `false` | AWS Config (**paid**) |
| `enable_guardduty` | `false` | GuardDuty (**paid**) |
| `enable_securityhub` | `false` | Security Hub (**paid**) |
| `create_monitoring` | `true` | SNS topic + alarms |
| `force_destroy_buckets` | `false` | Allow deleting non-empty buckets |

## Outputs

Full reference in [outputs.tf](outputs.tf): `vpc_id`, `public_subnet_ids`,
`private_subnet_ids`, `admin_role_arn`, `readonly_role_arn`, `log_bucket_id`,
`kms_key_arn`, `cloudtrail_arn`, `guardduty_detector_id`, and more.

## Security notes

- **Never commit** AWS keys, real account IDs/ARNs, `.tfvars` with real values,
  or `*.tfstate` — all are git-ignored. Use placeholders (`123456789012`,
  `example.com`, `your-bucket-name`).
- State can contain sensitive values — keep it in a private, encrypted backend.
- All S3 buckets block public access, enforce TLS, and encrypt at rest.
- CloudTrail uses log-file validation and (optionally) KMS encryption.
- IAM roles require MFA by default. See [docs/security.md](docs/security.md).

## Cost warning

Paid services are **off by default**. Enabling NAT Gateway, VPC Flow Logs, AWS
Config, GuardDuty, or Security Hub will incur charges. Read
[docs/costs.md](docs/costs.md) and consider a billing alarm.

## Cleanup

```bash
terraform destroy
```

Buckets are not force-destroyed by default; empty them first or set
`force_destroy_buckets = true`. Destroy environments **before** the bootstrap
state bucket. See [docs/deployment-guide.md](docs/deployment-guide.md#cleanup).

## Contributing

Contributions welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) and our
[Code of Conduct](CODE_OF_CONDUCT.md). Report vulnerabilities per
[SECURITY.md](SECURITY.md).

## License

[MIT](LICENSE).

# Security

Secure defaults are the whole point of a landing zone. This document describes
what the code enforces and what you must do yourself.

## What the code enforces

### S3 buckets (state, logs, CloudTrail, Config)
- Block Public Access fully enabled on every bucket.
- ACLs disabled (`BucketOwnerEnforced` object ownership).
- Encryption at rest (KMS where a key is provided, otherwise SSE-S3/AES256).
- Versioning enabled (recover from accidental delete/overwrite).
- Bucket policy denying any request over plain HTTP (`aws:SecureTransport`).
- `force_destroy = false` by default so buckets with data cannot be deleted by
  accident.

### CloudTrail
- Multi-region, includes global service events.
- Log-file validation enabled (tamper detection).
- Optional KMS encryption of log files.
- Dedicated bucket with a least-privilege policy scoped to the trail ARN and the
  account ID.

### KMS
- Customer-managed key with automatic annual rotation.
- Key policy grants the account root admin, and grants CloudTrail only the
  specific actions it needs (`GenerateDataKey*`, `DescribeKey`) under an
  encryption-context condition.

### IAM
- Only assume-roles are created — no IAM users, no long-lived access keys.
- MFA is required to assume the baseline roles by default (`iam_require_mfa`).
- Roles use AWS-managed policies for the baseline; tighten with your own
  customer-managed policies for production least-privilege.
- `max_session_duration` defaults to 1 hour.

### Networking
- Private subnets have **no** internet egress unless you explicitly enable NAT.
- Optional VPC Flow Logs for network visibility.

## What you must do

- **Credentials**: configure AWS credentials via your environment, SSO, or an
  assumed role. Never put keys in `.tf` or `.tfvars` files.
- **Restrict role trust**: set `iam_trusted_principal_arns` to specific
  principals in production rather than the whole account root.
- **Protect state**: state files can contain secrets. Keep the state bucket
  private and encrypted (the `bootstrap/` stack does this).
- **Review optional services**: enable GuardDuty / Security Hub / Config for a
  stronger posture (they cost money — see [costs.md](costs.md)).
- **Least privilege for the deployer**: after the first apply, scope the
  deployment identity down from administrator to only the services in use.

## Never commit

| Do **not** commit | Use instead |
|-------------------|-------------|
| AWS access/secret keys | Environment/SSO credentials |
| Real account IDs | `123456789012` |
| Real ARNs | placeholder ARNs |
| Real emails | `example.com` addresses |
| `*.tfstate` / `*.tfstate.*` | remote backend (git-ignored) |
| `.tfvars` with real values | `*.tfvars.example` |
| `.terraform/` | git-ignored |

All of the above are covered by [`.gitignore`](../.gitignore). Consider a
pre-commit secret scanner (e.g. `gitleaks`) for extra safety.

## Reporting a vulnerability

See [SECURITY.md](../SECURITY.md).

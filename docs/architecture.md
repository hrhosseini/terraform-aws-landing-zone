# Architecture

This landing zone is a set of small, composable Terraform modules wired together
by a root composition module. The root is itself a **reusable module**: the
`environments/*` stacks and `examples/*` call it via `source`, each supplying its
own provider and (for environments) remote state.

```
environments/dev ─┐
environments/stg ─┼─▶ root module (./) ─┬─▶ modules/networking
environments/prd ─┘                     ├─▶ modules/iam
examples/basic ───▶ root module (../../)├─▶ modules/logging
examples/multi ───▶ root module (../../)├─▶ modules/security
                                        └─▶ modules/monitoring
```

## Modules

### networking
- One VPC; public and private subnets spread across N Availability Zones.
- Internet Gateway + a public route table (default route to the IGW).
- One private route table per AZ.
- **Optional** NAT Gateway(s): one shared (cheap) or one per AZ (HA). Default
  off — private subnets have no internet egress until you enable it.
- **Optional** VPC Flow Logs to a dedicated CloudWatch Log Group via a scoped
  IAM role.
- Subnet CIDRs are auto-derived from the VPC CIDR when not specified.

### iam
- Assume-role baseline: `admin` (AdministratorAccess), `readonly`
  (ReadOnlyAccess), and optional `developer` (PowerUserAccess by default).
- Trust policy defaults to the current account root; override with explicit
  principal ARNs. MFA required by default.
- No IAM users, access keys, or inline secrets are created.

### logging
- A single encrypted, versioned S3 bucket for centralized logs.
- Public access fully blocked, ACLs disabled (`BucketOwnerEnforced`), a policy
  denying non-TLS access, and lifecycle rules (IA → Glacier → expire) to
  control storage cost.
- Encryption uses the KMS key from the security module when available, else
  SSE-S3.

### security
- **KMS** customer-managed key (rotation on) used to encrypt CloudTrail logs.
- **CloudTrail** multi-region trail with log-file validation, writing to its own
  dedicated hardened bucket with the required bucket policy.
- **Optional** AWS Config (recorder + delivery channel + role + bucket),
  GuardDuty detector, and Security Hub — each independently toggled, all off by
  default.

### monitoring
- **Optional** SNS topic with email subscriptions for alarm notifications.
- A map-driven set of custom CloudWatch metric alarms.
- **Optional** billing (EstimatedCharges) alarm — note this only works when the
  stack is deployed in `us-east-1`, where AWS publishes billing metrics.

## Naming and tagging

- Every resource is prefixed `\${project}-\${environment}` (e.g. `acme-dev-vpc`).
- Common tags (`Project`, `Environment`, `ManagedBy`) are applied via the
  provider `default_tags` in each caller and merged into module-level tags.

## State

- `bootstrap/` creates the S3 state bucket once (S3-native locking, no DynamoDB).
- Each environment uses a distinct state key, so environments are isolated.

## Multi-account

The root module is account-agnostic. Deploy it into multiple accounts by giving
each module instance a provider that assumes a role in the target account (see
`examples/multi-account`). Creating the AWS Organization and member accounts is
intentionally out of scope so the landing zone works in a single existing
account; wire account IDs in from a separate management-account stack if you
want Terraform to own the Organization.

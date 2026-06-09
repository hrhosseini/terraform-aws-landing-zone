# Multi-Account Example

Shows how to deploy the **same landing zone module** into three separate AWS
accounts — `dev`, `staging`, and `prod` — from one configuration, by giving
each module instance its own aliased provider that assumes a role in the target
account.

> All account IDs here are **placeholders** (`111111111111`, `222222222222`,
> `333333333333`). Replace them with your own before using.

## How it works

- [`providers.tf`](providers.tf) declares one aliased `aws` provider per
  account. Each assumes `deployment_role_name` (default
  `OrganizationAccountAccessRole`) in its target account.
- [`main.tf`](main.tf) calls the root module three times, passing
  `providers = { aws = aws.<env> }` to each.
- `prod` enables the hardened, paid features (NAT per-AZ, GuardDuty, Config,
  Security Hub); `dev`/`staging` stay lean.

## Prerequisites

- An AWS Organization (or otherwise pre-created accounts).
- A role Terraform can assume in each member account (e.g.
  `OrganizationAccountAccessRole`, created automatically for accounts that AWS
  Organizations provisions).
- CLI credentials for an identity allowed to assume those roles.

## Usage

```bash
cd examples/multi-account

terraform init

terraform apply \
  -var 'dev_account_id=111111111111' \
  -var 'staging_account_id=222222222222' \
  -var 'prod_account_id=333333333333'
```

## State layout note

For clarity this example keeps **all three accounts in one state file**. In
production it is usually better to give each account/environment its own state
(its own backend) — see the [`environments/`](../../environments/) directory for
that pattern, and [docs/deployment-guide.md](../../docs/deployment-guide.md).

## Optional: AWS Organizations

This repo does **not** create the AWS Organization or the member accounts —
that is intentionally out of scope so the landing zone stays usable in a single
pre-existing account. If you want Terraform to manage the Organization itself,
add `aws_organizations_organization` / `aws_organizations_account` resources in
a dedicated management-account stack and feed the resulting account IDs into
this example.

## Cost

`prod` here enables several **paid** services (NAT Gateways, GuardDuty, Config,
Security Hub). Review [docs/costs.md](../../docs/costs.md) before applying.

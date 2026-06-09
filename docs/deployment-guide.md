# Deployment Guide

A step-by-step walkthrough from a fresh clone to a deployed, then cleaned-up,
landing zone.

## 0. Prerequisites

- Terraform >= 1.5 (>= 1.10 for S3-native state locking).
- AWS credentials configured for the target account:
  ```bash
  aws configure          # or: export AWS_PROFILE=...  / SSO / assumed role
  aws sts get-caller-identity   # confirm you're who you expect
  ```

## 1. Try it locally (optional, no remote state)

The fastest way to see it work, using the local backend and the free baseline:

```bash
cd examples/basic
terraform init
terraform plan
terraform apply
```

Tear it down with `terraform destroy` when finished.

## 2. Create the remote state bucket (once per account)

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars
#   set state_bucket_name to something GLOBALLY UNIQUE, e.g. acme-tfstate-123456789012
terraform init
terraform apply
terraform output state_bucket_name   # note this value
```

## 3. Configure an environment

```bash
cd ../environments/dev
```

Edit `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket       = "acme-tfstate-123456789012"   # <- from step 2
    key          = "landing-zone/dev/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

Edit `main.tf` — set the `locals` (`project`, `aws_region`) and toggle features
to taste.

## 4. Deploy

```bash
terraform init      # connects to the remote backend
terraform plan      # review every resource before creating anything
terraform apply
```

Repeat steps 3–4 for `staging` and `prod`. Each has its own state key, so they
are fully isolated.

## 5. Using a deployment role (recommended)

Rather than long-lived admin keys, assume a role:

```hcl
# in the environment's providers.tf
provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/terraform-deploy"
  }
}
```

## Cleanup

Destroy in reverse order of creation.

```bash
# 1. Each environment (run in each environments/* dir you deployed)
cd environments/dev
terraform destroy

# 2. Only after ALL environments are destroyed, the state bucket:
cd ../../bootstrap
terraform destroy
```

> Log/CloudTrail buckets use `force_destroy = false`. If destroy fails because a
> bucket is not empty, either empty it in the console/CLI or set
> `force_destroy_buckets = true` in the environment's `main.tf`, re-apply, then
> destroy.
>
> Some account-level resources (GuardDuty, Security Hub, the Config recorder)
> are singletons per region — destroying the stack disables them for the
> account, so coordinate if other stacks rely on them.

## CI/CD

The provided GitHub Actions (`.github/workflows/`) run **fmt, validate, lint,
and security scans only** — they never apply to AWS. Wire in your own gated
apply pipeline if you want continuous deployment, using an OIDC-federated role
rather than stored credentials.

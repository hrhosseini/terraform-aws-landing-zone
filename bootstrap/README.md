# Bootstrap — Terraform Remote State Backend

This stack creates the S3 bucket used as the **remote backend** for every
environment in this repository. You run it **once per AWS account**, using a
local backend, before configuring `environments/*` to use remote state.

State locking uses S3's native lock file (`use_lockfile = true`), so **no
DynamoDB table is required** (Terraform >= 1.10 or OpenTofu).

## What it creates

- One S3 bucket for Terraform state, with:
  - Versioning (state history / recovery)
  - Encryption at rest (SSE-S3 / AES256)
  - Public access fully blocked
  - ACLs disabled (`BucketOwnerEnforced`)
  - A bucket policy that denies non-TLS access

## Usage

```bash
cd bootstrap

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars: set a GLOBALLY UNIQUE bucket name and region.

terraform init
terraform apply

# Note the output: state_bucket_name
terraform output
```

Then set that bucket name in each environment's `backend.tf` (see
`environments/dev/backend.tf`) and run `terraform init` there.

## Cost

A near-zero-cost stack: you pay only for S3 storage of small state files
(typically a few cents per month).

## Cleanup

The state bucket should normally **outlive** your environments. Only destroy it
after every environment that uses it has been destroyed, otherwise you lose the
ability to manage that state.

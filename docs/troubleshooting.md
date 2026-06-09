# Troubleshooting

## `BucketAlreadyExists` / `BucketAlreadyOwnedByYou`
S3 bucket names are **globally unique** across all AWS accounts. The defaults in
this repo append your account ID, but if you override a bucket name choose a
unique one. Override via `log_bucket_name`, `cloudtrail_bucket_name`,
`config_bucket_name`, or `state_bucket_name` (bootstrap).

## `Error: error configuring S3 Backend: ... NoSuchBucket`
The backend bucket in `environments/*/backend.tf` doesn't exist yet, or the name
is wrong. Run the `bootstrap/` stack first and copy its `state_bucket_name`
output into `backend.tf`. Then `terraform init -reconfigure`.

## `Error acquiring the state lock`
Another apply is in progress, or a previous run crashed. With S3-native locking
(`use_lockfile = true`) a stale `.tflock` object can remain in the state bucket;
remove that specific lock object once you're sure no apply is running, or use
`terraform force-unlock <LOCK_ID>`.

## Backend changed / "Backend configuration changed"
After editing `backend.tf`, run:
```bash
terraform init -reconfigure
```

## `AccessDenied` / `UnauthorizedOperation`
The deploying identity lacks permissions for a resource you enabled. For a first
run use an admin identity; then scope down. Check `aws sts get-caller-identity`
to confirm which principal you're using.

## CloudTrail: `InsufficientS3BucketPolicyException`
The trail bucket policy must exist before the trail. The module already sets a
`depends_on`; if you imported or hand-edited resources, re-apply so the bucket
policy is in place before the `aws_cloudtrail` resource.

## Billing alarm never triggers
`AWS/Billing` metrics are published **only in us-east-1**. Deploy the stack with
`aws_region = "us-east-1"` for `enable_billing_alarm` to work. Also ensure
"Receive Billing Alerts" is enabled in the account's Billing preferences.

## GuardDuty / Security Hub / Config: "already enabled"
These are per-account-per-region singletons. If another stack or a click-ops
action already enabled them, Terraform will conflict. Either import the existing
resource (`terraform import`) or leave the toggle off in this stack.

## `terraform destroy` fails on a non-empty bucket
Log/CloudTrail buckets default to `force_destroy = false`. Empty the bucket
first, or set `force_destroy_buckets = true`, re-apply, then destroy.

## `Provider configuration not present` on destroy
This happens if you remove a `module` block (and its provider) while resources
still exist. Re-add the module/provider, destroy, then remove. This is why the
root module deliberately contains **no** provider block.

## Subnet count / CIDR errors
If you pass `public_subnet_cidrs` / `private_subnet_cidrs` explicitly, provide
**one entry per AZ** (`az_count` or the length of `availability_zones`). Leave
them empty to auto-derive from `vpc_cidr`.

## Formatting / validation failures in CI
Run locally before pushing:
```bash
make fmt
make validate
```

# Basic Example — Single-Account Landing Zone

Deploys the landing zone with only the **free baseline** enabled:

- VPC across 2 AZs with public + private subnets (no NAT Gateway)
- Baseline IAM roles (admin, read-only)
- Secure central log bucket + KMS key
- Multi-region CloudTrail with a hardened bucket
- Monitoring SNS topic

All paid add-ons (NAT Gateway, VPC Flow Logs, AWS Config, GuardDuty, Security
Hub, billing alarm) are **disabled**.

This example uses the **local backend**, so state is stored in
`./terraform.tfstate`. Good for trying things out; use a remote backend for
anything real (see [`environments/`](../../environments/) and
[`bootstrap/`](../../bootstrap/)).

## Usage

```bash
cd examples/basic

terraform init
terraform plan
terraform apply
```

To override the defaults:

```bash
terraform apply \
  -var 'project=acme' \
  -var 'environment=dev' \
  -var 'aws_region=eu-west-1'
```

## Cleanup

```bash
terraform destroy
```

> The log and CloudTrail buckets have `force_destroy = false` by default, so if
> they contain objects you must empty them first (or set
> `force_destroy_buckets = true` on the root module before destroying).

## Cost

With the defaults above, this example creates **no hourly-billed resources**.
You pay only trivial amounts for S3 storage of CloudTrail logs and KMS key
usage. See [docs/costs.md](../../docs/costs.md).

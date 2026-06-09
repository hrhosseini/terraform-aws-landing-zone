# Environments

Each subdirectory is an independent, deployable stack that calls the root
landing-zone module (`source = "../../"`) with environment-specific settings and
its **own remote state** (separate S3 key per environment).

| Environment | NAT | Flow Logs | GuardDuty | Config | Security Hub |
|-------------|-----|-----------|-----------|--------|--------------|
| `dev`       | ❌  | ❌        | ❌        | ❌     | ❌           |
| `staging`   | ✅ (single) | ✅ | ✅        | ❌     | ❌           |
| `prod`      | ✅ (per-AZ) | ✅ | ✅        | ✅     | ✅           |

## Before you start

1. Create the shared state bucket once (see [`../bootstrap/`](../bootstrap/)).
2. In each environment's `backend.tf`, replace `YOUR_TERRAFORM_STATE_BUCKET`
   with the bucket name from the bootstrap output, and adjust `region`.
3. Edit the `locals` block (project, region) and the module inputs in that
   environment's `main.tf` to match your organization.

## Deploy an environment

```bash
cd environments/dev      # or staging / prod

terraform init
terraform plan
terraform apply
```

Each environment is fully isolated — applying `dev` never touches `prod`.

See [../docs/deployment-guide.md](../docs/deployment-guide.md) for the full
walkthrough.

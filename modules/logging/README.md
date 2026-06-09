# Module: logging

Creates a single hardened, centralized S3 log bucket: encrypted, versioned,
public access blocked, TLS-only, ACLs disabled, with lifecycle rules to control
storage cost.

## Usage

```hcl
module "logging" {
  source = "../../modules/logging"

  bucket_name     = "acme-dev-logs-123456789012"   # globally unique
  kms_key_arn     = module.security.kms_key_arn     # optional; else SSE-S3
  expiration_days = 365
  tags            = { Project = "acme" }
}
```

## Key inputs

| Name | Default | Description |
|------|---------|-------------|
| `bucket_name` | _(required)_ | Globally unique bucket name |
| `kms_key_arn` | `null` | KMS key for SSE-KMS; null = SSE-S3 |
| `enable_lifecycle` | `true` | Transition + expire old objects |
| `transition_to_ia_days` | `30` | Days → STANDARD_IA |
| `transition_to_glacier_days` | `90` | Days → GLACIER |
| `expiration_days` | `365` | Days → delete (0 = never) |
| `force_destroy` | `false` | Allow delete with objects present |

## Key outputs

`bucket_id`, `bucket_arn`, `bucket_domain_name`.

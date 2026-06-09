# Module: iam

Creates baseline IAM **assume-roles** — admin, read-only, and an optional
developer role. No IAM users or access keys are created.

## Usage

```hcl
module "iam" {
  source = "../../modules/iam"

  name_prefix            = "acme-dev"
  trusted_principal_arns = ["arn:aws:iam::123456789012:root"]
  require_mfa            = true
  create_developer_role  = true
  tags                   = { Project = "acme" }
}
```

## Key inputs

| Name | Default | Description |
|------|---------|-------------|
| `name_prefix` | _(required)_ | Prefix for role names |
| `trusted_principal_arns` | `[]` | Who can assume the roles; empty = account root |
| `require_mfa` | `true` | Require MFA to assume |
| `max_session_duration` | `3600` | Max session seconds (3600–43200) |
| `create_admin_role` | `true` | AdministratorAccess role |
| `create_readonly_role` | `true` | ReadOnlyAccess role |
| `create_developer_role` | `false` | Developer role |
| `developer_managed_policy_arns` | `[PowerUserAccess]` | Policies for the developer role |

## Key outputs

`admin_role_arn`, `readonly_role_arn`, `developer_role_arn` (and `_name`
variants). Each is `null` when the role isn't created.

## Notes

For production least-privilege, replace the AWS-managed policies with your own
customer-managed policies and set `trusted_principal_arns` to specific
principals rather than the account root.

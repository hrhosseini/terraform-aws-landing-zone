# Contributing

Thanks for your interest in improving **terraform-aws-landing-zone**!
Contributions of all kinds are welcome: bug reports, docs, new modules, and
feature requests.

## Getting started

1. Fork and clone the repo.
2. Install tooling: [Terraform](https://developer.hashicorp.com/terraform/downloads)
   (>= 1.5), [tflint](https://github.com/terraform-linters/tflint), and
   optionally [pre-commit](https://pre-commit.com/) and
   [checkov](https://www.checkov.io/) / [trivy](https://trivy.dev/).
3. Install the git hooks: `pre-commit install`.

## Development workflow

```bash
make fmt            # format all .tf files
make validate       # init (no backend) + validate every stack
make lint           # tflint
make security-scan  # checkov / trivy (if installed)
```

Please ensure these pass before opening a PR. CI runs the same checks.

## Standards

- Terraform `>= 1.5`; AWS provider pinned `>= 5.0, < 6.0`.
- Every variable has a `description` and `type`; every output has a
  `description`.
- No hardcoded account IDs, ARNs, regions, secrets, or emails — use placeholders
  (`123456789012`, `example.com`, `your-bucket-name`).
- Any resource that costs money must be **optional and off by default**, and
  commented/documented as a cost.
- Keep modules small, composable, and independently documented (a `README.md`
  per module).
- Match the existing naming convention: resources are prefixed
  `\${project}-\${environment}`.

## Commit / PR

- Write clear commit messages.
- Fill out the PR template checklist.
- Keep PRs focused; one logical change per PR where possible.
- Update docs and module READMEs alongside code.

## Reporting security issues

Do **not** open a public issue for vulnerabilities — see [SECURITY.md](SECURITY.md).

## Code of Conduct

This project follows the [Contributor Covenant](CODE_OF_CONDUCT.md).

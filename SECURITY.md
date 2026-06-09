# Security Policy

## Reporting a vulnerability

If you discover a security vulnerability in this project, **please do not open a
public GitHub issue.** Instead, report it privately:

- Use GitHub's [private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
  ("Report a vulnerability" under the repository's **Security** tab), or
- Contact the maintainers directly through the channel listed on the repository.

Please include:

- A description of the issue and its potential impact
- Steps to reproduce (redact any real account IDs, ARNs, or secrets)
- Affected module/version if known

We aim to acknowledge reports promptly and will coordinate a fix and disclosure
timeline with you.

## Scope

This repository contains **infrastructure-as-code templates**. The most relevant
classes of issues are:

- Insecure defaults (e.g. a resource exposed publicly, missing encryption)
- Privilege escalation paths in the IAM baseline
- Guidance that could lead users to commit secrets

## Your responsibilities as a user

- Never commit credentials, real account IDs/ARNs, or state files (all are
  git-ignored — see [`.gitignore`](.gitignore)).
- Keep Terraform state in a private, encrypted backend.
- Review [docs/security.md](docs/security.md) before deploying to production.
- Keep the AWS provider and Terraform up to date.

# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project aims
to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Reusable root landing-zone module composing networking, IAM, logging,
  security, and monitoring building-block modules.
- `modules/networking` — VPC, public/private subnets, routing, IGW, optional
  NAT Gateway(s) and optional VPC Flow Logs.
- `modules/iam` — baseline admin / read-only / optional developer assume-roles
  with MFA enforced by default.
- `modules/logging` — hardened, encrypted, versioned central log bucket with
  lifecycle rules.
- `modules/security` — KMS key, multi-region CloudTrail with a dedicated bucket,
  and optional AWS Config, GuardDuty, and Security Hub.
- `modules/monitoring` — SNS topic, custom CloudWatch alarms, optional billing
  alarm.
- `bootstrap/` — S3 remote-state bucket with S3-native locking (no DynamoDB).
- `environments/{dev,staging,prod}` deployable stacks with isolated remote
  state.
- `examples/{basic,multi-account}`.
- Documentation: architecture (with an SVG architecture diagram), security,
  costs, deployment guide, troubleshooting, and per-module READMEs.

### Fixed
- AWS Config role now includes an explicit S3 delivery policy
  (`s3:PutObject` / `s3:GetBucketAcl`) so configuration snapshots deliver
  without `AccessDenied`; the delivery channel now waits for the bucket and
  role policies to exist.
- CI: `terraform fmt`/`validate`/`tflint` and Trivy/Checkov security scans
  (no auto-deploy).
- Open-source scaffolding: MIT license, CONTRIBUTING, CODE_OF_CONDUCT, SECURITY,
  issue/PR templates, Makefile, and pre-commit config.

[Unreleased]: https://github.com/hrhosseini/terraform-aws-landing-zone/compare/HEAD...HEAD

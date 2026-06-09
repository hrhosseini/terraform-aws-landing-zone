# Pull Request

## What does this change?

<!-- A clear, concise description of the change and the motivation. -->

## Type of change

- [ ] Bug fix
- [ ] New feature / module
- [ ] Documentation
- [ ] Refactor / cleanup
- [ ] CI / tooling

## Checklist

- [ ] `terraform fmt -recursive` produces no changes (`make fmt`)
- [ ] `terraform validate` passes for affected dirs (`make validate`)
- [ ] `tflint` / security scan reviewed (`make lint`, `make security-scan`)
- [ ] No secrets, real account IDs, ARNs, or emails are included
- [ ] New variables have `description` + `type`; new outputs have `description`
- [ ] Docs / module READMEs updated where relevant
- [ ] Paid resources (if any) are optional and off by default

## Notes for reviewers

<!-- Anything reviewers should pay special attention to. -->

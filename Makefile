# Makefile for terraform-aws-landing-zone
# Convenience targets for local development. None of these deploy to AWS.

# Directories that are independently init/validate-able.
STACKS := . bootstrap examples/basic examples/multi-account \
          environments/dev environments/staging environments/prod

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: fmt
fmt: ## Format all Terraform files
	terraform fmt -recursive

.PHONY: fmt-check
fmt-check: ## Check formatting (CI-style, no changes)
	terraform fmt -check -recursive

.PHONY: validate
validate: ## terraform init (no backend) + validate every stack
	@for d in $(STACKS); do \
		echo "==> validate $$d"; \
		terraform -chdir=$$d init -backend=false -input=false >/dev/null && \
		terraform -chdir=$$d validate || exit 1; \
	done

.PHONY: lint
lint: ## Run tflint recursively (requires tflint)
	tflint --init
	tflint --recursive

.PHONY: security-scan
security-scan: ## Run static security scans (requires checkov and/or trivy)
	@command -v checkov >/dev/null 2>&1 && checkov -d . --quiet --compact || echo "checkov not installed, skipping"
	@command -v trivy >/dev/null 2>&1 && trivy config . || echo "trivy not installed, skipping"

.PHONY: docs
docs: ## Regenerate module docs (requires terraform-docs)
	@command -v terraform-docs >/dev/null 2>&1 || { echo "terraform-docs not installed"; exit 1; }
	@for m in modules/*; do \
		echo "==> docs $$m"; \
		terraform-docs markdown table --output-file README.md --output-mode inject $$m; \
	done

.PHONY: clean
clean: ## Remove local .terraform dirs and plan files
	find . -type d -name ".terraform" -prune -exec rm -rf {} +
	find . -type f -name "*.tfplan" -delete

.PHONY: check
check: fmt-check validate ## Run the core CI checks locally

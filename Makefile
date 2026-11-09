# Mirrors .github/workflows/ci.yml: if `make ci` is green locally, CI is green.
# Needs: uv (https://docs.astral.sh/uv/) and Node.js (for npx).
.DEFAULT_GOAL := help

.PHONY: help actionlint html content-guard ci

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

actionlint: ## CI step: lint GitHub Actions workflows
	uvx --from actionlint-py==1.7.12.25 actionlint -color

html: ## CI step: validate every HTML page against the HTML standard
	npx --yes html-validate@10.17.0 --preset standard "**/*.html"

content-guard: ## CI step: fail on secrets / addresses that must not be committed
	scripts/check-content.sh

ci: actionlint html content-guard ## Everything CI runs, in the same order

DUNE = dune

.PHONY: help
help: ## Print this help message
	@echo "";
	@echo "List of available make commands";
	@echo "";
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: sync
sync: ## Download grammars from upstream sources
	@bash scripts/sync.sh

.PHONY: generate
generate: ## Generate packages from vendored grammars
	@bash scripts/generate.sh

.PHONY: build
build: ## Build all packages
	$(DUNE) build

.PHONY: clean
clean: ## Clean build artifacts
	$(DUNE) clean

.PHONY: update
update: sync generate build ## Sync + generate + build (full refresh)

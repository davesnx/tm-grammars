project_name = tm-grammars

OPAM = opam exec --
DUNE = $(OPAM) dune

.PHONY: help
help: ## Print this help message
	@echo "";
	@echo "List of available make commands";
	@echo "";
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: sync
sync: ## Download grammars and themes from upstream sources
	@bash scripts/sync.sh grammars
	@bash scripts/sync.sh themes

.PHONY: generate
generate: ## Generate all derived files
	@for kind in grammars themes; do \
		bash scripts/gen_package_dunes.sh $$kind; \
		bash scripts/gen_all_module.sh $$kind; \
		bash scripts/gen_pkg_module.sh $$kind; \
	done
	@bash scripts/gen_third_party_licenses.sh THIRD-PARTY-LICENSES
	$(DUNE) build --root . tm-grammars.opam tm-themes.opam --auto-promote

.PHONY: build
build: ## Build all packages
	$(DUNE) build --root . @all

.PHONY: dev
dev: ## Build in watch mode
	$(DUNE) build --root . -w @all

.PHONY: test
test: ## Run tests
	$(DUNE) build --root . @runtest

.PHONY: docs
docs: ## Build docs and refresh README.md
	$(DUNE) build --root . @doc @doc-markdown --auto-promote

.PHONY: clean
clean: ## Clean build artifacts
	$(DUNE) clean --root .

.PHONY: setup-githooks
setup-githooks: ## Setup githooks
	git config core.hooksPath .githooks

.PHONY: create-switch
create-switch: ## Create opam switch
	opam switch create . 5.4.0 --deps-only --with-test --no-install -y

.PHONY: install
install: ## Install dependencies
	opam update
	opam install . --deps-only --with-test --with-doc --with-dev-setup -y

.PHONY: format fmt
format fmt: ## Format code
	$(DUNE) build --root . @fmt

.PHONY: init
init: setup-githooks create-switch install ## Create a local dev environment

.PHONY: update
update: sync generate build ## Sync + generate + build (full refresh)

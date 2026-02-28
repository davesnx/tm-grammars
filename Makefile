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
sync: ## Download grammars from upstream sources
	@bash scripts/sync.sh

.PHONY: generate
generate: ## Generate all derived files via dune
	$(DUNE) build @gen --auto-promote
	$(DUNE) build tm-grammars.opam --auto-promote

.PHONY: build
build: ## Build all packages
	$(DUNE) build @all

.PHONY: dev
dev: ## Build in watch mode
	$(DUNE) build -w @all

.PHONY: test
test: ## Run tests
	$(DUNE) build @runtest

.PHONY: docs
docs: ## Build docs and refresh README.md
	$(DUNE) build @doc @doc-markdown --auto-promote

.PHONY: clean
clean: ## Clean build artifacts
	$(DUNE) clean

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

.PHONY: pin
pin: ## Pin grammar compatibility fixes
	opam pin textmate-language https://github.com/davesnx/ocaml-textmate-language.git#grammar-compatibility-fixes -y

.PHONY: init
init: setup-githooks create-switch pin install ## Create a local dev environment

.PHONY: update
update: sync generate build ## Sync + generate + build (full refresh)

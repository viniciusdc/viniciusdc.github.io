.PHONY: help install dev build preview check banner post clean doctor _check_pixi

# Bare `make` shows the help.
.DEFAULT_GOAL := help

# Local dev runs through a pixi-managed Node 22 env (conda-forge) so the
# system Node version doesn't matter. On first `make <target>`, pixi solves
# and installs the env into `.pixi/` (gitignored). Pixi install: https://pixi.sh

# ── help ──────────────────────────────────────────────────────────────────────

help:  ## Show this help.
	@printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"
	@awk 'BEGIN {FS = ":.*?##"} \
		/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' \
		$(MAKEFILE_LIST)
	@printf "\n"

# ── pre-flight ────────────────────────────────────────────────────────────────

# Internal: every pixi-using target depends on this. Fails fast with a useful
# pointer instead of letting `pixi` itself report "command not found".
_check_pixi:
	@command -v pixi >/dev/null 2>&1 || { \
		printf "\033[31merror:\033[0m \`pixi\` is not on PATH.\n"; \
		printf "  Install pixi: https://pixi.sh/latest/installation/\n"; \
		printf "  Then re-run \`make %s\`.\n" "$(MAKECMDGOALS)"; \
		exit 1; \
	}

# ── environment ───────────────────────────────────────────────────────────────

install: _check_pixi  ## Install npm dependencies inside the pixi env.
	@printf "\033[1;36m==>\033[0m install: solving env + npm install\n"
	@pixi run install

dev: _check_pixi  ## Start the Astro dev server at http://localhost:4321.
	@printf "\033[1;36m==>\033[0m dev: starting Astro dev server at http://localhost:4321\n"
	@pixi run dev

build: _check_pixi  ## Build the production site to dist/.
	@printf "\033[1;36m==>\033[0m build: building static site to dist/\n"
	@pixi run build

preview: _check_pixi  ## Serve dist/ locally to preview the production build.
	@printf "\033[1;36m==>\033[0m preview: serving dist/\n"
	@pixi run preview

check: _check_pixi  ## Run type-check and spell-check.
	@printf "\033[1;36m==>\033[0m check: type-check + spell-check\n"
	@pixi run check

doctor: _check_pixi  ## Print resolved versions of pixi, node, and npm.
	@printf "\033[1;36m==>\033[0m doctor: environment versions\n"
	@printf "  pixi : %s\n" "$$(pixi --version 2>/dev/null | awk '{print $$2}')"
	@printf "  node : %s\n" "$$(pixi run --quiet node --version 2>/dev/null)"
	@printf "  npm  : %s\n" "$$(pixi run --quiet npm --version 2>/dev/null)"

clean:  ## Remove build artifacts and caches (dist/, .astro/, .pixi/, node_modules/).
	@printf "\033[1;36m==>\033[0m clean: removing dist/, .astro/, .pixi/, node_modules/\n"
	@rm -rf dist .astro .pixi node_modules

# ── assets ────────────────────────────────────────────────────────────────────

banner: _check_pixi  ## Regenerate .github/banner.svg.
	@printf "\033[1;36m==>\033[0m banner: regenerating .github/banner.svg\n"
	@pixi run banner

# ── content ───────────────────────────────────────────────────────────────────
#
#   make post TITLE="k3s coredns loop"                   → notes post, tag=field note
#   make post TITLE="k3s coredns loop" TAG="debugging"   → notes post, tag=debugging
#   make post TITLE="operator ownership" TYPE=arch       → architecture essay

post: _check_pixi  ## Scaffold a new post — requires TITLE; optional TAG and TYPE=note|arch.
ifndef TITLE
	$(error TITLE is required.  Example: make post TITLE="my title" TAG="debugging" TYPE=note|arch)
endif
	@printf "\033[1;36m==>\033[0m post: scaffolding \"%s\"\n" "$(TITLE)"
	@chmod +x scripts/new-post.sh
	@pixi run node scripts/new-post.sh "$(TITLE)" "$(or $(TAG),field note)" "$(or $(TYPE),note)"

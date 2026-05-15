.PHONY: install dev build preview check banner post

# Local dev runs through a pixi-managed Node 22 env (conda-forge) so
# the system Node version doesn't matter. On first `make <target>`,
# pixi solves and installs the env into `.pixi/` (gitignored).
#
# Requires pixi: https://pixi.sh — `curl -fsSL https://pixi.sh/install.sh | bash`

# ── environment ───────────────────────────────────────────────────────────────

install:
	pixi run install

dev:
	pixi run dev

build:
	pixi run build

preview:
	pixi run preview

check:
	pixi run check

# ── assets ────────────────────────────────────────────────────────────────────

banner:
	pixi run banner

# ── content ───────────────────────────────────────────────────────────────────
#
#   make post TITLE="k3s coredns loop"                   → notes post, tag=field note
#   make post TITLE="k3s coredns loop" TAG="debugging"   → notes post, tag=debugging
#   make post TITLE="operator ownership" TYPE=arch        → architecture essay

post:
ifndef TITLE
	$(error TITLE is required.  make post TITLE="my title" TAG="debugging" TYPE=note)
endif
	@chmod +x scripts/new-post.sh
	@pixi run node scripts/new-post.sh "$(TITLE)" "$(or $(TAG),field note)" "$(or $(TYPE),note)"

.PHONY: install dev build preview check banner post

# ── env ───────────────────────────────────────────────────────────────────────

env:
	pixi install

# ── npm (runs inside pixi env) ────────────────────────────────────────────────

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
	node scripts/gen-banner.mjs

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
	@scripts/new-post.sh "$(TITLE)" "$(or $(TAG),field note)" "$(or $(TYPE),note)"

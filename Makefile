.PHONY: install dev build preview check banner post

# ── npm ───────────────────────────────────────────────────────────────────────

install:
	npm install

dev:
	npm run dev

build:
	npm run build

preview:
	npm run preview

check:
	npm run check

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

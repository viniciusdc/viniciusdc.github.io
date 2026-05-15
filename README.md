<div align="center">

<img src=".github/banner.svg" alt="vinicius.dev — platform engineering field notes" width="100%"/>

---

[![site](https://img.shields.io/badge/viniciusdc.github.io-live-5eead4?style=flat-square)](https://viniciusdc.github.io) [![deploy](https://img.shields.io/github/actions/workflow/status/viniciusdc/viniciusdc.github.io/deploy.yml?branch=gh-pages&style=flat-square&label=deploy)](https://github.com/viniciusdc/viniciusdc.github.io/actions/workflows/deploy.yml)
![Astro](https://img.shields.io/badge/Astro_6-BC52EE?style=flat-square&logo=astro&logoColor=white) ![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS_v4-06B6D4?style=flat-square&logo=tailwindcss&logoColor=white) ![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat-square&logo=typescript&logoColor=white) ![MDX](https://img.shields.io/badge/MDX-F9AC00?style=flat-square&logo=mdx&logoColor=black)

</div>

---

## Commands

All `make` targets run through a [pixi](https://pixi.sh)-managed Node 22 environment (from conda-forge), so the system Node version doesn't matter. On first run, pixi solves and installs the env into `.pixi/` (gitignored).

```sh
make install      # npm install (inside pixi env)
make dev          # dev server → http://localhost:4321
make build        # production build → dist/
make preview      # serve dist/ locally
make check        # type-check + spell-check
make banner       # regenerate .github/banner.svg
```

Install pixi once with `curl -fsSL https://pixi.sh/install.sh | bash` (or `brew install pixi`).

## Project structure

- `src/layouts/` — `Layout.astro`, `ArticleLayout.astro`
- `src/pages/`
  - `index.astro` — homepage
  - `notes/` — field notes
  - `architecture/` — design essays
  - `writing/` — long-form essays *(entries gitignored, committed via content PRs)*
  - `projects/` — project writeups *(entries gitignored, committed via content PRs)*
  - `debug/` — debugging reference
  - `about/`
- `src/components/ui/` — `Badge.astro` and other primitives
- `src/styles/global.css`
- `src/templates/` — `note.mdx` and `architecture.mdx` starters
- `public/` — favicon and static assets
- `scripts/` — `gen-banner.mjs`, `new-post.sh`

## Writing a post

Scaffold a new post with `make post` — the slug is derived from the title automatically:

```sh
make post TITLE="k3s coredns loop"                          # field note (default)
make post TITLE="k3s coredns loop" TAG="debugging"          # custom tag
make post TITLE="operator ownership boundaries" TYPE=arch   # architecture essay
```

Posts are `.mdx` files. Each exports a `metadata` object that the homepage and index pages discover at build time — no manual registration needed:

```ts
export const metadata = {
  title: "Short, specific title",
  date: "YYYY-MM-DD",
  tag: "field note",   // field note · debugging · security · architecture · platform
  description: "One sentence describing what this explains.",
};
```

## CI / CD

| Job | Trigger | |
|---|---|---|
| Build | PR | Compiles the site and uploads `dist/` as an artifact |
| Spell check | PR | cspell over all `.astro` and `.mdx` source files |
| Lighthouse | PR | Accessibility, SEO, best-practices ≥ 100 · performance ≥ 90 |
| OSV-Scanner | PR | Scans dependencies against the OSV vulnerability database |
| Dependabot auto-merge | PR (Dependabot only) | Enables GitHub auto-merge on patch/minor PRs once required checks are green |
| Deploy | Push to `main` | Builds and publishes to GitHub Pages |

Actions are pinned to commit SHAs. Dependabot opens weekly PRs to keep action SHAs and npm deps current; releases soak for 1–7 days before a PR is opened (per semver bucket), and patch/minor updates auto-merge once CI and OSV-Scanner are green.

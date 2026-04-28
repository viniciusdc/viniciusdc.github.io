# viniciusdc.github.io

Personal site — Kubernetes, platform engineering, TLS, identity, GPU runtimes, and the architecture decisions worth writing down.

[![Deploy](https://github.com/viniciusdc/viniciusdc.github.io/actions/workflows/deploy.yml/badge.svg)](https://github.com/viniciusdc/viniciusdc.github.io/actions/workflows/deploy.yml)
&nbsp;&nbsp;**→** [viniciusdc.github.io](https://viniciusdc.github.io)

---

## Stack

Built with [Astro 6](https://astro.build), [Tailwind CSS v4](https://tailwindcss.com), and [MDX](https://mdxjs.com). Deployed to GitHub Pages via GitHub Actions.

## Commands

```sh
npm install       # install dependencies
npm run dev       # dev server → http://localhost:4321
npm run build     # production build → dist/
npm run preview   # serve dist/ locally
npm run check     # type-check + spell-check
```

## Project structure

```
src/
├── layouts/           # Layout.astro, ArticleLayout.astro
├── pages/
│   ├── index.astro    # homepage
│   ├── notes/         # field notes       ← gitignored, committed via content PRs
│   ├── architecture/  # design essays     ← gitignored, committed via content PRs
│   ├── projects/      # project writeups
│   ├── debug/         # debugging reference
│   └── about/
├── components/ui/     # Badge.astro and other primitives
├── styles/global.css
└── templates/         # copy to start a new post
public/                # favicon and static assets
```

## Writing a post

Copy `src/templates/note.astro` or `src/templates/architecture.astro`, then fill in the `metadata` export — the homepage and index pages auto-discover posts from this at build time:

```ts
export const metadata = {
  title: "Short, specific title",
  date: "YYYY-MM-DD",
  tag: "field note",   // field note · debugging · security · architecture · platform
  description: "One sentence describing what this explains.",
};
```

Scaffold scripts handle the boilerplate:

```sh
scripts/new-note.sh <slug>
scripts/new-architecture.sh <slug>
```

## CI / CD

| Job | Trigger | |
|---|---|---|
| Build | PR | Compiles the site and uploads `dist/` as an artifact |
| Spell check | PR | cspell over all `.astro` and `.mdx` source files |
| Lighthouse | PR | Accessibility, SEO, best-practices ≥ 100 · performance ≥ 90 |
| Deploy | Push to `gh-pages` | Builds and publishes to GitHub Pages |

Actions are pinned to commit SHAs. Dependabot opens weekly PRs to keep action SHAs and npm deps current.

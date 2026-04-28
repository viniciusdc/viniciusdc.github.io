# viniciusdc.github.io

> Platform engineering field notes, architecture essays, and project writeups.

[![Deploy](https://github.com/viniciusdc/viniciusdc.github.io/actions/workflows/deploy.yml/badge.svg)](https://github.com/viniciusdc/viniciusdc.github.io/actions/workflows/deploy.yml)
[![CI](https://github.com/viniciusdc/viniciusdc.github.io/actions/workflows/ci.yml/badge.svg)](https://github.com/viniciusdc/viniciusdc.github.io/actions/workflows/ci.yml)

**Live site → [viniciusdc.github.io](https://viniciusdc.github.io)**

---

## 🚀 Stack

| | |
|---|---|
| Framework | [Astro 6](https://astro.build) |
| Styling | [Tailwind CSS v4](https://tailwindcss.com) |
| Content | [MDX](https://mdxjs.com) + `.astro` pages |
| Hosting | GitHub Pages via GitHub Actions |

## 🧞 Commands

```sh
npm install          # install dependencies
npm run dev          # dev server at http://localhost:4321
npm run build        # production build → dist/
npm run preview      # preview the dist/ build locally
npm run spell        # run cspell spell-check locally
```

## 📁 Project structure

```
src/
├── layouts/         # Layout.astro, ArticleLayout.astro
├── pages/
│   ├── index.astro  # homepage
│   ├── notes/       # field notes (gitignored, committed via content PRs)
│   ├── architecture/# design essays (gitignored, committed via content PRs)
│   ├── projects/    # project writeups
│   ├── debug/       # debugging reference index
│   └── about/
├── components/
│   └── ui/          # Badge.astro and other primitives
├── styles/
│   └── global.css
└── templates/       # note.astro, architecture.astro — copy to start a post
```

## ✍️ Adding content

Copy a template from `src/templates/`, then fill in the `metadata` export at the top of the file — this is what the homepage and index pages use to auto-discover posts at build time:

```ts
export const metadata = {
  title: "Short, specific title describing the exact problem",
  date: "YYYY-MM-DD",
  tag: "field note",          // field note · debugging · security · architecture · platform
  description: "One sentence. What does this note explain and why does it matter.",
};
```

Scaffold scripts handle the boilerplate:

```sh
scripts/new-note.sh <slug>
scripts/new-architecture.sh <slug>
```

## 🔁 CI / CD

| Job | Runs on | Does |
|---|---|---|
| **Build** | PR | Compiles the site, uploads `dist/` artifact |
| **Spell check** | PR | cspell across `.astro` and `.mdx` source files |
| **Lighthouse audit** | PR | Scores accessibility, SEO, best-practices, performance |
| **Deploy** | Push to `gh-pages` | Builds and publishes to GitHub Pages |

All actions are pinned to commit SHAs. Dependabot opens weekly PRs to keep action SHAs and npm deps current.

<div align="center">

<h1>viniciusdc.github.io</h1>

<p>Platform engineering field notes, architecture essays, and project writeups.<br>
<sub>Kubernetes &nbsp;·&nbsp; TLS &nbsp;·&nbsp; identity &nbsp;·&nbsp; GPU runtimes &nbsp;·&nbsp; operator design</sub></p>

[![site](https://img.shields.io/badge/viniciusdc.github.io-live-5eead4?style=flat-square)](https://viniciusdc.github.io)
[![deploy](https://img.shields.io/github/actions/workflow/status/viniciusdc/viniciusdc.github.io/deploy.yml?branch=gh-pages&style=flat-square&label=deploy)](https://github.com/viniciusdc/viniciusdc.github.io/actions/workflows/deploy.yml)

<br>

![Astro](https://img.shields.io/badge/Astro_6-BC52EE?style=flat-square&logo=astro&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS_v4-06B6D4?style=flat-square&logo=tailwindcss&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat-square&logo=typescript&logoColor=white)
![MDX](https://img.shields.io/badge/MDX-F9AC00?style=flat-square&logo=mdx&logoColor=black)

</div>

---

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

# viniciusdc.github.io

Personal site — platform engineering field notes, architecture essays, and project writeups.

**[viniciusdc.github.io](https://viniciusdc.github.io)**

---

## Stack

- [Astro 6](https://astro.build) — static site generator
- [Tailwind CSS v4](https://tailwindcss.com) — utility-first CSS
- [MDX](https://mdxjs.com) — markdown with component support
- Deployed to GitHub Pages via GitHub Actions

## Local development

```sh
npm install
npm run dev        # http://localhost:4321
npm run build      # production build to dist/
npm run preview    # serve the dist/ build locally
```

## Content

Content lives under `src/pages/` and is gitignored by default — posts are committed via separate PRs.

| Section | Path | Format |
|---|---|---|
| Field notes | `src/pages/notes/<slug>/index.astro` | Short technical writeups |
| Architecture | `src/pages/architecture/<slug>/index.astro` | Long-form design essays |
| Projects | `src/pages/projects/<slug>/index.astro` | Project writeups |

### Adding a new post

Copy the relevant template from `src/templates/` and fill in the `metadata` export — this drives the index pages and homepage:

```ts
export const metadata = {
  title: "Short, specific title",
  date: "YYYY-MM-DD",
  tag: "field note",
  description: "One sentence description.",
};
```

Scripts to scaffold a new post:

```sh
scripts/new-note.sh <slug>
scripts/new-architecture.sh <slug>
```

## CI

| Job | Trigger | Purpose |
|---|---|---|
| Build | PR | Verify the site compiles |
| Spell check | PR | cspell across all `.astro` and `.mdx` files |
| Lighthouse audit | PR | Accessibility, SEO, best-practices, performance |
| Deploy | Push to `gh-pages` | Build and publish to GitHub Pages |

Dependabot runs weekly to keep npm deps and action SHAs current.

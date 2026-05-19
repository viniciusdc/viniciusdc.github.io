// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import tailwindcss from '@tailwindcss/vite';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import path from 'path';

/**
 * Inject a default `layout:` into MDX frontmatter when the file lives under
 * a content-page directory and the author didn't set one. Lets posts skip
 * the boilerplate header line in 99% of cases.
 */
function injectDefaultLayout(layoutPath, includeDirs) {
  return () => (_tree, file) => {
    const fm = file?.data?.astro?.frontmatter;
    if (!fm || fm.layout) return;
    const sourcePath = file.history?.[0] ?? file.path ?? '';
    if (!includeDirs.some((dir) => sourcePath.includes(dir))) return;
    fm.layout = layoutPath;
  };
}

export default defineConfig({
  site: 'https://viniciusdc.github.io',
  integrations: [
    mdx({
      remarkPlugins: [
        remarkMath,
        injectDefaultLayout('@/layouts/ArticleLayout.astro', [
          '/pages/writing/',
          '/pages/projects/',
        ]),
      ],
      rehypePlugins: [rehypeKatex],
    }),
  ],
  devToolbar: { enabled: false },
  vite: {
    plugins: [tailwindcss()],
    resolve: {
      alias: {
        '@': path.resolve('./src'),
      },
    },
  },
});

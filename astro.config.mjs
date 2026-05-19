// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import tailwindcss from '@tailwindcss/vite';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import path from 'path';

export default defineConfig({
  site: 'https://viniciusdc.github.io',
  integrations: [mdx({ remarkPlugins: [remarkMath], rehypePlugins: [rehypeKatex] })],
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
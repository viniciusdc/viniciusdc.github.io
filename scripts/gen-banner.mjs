#!/usr/bin/env node
// Regenerates .github/banner.svg
// Usage: node scripts/gen-banner.mjs

import { writeFileSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dir = dirname(fileURLToPath(import.meta.url));
const OUT = resolve(__dir, "../.github/banner.svg");

const W = 1200;
const H = 240;

const COLORS = {
  bg: "#090b0f",
  text: "#e2e8f0",
  accent: "#5eead4",
  dots: "#5eead4",
  muted: "#475569",
  rule: "#1e2530",
};

const FONT = "ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,monospace";

const circles = [
  { r: 180, w: 0.8, o: 0.10 },
  { r: 140, w: 0.8, o: 0.13 },
  { r: 100, w: 0.9, o: 0.17 },
  { r: 60,  w: 1.0, o: 0.22 },
  { r: 26,  w: 1.2, o: 0.30 },
];
const cx = 1020;
const cy = H / 2;

const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}" width="${W}" height="${H}">
  <defs>
    <radialGradient id="glow" cx="78%" cy="50%" r="38%">
      <stop offset="0%" stop-color="${COLORS.accent}" stop-opacity="0.08"/>
      <stop offset="100%" stop-color="${COLORS.accent}" stop-opacity="0"/>
    </radialGradient>
    <pattern id="dots" x="0" y="0" width="24" height="24" patternUnits="userSpaceOnUse">
      <circle cx="1.5" cy="1.5" r="1" fill="${COLORS.dots}" fill-opacity="0.12"/>
    </pattern>
    <clipPath id="clip">
      <rect width="${W}" height="${H}" rx="0"/>
    </clipPath>
  </defs>

  <rect width="${W}" height="${H}" fill="${COLORS.bg}"/>
  <rect x="560" y="0" width="640" height="${H}" fill="url(#dots)" clip-path="url(#clip)"/>
  <rect width="${W}" height="${H}" fill="url(#glow)"/>

${circles.map(({ r, w, o }) =>
  `  <circle cx="${cx}" cy="${cy}" r="${r}" fill="none" stroke="${COLORS.accent}" stroke-width="${w}" stroke-opacity="${o}"/>`
).join("\n")}
  <circle cx="${cx}" cy="${cy}" r="4" fill="${COLORS.accent}" fill-opacity="0.50"/>

  <rect x="0" y="0" width="3" height="${H}" fill="${COLORS.accent}"/>

  <text x="72" y="132"
    font-family="${FONT}"
    font-size="68" font-weight="700" fill="${COLORS.text}"
    letter-spacing="-2">vinicius</text>

  <text x="450" y="132"
    font-family="${FONT}"
    font-size="68" font-weight="700" fill="${COLORS.accent}"
    letter-spacing="-2">.dev</text>
</svg>
`;

writeFileSync(OUT, svg);
console.log(`wrote ${OUT}`);

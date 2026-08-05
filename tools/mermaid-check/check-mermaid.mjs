#!/usr/bin/env node
// Verifies that every ```mermaid fence in the given markdown files actually
// renders, not merely that it parses.
//
//   node tools/mermaid-check/check-mermaid.mjs docs/**/*.md
//   node tools/mermaid-check/check-mermaid.mjs          # defaults to docs/
//
// Why render and not parse: mermaid.parse() accepts gantt charts whose task
// names contain a colon, then throws while compiling task start times, so the
// chart never draws. A parse-only gate would have passed the very chart this
// repo added this check for. Rendering is the only honest check.
//
// jsdom has no layout engine, so SVG measurement is stubbed. That is fine
// here: the gate is about a chart compiling and drawing at all, not about
// the exact geometry it lands on.

import fs from 'node:fs';
import path from 'node:path';
import { JSDOM } from 'jsdom';

const dom = new JSDOM('<!doctype html><html><body><div id="host"></div></body></html>', {
  pretendToBeVisual: true,
});
global.window = dom.window;
global.document = dom.window.document;
Object.defineProperty(global, 'navigator', { value: dom.window.navigator, configurable: true });
global.CSSStyleSheet =
  dom.window.CSSStyleSheet || class { replaceSync() {} get cssRules() { return []; } };

const BOX = { x: 0, y: 0, width: 100, height: 20 };
for (const Ctor of [dom.window.SVGElement, dom.window.Element]) {
  if (Ctor && !Ctor.prototype.getBBox) Ctor.prototype.getBBox = () => BOX;
}
dom.window.SVGElement.prototype.getComputedTextLength = () => 100;

const mermaid = (await import('mermaid')).default;
mermaid.initialize({ startOnLoad: false, securityLevel: 'loose' });

function collectMarkdown(dir) {
  const out = [];
  if (!fs.existsSync(dir)) return out;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) out.push(...collectMarkdown(full));
    else if (entry.name.endsWith('.md')) out.push(full);
  }
  return out;
}

// Returns { source, line } for each fence, line being 1-indexed and pointing
// at the fence opener so a failure is clickable.
function extractFences(text) {
  const fences = [];
  const lines = text.split('\n');
  let open = null;
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (open === null) {
      if (/^\s*```mermaid\s*$/.test(line)) open = { start: i, body: [] };
    } else if (/^\s*```\s*$/.test(line)) {
      fences.push({ source: open.body.join('\n'), line: open.start + 1 });
      open = null;
    } else {
      open.body.push(line);
    }
  }
  if (open !== null) {
    fences.push({ source: open.body.join('\n'), line: open.start + 1, unterminated: true });
  }
  return fences;
}

const args = process.argv.slice(2);
const files = args.length ? args : collectMarkdown('docs');

if (files.length === 0) {
  console.log('No markdown files to check.');
  process.exit(0);
}

let charts = 0;
let failures = 0;
const host = document.getElementById('host');

for (const file of files) {
  let text;
  try {
    text = fs.readFileSync(file, 'utf8');
  } catch (err) {
    console.error(`${file}: cannot read (${err.message})`);
    failures++;
    continue;
  }

  for (const fence of extractFences(text)) {
    charts++;
    const where = `${file}:${fence.line}`;

    if (fence.unterminated) {
      console.error(`FAIL ${where}  mermaid fence is never closed`);
      failures++;
      continue;
    }
    if (!fence.source.trim()) {
      console.error(`FAIL ${where}  mermaid fence is empty`);
      failures++;
      continue;
    }

    try {
      await mermaid.render(`c${charts}`, fence.source, host);
      console.log(`ok   ${where}`);
    } catch (err) {
      const detail = String(err && err.message ? err.message : err).split('\n')[0];
      console.error(`FAIL ${where}  ${detail}`);
      failures++;
    }
  }
}

console.log(`\n${charts} chart(s) checked, ${failures} failed`);
process.exit(failures === 0 ? 0 : 1);

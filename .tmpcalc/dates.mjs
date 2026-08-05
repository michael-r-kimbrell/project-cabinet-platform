import { JSDOM } from '/home/user/project-cabinet-platform/tools/mermaid-check/node_modules/jsdom/lib/api.js';
const dom = new JSDOM('<!doctype html><html><body></body></html>', { pretendToBeVisual: true });
global.window = dom.window; global.document = dom.window.document;
Object.defineProperty(global, 'navigator', { value: dom.window.navigator, configurable: true });
global.CSSStyleSheet = dom.window.CSSStyleSheet || class { replaceSync(){} get cssRules(){return []} };
const g = await import('/home/user/project-cabinet-platform/tools/mermaid-check/node_modules/mermaid/dist/chunks/mermaid.core/ganttDiagram-PKOTCBZU.mjs');
const d = g.diagram;
export function tasks(text) {
  d.db.clear(); d.parser.yy = d.db; d.parser.parse(text);
  return d.db.getTasks();
}

import fs from 'node:fs';
const { tasks } = await import('./dates.mjs');
const base = fs.readFileSync('.tmpcalc/new.mmd', 'utf8');
const f = d => new Date(d).toISOString().slice(0,10);
const t = tasks(base);
const key = ['order1','lead1','k4b','k5','k13','movein'];
console.log('--- baseline: 14d transit + 14d your finishing ---');
for (const x of t) if (key.includes(String(x.id)))
  console.log(String(x.id).padEnd(7), f(x.startTime), '->', f(x.endTime), ' ', x.task.trim());
console.log('\n--- scenarios (transit x finishing) ---');
console.log('transit  finishing  doors ready  move-in     September?');
for (const tr of [14, 21]) {
  for (const fin of [3, 7, 10, 14]) {
    const r = tasks(base
      .replace('lead1, after order1, 14d', `lead1, after order1, ${tr}d`)
      .replace('k4b, after lead1, 14d', `k4b, after lead1, ${fin}d`));
    const g = id => f(r.find(z => z.id === id).endTime);
    const mi = g('movein');
    console.log(String(tr+'d').padEnd(8), String(fin+'d').padEnd(10), g('k4b').padEnd(12), mi.padEnd(11), mi < '2026-10-01' ? 'YES' : 'no');
  }
}

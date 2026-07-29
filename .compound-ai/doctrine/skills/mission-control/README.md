# Mission Control

Part of the Compound AI Operating Standards v3.0.10 kit.

## What this produces

A single-file, self-contained operations dashboard. KPI cards with RAG status, sparklines, role-based view filtering, a refresh button, and a live-data hook (`window.setMetric`) for wiring real telemetry. Designed as the "status page" for any project: drop it on a TV in the war room, host it on an internal subdomain, or open it from a bookmark before standup.

## Capabilities

- **Responsive grid layout:** CSS Grid with `repeat(auto-fit, minmax(260px, 1fr))` so cards reflow from 4-up on desktop to 1-up on mobile. A second `.grid-wide` lane handles 400px+ minimum cards (tables, multi-stat panels).
- **Live data slot placeholders:** every metric carries a `data-metric="some.key"` attribute. Call `window.setMetric('some.key', '99.5%', [optional, spark, points])` from your data layer to update value and sparkline together.
- **RAG status indicators:** cards take a `rag-green` / `rag-amber` / `rag-red` class for the colored left border, plus an inline `.rag-dot` for the corner indicator. Status pill in the header surfaces system-level state.
- **Role-based view filter:** the header role toggle (`All`, `Exec`, `Ops`, `Eng`) hides any card whose `data-roles` attribute doesn't include the active role.
- **Per-card sparkline placeholder:** inline SVG with a `<polyline data-points="...">` element. The JS normalizes the numeric series into the viewBox automatically. Set new points via `data-points` and call `renderSparklines()` (or use `setMetric` with the points arg).
- **Refresh button:** spins an icon, demonstrates a hook for wiring your fetch logic, and updates the last-updated timestamp.
- **Last-updated timestamp:** monospace, auto-counts up (just now / Ns ago / Nm ago / Nh ago).
- **Theme toggle:** light/dark via `data-theme` on `<html>`.
- **Clean header:** project-name placeholder slot, brand icon, system status pill, and toolbar.

## How to use it

1. Open `index.html` in any modern browser. No build step.
2. Replace the `[PROJECT NAME]` placeholder in the header brand.
3. For each card you care about, set `data-metric="some.key"` on the value element and matching `data-spark="some.key"` on the sparkline SVG.
4. Wire your data layer. Example:
   ```js
   fetch('/api/health').then(r => r.json()).then(d => {
     setMetric('kpi.a', d.uptime + '%', d.last24h);
     setMetric('kpi.b', d.completionRate + '%', d.weekly);
   });
   ```
5. Tag cards with `data-roles="all,exec,ops"` so the role filter behaves the way you want.
6. Deploy as static HTML. For live dashboards, host behind a tiny JSON endpoint and poll on an interval.

## Tier 2 skills that pair well

- **`viz`** for picking the right metric type (gauge vs sparkline vs bullet), threshold colors, and density discipline.
- **`audit`** to evaluate accessibility (RAG colors paired with text labels, not color alone), keyboard reachability, contrast.
- **`shape`** to plan which roles see which cards before you fill the grid.
- **`adapt`** to tune the responsive breakpoints if you target a specific display.
- **`optimize`** if the dashboard refreshes faster than the page can keep up.

## What this is NOT

- Not Grafana, Datadog, or New Relic. No time-series database, no query language, no metric ingestion. You bring the data.
- Not a real-time framework. There is no WebSocket layer; if you need push, plumb it in yourself.
- Not an alert engine. Alerts are presentational; pager logic, escalation, and on-call rotation live in PagerDuty/Opsgenie/your tool of choice.
- Not a project management tool. The workstream table is a status surface, not a Jira/Linear replacement.
- Not multi-tenant. There is no row-level security or per-user state.

<!-- Regression fixture: MUST fail check-mermaid.mjs. Not real documentation. -->
<!-- A colon inside a gantt task name parses cleanly but yields a task with no -->
<!-- start time, so the chart throws while compiling and never draws. -->

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    section Kitchen
    Painter: face frames, window, trim  :k4, 2026-08-05, 5d
    Build new drawers                   :k6, after k4, 2d
```

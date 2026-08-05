<!-- Regression fixture: MUST fail check-mermaid.mjs. Not real documentation. -->
<!-- A task name beginning with "Call" collides with mermaid's `call` callback -->
<!-- keyword and is a hard parse error. -->

```mermaid
gantt
    dateFormat YYYY-MM-DD
    section Orders
    Call sub re downstairs bath  :crit, order5, 2026-08-05, 2d
```

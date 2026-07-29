# Doctrine: fleet measurement (evals, baselining, drift)

An agent fleet you cannot measure is a fleet you re-baseline by vibes. Three instruments, one principle:
instrument BEFORE the pilot, so day one of real traffic has day-zero baselines.

1. **DORA over the dispatch chokepoint** (one CLI over the dispatch event log, plus a nightly derived rollup
   to a dated knowledge file): dispatch frequency, lead time p50/p90, change-failure rate
   with per-gate attribution plus substitution rate, recovery time. Every number carries its sample size;
   thin windows say "insufficient data" rather than inventing a trend (derived-not-typed).
2. **The utilization ledger** (one append-only markdown file in the orchestration repo): per-agent, per-task verdicts
   (strong/adequate/weak/failed) with friction codes. This is the re-baselining input: seats are composed
   from evidence, and an agent that drifts weak gets benched by record, not memory. Append-only;
   corrections are new lines.
3. **Lane health** (a scheduled probe script writing a machine-readable health file): cheap auth/latency probes per lane,
   consumed by the scheduler. Drift in a lane's availability is data before it is an incident.

Corollary: measurement artifacts are DERIVED. A hand-typed metric is a future lie
(see derived-not-typed.md).

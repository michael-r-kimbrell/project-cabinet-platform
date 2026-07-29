# Era 01 to Era 02 Checklist: Demo to Ramp-up
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: CC BY 4.0

Era 01 (Demo): Can this work?
Era 02 (Ramp-up): Can this run unattended?

Complete this checklist to graduate from Era 01 to Era 02.

## Required for Era 02

- [ ] Scheduled jobs produce artifacts on a defined cadence
- [ ] At least one downstream consumer depends on the output
- [ ] Provider fallback chain is in place (primary -> secondary -> fallback)
- [ ] Cache layer exists (even if hit rate is not yet measured)
- [ ] Session logs exist and are being updated each session
- [ ] STATE.md is being maintained (not just the session log)
- [ ] BACKLOG.md exists with at least the known open items

## Signals you are in Era 01 (not yet Era 02)
- Silent failures produce empty tables, not alerts
- Observability is print statements
- No one else depends on the output
- The system only runs when you manually trigger it
- Context is re-explained from scratch every session

## Signals you are in Era 02
- Scheduled jobs run without manual intervention
- Someone downstream depends on the output
- You notice silent drift in the weekly review, not in the moment
- The system runs while you sleep

## What Era 02 does NOT require
- Schema validation at every LLM boundary (that is Era 03)
- Lineage on every synthesized artifact (that is Era 03)
- Measured cache hit rates (that is Era 03)
- Quality immune system (that is Era 03)

Do not over-engineer Era 01 systems toward Era 03 standards.
The arc requires a working thing to harden.

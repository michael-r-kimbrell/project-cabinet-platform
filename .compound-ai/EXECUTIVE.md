# Compound AI Operating Standards: the executive read

*Cameron Sutcliff and Joshua Sutcliff. Open source. Apache-2.0 (code) and CC-BY-4.0 (docs).*

If you are sponsoring an AI initiative and your team handed you this repo, this page is the 90 seconds you need. The detail is in the field guide; the proof is in `proof/`; this is the why.

## The problem you are paying for

Most AI work resets. Every session re-explains the project. Every synthesis rebuilds from zero. Every expensive model call runs whether or not its inputs changed. Every output dies the moment it is read. The cost is silent and continuous, and it is the single most common reason organizations say "we tried AI and it did not stick." The spend shows up; the compounding value does not.

## What this changes

This kit turns ad-hoc AI usage into an operating standard, the same way teams once moved from scripts to engineering practice. Under the standard, memory lives in files, context loads in tiers instead of all at once, synthesis builds on prior state, expensive work is cached and measured, and every output carries a schema, a source trail, and a quality gate. A new operator picks up the work without an oral history. A bad output cannot quietly overwrite a good one. The system gets cheaper and more reliable the longer it runs.

Three promises, falsifiable:

1. Sessions stop reloading the same context.
2. Models stop spending expensive reasoning on cheap tasks.
3. Outputs become repeatable, auditable, and safer to reuse.

## Why it is credible, not a deck

- **It was paid for in production, not theorized.** The patterns come from running several agentic systems on one machine on a subscription budget. The discipline exists because the absence of it once destroyed an overnight run: a single ungoverned database handle collapsed 18 of 22 workstreams. The fix (shared connections, attribution, observability, fail-visible recovery) is the kit, not a slide.
- **The savings are measured and reproducible.** A realistic un-tiered setup carries many times the context this kit loads at the start of every session, and keeping the full reference resident costs an order of magnitude beyond that. The kit routes to one short procedure on demand instead. The benchmark runs on a bare laptop with no paid API: `bash proof/session-start-benchmark/measure.sh`. It measures context-loading cost, the thing you pay for repeatedly, not a marketing number.
- **The enforcement is real where it can be, and honest where it cannot.** On Claude Code the kit hard-blocks the two most expensive mistakes (spinning up costly sub-agents and unbounded fan-out) through runtime hooks. Continuous-integration gates block structural drift on every change. On other agents the same rules are carried as contracts the agent honors rather than mechanical blocks. The kit states this distinction plainly in `docs/known-limits.md` rather than claiming universal enforcement. A standard you can trust is one that tells you where its teeth are.

## What to look at in five minutes

- `README.md` for the shape and the install paths.
- `proof/session-start-benchmark/` and run `measure.sh` yourself.
- `enforcement/bin/check-kit.sh` and `enforcement/tests/run-selftest.sh`: the gates and the planted-violation self-test that proves they fire.
- `docs/known-limits.md`: what is enforced, what is advisory, what is human-controlled.

## Honest about maturity

This is an operating standard with a working reference runtime, not a product with a sales team. Adoption is early and the kit says so. The reference runtime's hard enforcement is strongest on Claude Code today; broad multi-agent enforcement is a contract, not yet a mechanical guarantee on every runtime. What is here is real, runnable, and reproducible. What is aspirational is labeled. The early v3.0.x releases all shipped the same day; they are pre-publication hardening passes from a multi-model review, not churn between adopted versions.

## Who built it

A co-owned standard by Cameron Sutcliff and Joshua Sutcliff. The portable doctrine, the tiered context model, and the skill library are Cameron's; the enforced Claude Code runtime is Joshua's, hardened by a real operating incident. Both authors are credited in `NOTICE` and `CITATION.cff`. Take it, run it, fork it, attribute it.

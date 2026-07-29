# Skill: token-economist
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Audits a workflow or session for token waste and recommends optimizations.

## Triggers
"token audit", "optimize context", "reduce cost", "why is this expensive", "cache this"

## What it checks
1. Is the session loading more context than the task requires? (tiering violation)
2. Is a synthesis-tier model being used for a parsing task? (routing violation)
3. Is a repeated synthesis call missing a cache check? (cache gap)
4. Is the prompt rebuilding from scratch when prior state exists? (evolution gap)
5. Is the cache hit rate being measured? (attribution gap)

## Diagnostic output format
```
TOKEN AUDIT REPORT
Session type: [mechanical / subsystem / cross-subsystem / architecture / bootstrap]
Context loaded: [tokens] -- [optimal / over-loaded / under-loaded]
Model routing: [correct / violation: task X routed to tier Y, should be tier Z]
Cache status: [present / missing / present but not measured]
Prior state: [used / missing -- synthesis rebuilding from scratch]
Recommendation: [specific action]
```

## Source references
- `code/cache_key.py` -- cache key construction and response cache
- `code/pipeline_runs.sql` -- cache attribution table
- `AGENT.md` -- model routing table
- Field Guide Chapter 12: LLM Response Caching
- Field Guide Chapter 13: Cache Attribution
- Field Guide Chapter 17: Model Routing by Cognitive Load

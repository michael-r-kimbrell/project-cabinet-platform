# Tier 2: Capabilities

The workhorse layer. Skills and templates that you load when the task calls for them. Most sessions touch 1-3 of these.

## What this tier owns

- **`skills/`**  -  15 capability skills:
  - **Cognitive modes (7):** parallel-lens-synthesis, consequence-simulation, cross-domain-translation, convergence-detection, detached-judgment, simulation-to-action-bridge, nod-protocol  -  these change HOW you reason
  - **Analytical capabilities (5):** ultra-think (multi-angle analysis), code-audit (dependency / dead code / coverage audit), autoresearch (structured research), skill-creator (build new skills), pressure-test (adversarial review with CEO lenses + GSTACK scope modes)
  - **Domain capabilities (2):** viz (chart selection + dashboard design grounded in Few/Kriebel), stakeholder-mapping (influence-interest grid + engagement strategy)
  - **Orchestration (1):** loop-engineering (Loop Spec governance for recurring, self-prompting agent runs)
- **`templates/`**  -  reusable output templates: lineage-record, loop-spec, model-routing, quality-gates, token-budget

## Rules at this tier

1. **Skills must be domain-useful.** A skill that only matters in one specific deliverable type belongs in Tier 3.
2. **No duplication of Tier 1.** Reference upstream conventions, do not copy.
3. **Pointer pattern enforced.** Every `SKILL.md` under 100 lines, target 80. Deep content goes in `skills/<name>/reference/`.
4. **Routing-friendly.** Every skill must declare trigger phrases that the Tier 1 `request-router` can dispatch on.

## How the router fires these

When the user's request matches a skill's trigger phrases, the `request-router` loads the matching skill and follows it. The user does not need to know which skill applies  -  the router is the dispatcher.

For compound requests (analysis → decision → action), the router applies skills in sequence. See `../doctrine/skills/request-router/SKILL.md` for the compound-request patterns.

## Escalate up / drill down

- **Up:** `../doctrine/tiers/AGENT-tier1.md` for conventions, context, and core skills
- **Down:** `../doctrine/tiers/AGENT-tier3.md` for project shells that consume these capabilities

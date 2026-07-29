# agent-panel-review: Known Agent Strengths

A reference for who to put on which panel role. The kit is vendor-
neutral and the protocol works with any combination, but some agents
are better matched to some roles. Use this as a starting point, not as
a constraint.

This list is current as of the kit's last update and will drift as
models evolve. Verify against your own experience.

---

## Claude (Anthropic; Opus and Sonnet tiers)

**Strongest at:** voice work, foreword and narrative arc, editorial
governance, attribution architecture, cross-platform translation,
detached synthesis, long-context document work.

**Use for roles:** voice, synthesizer, integrator, translator.

**Known weaknesses:** can over-soften when asked to critique; tends
toward hedging unless explicitly told to take positions.

---

## Codex (OpenAI; GPT-5 / o-series)

**Strongest at:** product architecture, packaging discipline,
provenance scripts, manifest generation, file-level mechanics,
structural spine, tight code execution.

**Use for roles:** architecture, integrator, builder, critic (for
mechanics).

**Known weaknesses:** less natural at voice work; can over-engineer
when asked to design.

---

## Kiro (Amazon; agentic IDE)

**Strongest at:** substance migration, spec-driven development,
technical accuracy passes, code generation from existing
implementations, body-of-content work where the source material is
already specified.

**Use for roles:** substance, builder, technical-accuracy reviewer.

**Known weaknesses:** less suited to ground-up generative work; works
best when given clear specs to execute against.

---

## Gemini (Google; Gemini 2.x and code-assist variants)

**Strongest at:** large-context corpus review, comparative analysis
across many documents, multi-modal grounding (text + images + tables),
free-tier multi-pass synthesis when budget matters.

**Use for roles:** researcher, comparative-analysis reviewer, large-
context synthesizer.

**Known weaknesses:** can be uneven on tight editorial work; benefits
from explicit format constraints.

---

## Aider (open-source; pairs with any backing model)

**Strongest at:** surgical git-aware refactors, narrow code edits with
tight commit discipline, repo-context-aware diffs that respect existing
conventions.

**Use for roles:** builder (for narrow code changes), integrator (for
merging code-level revisions).

**Known weaknesses:** designed for code, not narrative; not the right
choice for editorial panels.

---

## Cursor and Continue (IDE-resident agents)

**Strongest at:** pair-programming with inline accept/reject, in-flow
code generation, autocomplete-extended workflows.

**Use for roles:** builder during active coding sessions, especially
where the operator is iterating quickly.

**Known weaknesses:** the inline-acceptance loop is not well-suited
to multi-stage panel protocols where outputs need to be sealed and
exchanged. Use for production, not panel orchestration.

---

## Local models (Ollama / local gateway runtimes / similar)

**Strongest at:** no-cost grunt work, parsing, summarization at modest
quality, RSS pulls, log scans, background tasks where latency tolerance
is high.

**Use for roles:** researcher (for bulk gathering), pre-panel data
prep. Generally not strong enough for primary panel roles on high-
stakes deliverables, but excellent at the work that feeds the panel.

**Known weaknesses:** quality ceiling is below frontier models; not
the right choice for the final-output role on most panels.

---

## Same-model panels

A panel does not require different models. Three Claude sessions in
three different roles (with three different system prompts or named
personas) captures ~70% of the cross-model panel benefit and avoids
the overhead of orchestrating multiple platforms.

Same-model panels work especially well when:
- The roles are clearly distinct and the system prompts enforce them
- The seal in Stage 2 holds (separate sessions, no shared context)
- The operator can run all three sessions in parallel

Same-model panels work poorly when:
- The roles are slight variations of each other (system prompts converge)
- The model has a specific blind spot that every session shares

---

## Picking panel composition

Quick heuristics:

- **Editorial work, three roles.** Claude (voice) + Codex (architecture)
  + Kiro or Codex (substance). Or three Claude sessions with role
  prompts.
- **Code review, two roles.** Codex or Claude (builder) + the other
  (critic). Aider is a fine substitute for either.
- **Strategic analysis, three roles.** Gemini (researcher) + Claude
  (skeptic with `nod-protocol`) + Claude (synthesizer). Or three
  sessions of the strongest model you have access to.
- **Decision pressure-test, two roles.** Any two strong models, with
  one assigned the proponent role and one the devil's advocate role.
  Pairs with `nod-protocol`.

If you do not have access to multiple platforms, the same-model panel
works. The protocol is what matters; the variety is a multiplier, not
a requirement.

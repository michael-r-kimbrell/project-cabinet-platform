# agent-panel-review: Role Templates

Roles are functions, not identities. Any agent can hold any role. Pick
the template that matches your deliverable.

---

## Template 1: Editorial deliverables (docs, foreword, narrative)

| Role | Owns | Failure mode |
|---|---|---|
| **Voice** | Tone, foreword, audience layering, attribution architecture | Pretty prose, no substance |
| **Substance** | The actual content body, code samples, technical accuracy | Strong content, weak narrative arc |
| **Architecture** | Structural spine, packaging, provenance, manifest discipline | Clean structure, dry content |

This is the canonical three-panelist editorial split. Pair: a strong-voice
agent (Claude/Opus), a substance-heavy agent (Kiro/Codex), and an
architecture-discipline agent (Codex/o-series).

---

## Template 2: Code review

| Role | Owns | Failure mode |
|---|---|---|
| **Builder** | Wrote the code or proposes the patch | Defends the original instinct too long |
| **Critic** | Reads the patch with adversarial eyes; finds bugs, edge cases, tests | Finds issues but no path forward |
| **Integrator** (optional) | Decides what to merge; balances cost and value | Trim too aggressively if not paired with critic |

For most code review, two panelists (builder + critic) is sufficient.
Add an integrator for high-stakes changes (architecture, public APIs,
data migrations).

---

## Template 3: Strategic analysis

| Role | Owns | Failure mode |
|---|---|---|
| **Researcher** | Gathers evidence, finds base rates, surfaces precedents | Strong evidence, no synthesis |
| **Skeptic** | Stress-tests assumptions, finds the case against | Right about what is wrong, weak on what to do |
| **Synthesizer** | Produces the integrated position with stated confidence | Smooth synthesis, missed contradictions |

This template pairs naturally with `nod-protocol`: the skeptic's role
output is the opposite case for Gate 2.

---

## Template 4: Two-panelist decision pressure-test

| Role | Owns | Failure mode |
|---|---|---|
| **Proponent** | Defends the proposed decision | Confirmation bias |
| **Devil's advocate** | Constructs the strongest opposite case | Strawman opposites |

Pair with `nod-protocol` for full gated rigor. The devil's advocate's
output is Gate 2; the proponent's output is Gate 1; the operator runs
Gates 3-5.

---

## Template 5: Cross-platform translation

| Role | Owns | Failure mode |
|---|---|---|
| **Original-audience writer** | Crafts the deliverable for its native audience | Insider language, opaque to outsiders |
| **Translator** | Re-encodes for a different audience without losing fidelity | Loses sharp specifics in the translation |
| **Reviewer** | Verifies the translation preserves the key claims | Lets fidelity drift |

Useful when the same content must work for multiple audiences (exec
brief + builder docs, public-facing + internal-only).

---

## Picking the right template

Quick decision tree:

- Is the deliverable a document? → Template 1
- Is the deliverable code? → Template 2
- Is the deliverable an analysis or a recommendation? → Template 3
- Is the deliverable a single decision (yes/no, A/B)? → Template 4
- Does the deliverable need to land for two distinct audiences? →
  Template 5

If none fit cleanly, ask which functions the deliverable needs:
production, critique, integration. That is the underlying shape of
every panel.

---

## Role assignment to specific agents

`agent-strengths.md` covers known model strengths. Roles are not
permanently bound to specific models. A given Claude session can hold
the substance role on one panel and the voice role on the next.

For consistency on a multi-loop project (the same panel reviewing
multiple deliverables), keep role assignments stable across loops.
Mid-project role swaps create unnecessary cognitive churn.

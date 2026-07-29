# Install
# Compound AI Operating Standards v3.0.10
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

The kit is a tiered set of files. You can drop the directory into your project
manually, or run the scripted installer:

```bash
bash adoption/install.sh
```

Non-interactive: `bash adoption/install.sh --yes`. The script copies the kit
into `operating-standards/` under your project root, asking before it overwrites
any existing file. Verify with:

```bash
bash operating-standards/enforcement/bin/check-kit.sh operating-standards
```

Preview without writing anything:

```bash
bash adoption/install.sh --dry-run
```

The dry run prints every file the installer would copy and the Claude Code
settings keys it would add or merge. To remove Compound AI Claude Code hook
wiring later without deleting kit files or project notes:

```bash
bash adoption/install.sh --uninstall
```

Uninstall restores the prior Claude settings hook keys from
`settings.json.compound-ai-bak` when that backup exists. If there is no backup,
it removes only hook keys that still exactly match the kit fragment.

Otherwise, point your agent at `adoption/ADOPT.md` for an existing project or
`HANDOFF.md` for a new one.

What follows is the one decision that affects how much value you get
out of the kit: **do you have access to multiple AI agents?**

---

## The multi-agent question

The kit's most powerful skills (`agent-panel-planning` and
`agent-panel-review`) are panel patterns. They produce signal that no
single agent can produce alone: independent first-pass framings, sealed
cross-critique, strength-matched task assignment from demonstrated
dominance. **A panel needs at least two agents.**

If you have access to two or more agents already, the panel skills light
up immediately. If you only have one, the rest of the kit still works
(24 of the 26 skills are single-agent skills; only the two panel skills
need a second agent), but you are leaving the highest-leverage patterns
on the table.

The good news: forming a panel does not require paid subscriptions to
three frontier models. The patterns work with same-platform sessions in
different roles, with free-tier accounts, with local models, and with
mixed setups. The discipline is what matters; the variety is a
multiplier, not a requirement.

---

## If you already have multiple agents

Skip the rest of this file. Read `HANDOFF.md` next, then `AGENT.md`,
then `_skills-index.md`. The panel skills are loaded by default in
Tier 1. Convene them when high-stakes deliverables warrant it.

If those agents have separate skill directories, also read
`doctrine/conventions/universal-skill-routing.md`. The preferred
machine setup is: each agent reads its native skill root, while shared skills
route by symlink to `~/.compound-ai/skills`.

---

## If you have one agent (and want more)

Here are sensible additions, free or low-cost first.

### Free or near-free options

| Option | What it is | Why it pairs well |
|---|---|---|
| **Claude free tier** | Anthropic's free Claude tier (with daily message limits) | Strong at voice, attribution, narrative synthesis. Pair with a more mechanics-focused agent. |
| **GPT free tier (ChatGPT)** | OpenAI's free tier | Strong at general reasoning, decent at code mechanics. Pair with a voice-focused agent. |
| **Gemini free tier** | Google's free Gemini tier with large context windows | Strong at large-context corpus review and comparative analysis. Useful as a researcher role in three-panel setups. |
| **Aider + local Ollama models** | Open-source Aider paired with locally-run Llama or Qwen via Ollama | Zero cost beyond electricity. Strong at surgical code edits with git discipline. Best as a builder role. |
| **Continue.dev (free tier)** | IDE-resident agent that connects to multiple model backends including free ones | Strong at in-flow code generation. Pair with a separate session for review. |

For most operators starting out, **Claude + one of {GPT, Gemini}** is
the cleanest two-agent setup. Both have usable free tiers. The role
split typically becomes voice/synthesis (Claude) + mechanics/research
(GPT or Gemini).

### Same-model panels also work

You do not need different model platforms to run a panel. Three sessions
of Claude with three different role prompts (voice / substance /
architecture, or builder / critic / integrator) captures roughly 70% of
the cross-platform panel benefit. The discipline is keeping the
sessions genuinely separate: no shared workspace context, no leaky
session memory.

Same-model panels work especially well when:
- The roles are clearly distinct and the system prompts enforce them
- The seal in Stage 2 holds (separate sessions, no shared context)
- The operator can run all three sessions in parallel

### Paid options if you want frontier capability

If your work is high-stakes enough that you want frontier capability
across the panel:

- **Anthropic Claude Pro / Max** for Claude Opus access
- **OpenAI Plus / Pro** for GPT-5 / o-series access
- **Cursor Pro** or **Continue Pro** for IDE-resident frontier models
- **Amazon Kiro** (where available) for spec-driven panels
- **Google Gemini Advanced** for large-context work

The kit is vendor-neutral. None of these are required. They are
useful if your work justifies the cost and you can sustain a
multi-agent operating discipline.

---

## The discipline question (read this even if you have multiple agents)

Having multiple agents is necessary but not sufficient for the panel
patterns to work. The discipline includes:

1. **Sealed independent passes.** Stage 2 of any panel protocol must
   not leak between agents. If you accidentally paste one agent's
   draft into another's prompt, restart that panelist's pass.

2. **Structured critique, not free-form complaint.** The four-cell
   template (strongest claim / weakest claim / shared blind spot /
   one thing worth stealing) is the format. Without it, critique
   becomes negging.

3. **Operator owns the merge.** The panel is advisory. The operator
   decides what ships. This stays true whether you use a convened
   panel (per deliverable) or a standing panel (the same agents in
   permanent operating relationship).

4. **Threshold discipline on convening.** Most work does not need a
   panel. Use the panel-offer pattern (the router will surface it
   when your request signals council-tier intent) rather than
   convening on every minor question.

If you cannot sustain the discipline yet, start with single-agent
work, get familiar with the kit's skills, then add a second agent
when you hit a deliverable that genuinely warrants it.

---

## Optional: usage awareness (ccusage)

This step matters only if you install the enforced Claude Code runtime
(`runtime/claude-code/`). It is not needed for the portable doctrine or the
panel patterns above.

`ccusage` is a third-party CLI that reads Claude Code's local session-cost data
so the usage-guard hook can reason about metered spend against a configured
ceiling. Install it once, globally:

```bash
npm install -g ccusage
```

You can also run it without installing via `npx ccusage`; the hook will use a
globally installed binary if it finds one on `PATH`.

The kit works without ccusage. When the binary is absent, the usage-guard hook
falls back to local character/prompt-length estimation: it never makes a metered
API call, never blocks legitimate work on a missing or broken probe (it is
fail-open), and at most attaches an advisory note. ccusage simply upgrades the
ceiling from an estimate to a read of Claude Code's own cost data. The
authoritative figure remains Claude Code's `/usage` command. See
`capabilities/usage-discipline.md` and `docs/known-limits.md`.

---

## What to read next

1. `README.md`: what ships in the kit
2. `HANDOFF.md`: the drop-in prompt for handing the kit to a fresh agent
3. `AGENT.md`: the root operating contract
4. `_skills-index.md`: complete skill registry with triggers
5. `doctrine/skills/request-router/SKILL.md`: the routing
   table that matches your requests to skills
6. `doctrine/conventions/universal-skill-routing.md`: optional
   multi-agent shared-skill routing convention

That is the minimum read. Twenty minutes total. After that, the kit is
operational and you can dive into specific skills as needed.

---

## The pitch, in one sentence

If you ship AI work that has to be defensible the next day, the panel
patterns alone justify the cost of forming a two-agent setup. Adam
Federman called the v2.0 cognitive-mode layer a skeleton until v2.1
operationalized it. The same logic applies to the panel layer: it is
inert until you have at least two agents pointed at it. Get the second
agent.

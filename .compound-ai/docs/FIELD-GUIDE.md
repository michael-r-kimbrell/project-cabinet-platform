# Compound AI Operating Standards

*A field guide for token economics, repeatable engagement, and durable agentic systems.*

**What this is:** the deep reference for the kit, the why behind the way it is
built. It is NOT required reading to adopt the kit; the README, `EXECUTIVE.md`,
and `adoption/ADOPT.md` are. Read this when you want the full reasoning.
**Author:** Cameron Sutcliff (the field guide is the authored manual; the kit
and its enforced runtime are co-owned with Joshua Sutcliff, see `NOTICE`).
**Canonical source:** `github.com/cameronpsutcliff/compound-ai`
**Landing page:** `cameronsutcliff.com/compound-ai`
**License:** CC BY 4.0 (docs), Apache 2.0 (code samples). See `LICENSE`.

---

## Foreword

I run several agentic systems on one machine. Together they produce daily competitive briefs across 22 verticals, run an automated outreach pipeline for a directory site, schedule and triage a control plane for several other agents, ghostwrite a social presence under a voice profile, and paper-trade a strategy I am no longer working on. They share one human operator and zero API spend beyond a subscription. The interesting part is not that they all run. The interesting part is that they did not always.

The failure that made this manual necessary was an overnight intelligence run that should have been routine. The system was supposed to process 22 verticals. By morning, 18 were gone. The root cause was not a model outage, a bad prompt, or a missing API key. It was a cache that opened its own SQLite handle on every LLM call. On paper, the system had a single-writer architecture. In production, one path around that discipline was enough to make the work collapse.

The fix was not more prompting. It was shared connection threading through a ContextVar, cache attribution, phase-level observability, and a rule that any automated workflow downstream of an LLM boundary has to be durable enough to fail visibly and recover cleanly. That is the difference between a clever AI demo and an operating system for repeatable work.

That incident is in this manual because it cost real work and taught a real pattern. Every other pattern here has the same provenance. None of this came from a deck. It came from production, and it was paid for in tokens, sleep, and one Sunday morning when I'd rather have been elsewhere.

The frame this manual offers is simple. **Most AI work resets.** Every session re-explains the project. Every synthesis rebuilds from zero. Every expensive call runs whether or not the inputs changed. Every output dies the moment it is read. The cost is silent and continuous, and it is the reason most organizations report "we tried AI and it did not stick."

**The alternative is AI work that compounds.** Memory lives in files. Context loads in tiers. Synthesis evolves from prior state. Caches are measured. Outputs have schemas, lineage, and quality gates. A new operator can pick up the work without an oral history. A bad output cannot quietly overwrite a good one. The system gets cheaper and more reliable the longer it runs.

This manual is the field guide for getting from the first state to the second. It promises three things to anyone who works through it:

1. Your sessions will stop reloading the same context.
2. Your models will stop spending expensive reasoning on cheap tasks.
3. Your outputs will become repeatable, auditable, and safer to reuse.

It is not a prompt library. It is not a model comparison. It is not a vendor pitch. It is an operating standard, and it ships with a starter kit so you can deploy the standard in your own work the same day you finish reading.

**Three notes on how to read this.**

If you are an executive or a leader sponsoring an AI initiative, the landing page at `cameronsutcliff.com/compound-ai` is written for you. The first 90 seconds answer the question your team will eventually ask you to answer.

If you are a practitioner, this document is yours. Chapter 1 through Chapter 12 give you the diagnostic, the model, and the operating layers. Read in order, take what applies, leave what does not. The patterns are tested in production. The anti-patterns are mistakes I or someone I work with has made.

If you are an engineer, the starter kit at `compound-ai-starter-kit/` is yours. Drop it into a project. Rename the templates. Run the integrity verifier. You will be operational in under an hour. The kit is the proof, and the field guide is the explanation of why the kit looks the way it does.

**A note on the word "compound."** Berkeley AI Research[^bair-compound-ai] published "The Shift from Models to Compound AI Systems" in February 2024, establishing the term for compositional model architectures. This manual sits in dialogue with that frame. Their paper named the shift; this is the operating layer that makes the shift practical for the rest of us, the small teams, the indie operators, the analysts who have a job to do and one machine to do it on.

**A note on what this is not.** This is not advocacy. There is a chapter near the end called "When NOT to use AI." Read it. AI is a tool with specific properties, and the operators who get the most out of it are the ones who know when to put it down. Hype ages fast. Tools that work age well.

**A note on attribution.** This manual and the kit it ships with are licensed CC BY 4.0 for the writing and Apache 2.0 for the code. Take it, run it, fork it, teach it. Attribute it. Tell someone where it came from. The canonical source is on GitHub and the canonical version is on cameronsutcliff.com. Everything else is a derivative work, and that is fine, that is the point.

**Who this manual is for, briefly.** Practitioners moving from prompt-as-code to operating-standards. Indie operators and small teams running multiple agentic systems on one machine. Engineers handed a kit and asked to make it durable. Future agents inheriting work and trying to figure out which decisions are load-bearing. If you recognize yourself in those, the patterns here are battle-paid.

**Who this manual is not for.** Operators looking for the best model. Teams shopping for a vendor. Anyone wanting a list of clever prompts. The kit assumes you have a model that works and asks how to keep its work from evaporating between sessions.

Read the next page if any of this sounded right.

*Cameron Sutcliff
2026*

---

## Part I. The Frame

> **Status:** Complete. Owner: Claude. Phase E delivered.

### Chapter 1. Does it compound, or does it reset?

*Who this chapter is for: anyone who has tried to run AI work across multiple sessions and watched the cost rise without the value.*

There is exactly one diagnostic question worth asking about any AI work system. It is not "which model?" It is not "which provider?" It is not "what is the prompt?" It is this:

**Does the system compound, or does it reset?**

A resetting system shows the following symptoms. If you recognize three or more, the system is resetting.

1. Every session re-explains the project from scratch.
2. The same source files are summarized by the model on every invocation.
3. Expensive synthesis runs whether or not the inputs changed.
4. The most powerful model is used for every task, including parsing and classification.
5. Outputs are not logged, cited, validated, cached, or preserved.
6. A new operator cannot pick up the work without oral history from the prior operator.
7. Every client engagement, project, or team reinvents the same prompts and templates.

A compounding system shows a different set of traits. They are not aspirational; they are operational.

1. Memory lives in files, logs, indexes, caches, and source-of-truth data stores. The session is stateless; the filesystem is durable.
2. Context loads in tiers. The session fetches the minimum viable bundle for the task.
3. AI work is routed by cognitive load. Parsing goes to a small model; synthesis goes to a strong one; architecture decisions go to the strongest available and pass through a human gate.
4. Repeated synthesis evolves from prior state. The model edits the last good output rather than rebuilding from zero.
5. Every expensive operation has an invalidation rule. The cache knows when its answer is stale.
6. Outputs have quality gates, lineage, and rollback paths. A bad output cannot quietly overwrite a good one.
7. Engagement patterns are reusable assets. A pattern that emerges in one project is promoted to a shared layer and applies to the next one.

The distinction matters because the cost of running AI work is not the cost per call. The cost is the cost per call, multiplied by the number of times the system fails to reuse a result it already produced. A resetting system pays the full cost every time. A compounding system pays once, and the work accumulates.

This manual is the operating standard for the second kind of system. The chapters that follow give you the diagnostic in finer detail, the maturity model that lets you place where you are today, and the architectural patterns that move you from resetting to compounding. The starter kit ships the deployable artifacts.

The first move is the diagnostic. Read the seven-and-seven lists above and tag the ones that apply. Where the count is heavier on the resetting side, that is where the value comes back fastest.

---

### Chapter 2. The AI Tool Evaluation Framework

*Who this chapter is for: anyone choosing between AI tools, services, or platforms, and looking for criteria that age longer than a model release cycle.*

The standard way to evaluate an AI tool is to compare model benchmarks. That comparison ages in a quarter. Models improve; rankings shuffle; the choice you made on March benchmarks is wrong by July. The criteria that hold up across release cycles are not about the model. They are about the operating layer the tool builds, or fails to build, around the model.

Four questions. Apply them to any AI tool, framework, or platform.

**1. Does it compound, or does it reset?**

This is the question from Chapter 1, applied as a procurement criterion. Does the tool retain structured memory across sessions? Does it write state to files the operator owns, or to a vendor's database the operator does not control? Does the work the tool produces become an asset for the next session, or does it evaporate when the chat window closes?

A tool that resets is a tool you rent. A tool that compounds is a tool you own. Both are valid, but they are not the same purchase.

**2. Does it orchestrate, or does it execute?**

Some tools are orchestrators. They route work, coordinate between agents, manage state, schedule tasks, and call other tools. Some tools are executors. They do one thing, do it well, and return.

The most expensive procurement mistake is buying an executor and expecting orchestration. The opposite mistake (buying an orchestrator and using it as an executor) is wasteful but recoverable. Match the tool to the layer of work you actually need it to do.

**3. Does it encode expertise, or does it require expertise?**

Some tools let an expert capture their standards, heuristics, and methods into a form the tool can apply automatically. A reusable skill, a configurable workflow, a prompt template that survives the operator's departure. These tools encode expertise.

Other tools require the user to bring expertise to every interaction. The tool is a force multiplier for someone who already knows what they are doing, but it is useless to anyone else.

Both have a place. A team scaling AI work needs tools that encode expertise, because that is how knowledge survives the team's growth. An individual operator iterating on a hard problem needs tools that require expertise, because they are the expert and they want the leverage. Know which one you are buying.

**4. Does it produce final-mile output, or intermediate material?**

A tool that produces final-mile output gives you something a downstream consumer can use directly. A finished report, a publishable artifact, a deployable scaffold.

A tool that produces intermediate material gives you something that still needs another pass before it is usable. A draft, a code sketch, a research brief.

Intermediate material is not a failure mode; it is often what you actually want. But intermediate material that is marketed as final-mile is a procurement trap. The cost of the second pass eats the savings of the first one. Verify which output stage the tool actually completes.

These four questions let you compare Claude, Codex, Cursor, Copilot, ChatGPT, Gemini, local model runtimes, RAG systems, agentic IDEs, and tools that have not been released yet, without writing a vendor ranking that ages in a quarter. The model layer churns. The operating layer is what compounds.

---

### Chapter 3. The Three-Era Maturity Model

*Who this chapter is for: anyone trying to figure out where their AI work sits and what it needs next.*

Before you can apply the standards in this manual, you need to know where you are. Most AI systems fail to graduate from one era to the next because the work is judged by the standards of the era it has not reached yet.

| Era | Question it answers | Signals you are in it |
|---|---|---|
| **01, Demo** | Can this work? | Built fast, end-to-end. No one else consumes the output. Silent failures equal empty tables. Observability is print statements. |
| **02, Ramp-up** | Can this run unattended? | Scheduled jobs produce artifacts. Someone downstream depends on them. Drift is noticed in the weekly review, not in the moment. |
| **03, Durable** | Can others rely on it? | Schema validation at every LLM boundary. Lineage on every synthesized artifact. Observability in the morning brief. Token efficiency measured, not assumed. |

**Most projects declare victory at Era 02.** The output exists. The schedule runs. A downstream consumer is reading it. The system feels finished. The patterns in this manual are what takes a system from Era 02 to Era 03.

**The era-mismatch failure mode.** Two failure modes show up at era boundaries.

The first is **arrested development**: an Era 01 system in production. The demo worked, someone started depending on it, and the operator never went back to add the durable patterns. The system runs until the first silent failure, then breaks in a way no one can diagnose because nothing is logged.

The second is **premature polish**: Era 03 obsession applied to an Era 01 system. The operator builds schemas, lineage, observability, and quality gates before the system has proven the underlying idea works. The output is well-validated and well-traced, but it is also wrong, because the work happened before the question of "does this approach work at all" was answered.

The right move is to know your era and apply the standards of that era. Era 01 needs end-to-end execution. Era 02 needs scheduled reliability and basic observability. Era 03 needs the full discipline.

**The era checklist.** Part VI Chapter 28 of this manual ships the applied checklists for moving between eras. The Era 01 to Era 02 checklist covers what to add when a system starts running unattended. The Era 02 to Era 03 checklist covers what to add when a system starts being depended on.

If you remember nothing else from this chapter: the standards in this manual are Era 03 standards. They are not the work you do before the system has proven it works. They are the work you do to make a working system survive being depended on.

---

### Chapter 4. The Two-Tier Output Model

*Who this chapter is for: anyone whose AI system produces insights, recommendations, or synthesized outputs that humans will act on.*

Not all AI-generated insights are worth the same. The ones that matter most look the same as the ones that matter least, until you classify them.

**Tier 1: Observable.** "Nobody is doing X yet." Worth surfacing. Any reasonably attentive analyst could spot this. The AI's contribution is speed and coverage, not insight. These are observations a human could also produce, given time.

**Tier 2: Synthetic.** "Given A and B and C, the logical next move is X, and nobody has made it yet." Requires cross-domain synthesis to formulate. Invisible without the multi-domain view. The AI's contribution is the synthesis itself, not the speed.

Prioritize Tier 2. The value of an AI system that can only surface Tier 1 insights is limited. Those observations are visible to anyone paying attention; the AI is just paying attention faster. The value of a system that surfaces Tier 2 insights is compounding. Those observations require synthesis that humans cannot do at scale, and the synthesis itself is the asset.

**The classification discipline.** Every AI-produced insight should carry a tier tag. The tag is not for the user; it is for the system. Tier 1 outputs are logged but not surfaced unless the volume is anomalous. Tier 2 outputs are surfaced and tracked.

**The tier-inflation trap.** The temptation is to mark every output Tier 2 because Tier 2 sounds more impressive. Resist. Tier 2 is a property of the synthesis, not the framing. An output is Tier 2 if and only if at least two source domains contributed to it and the resulting claim could not have been formulated from any one of them alone.

A pipeline whose outputs are 90% Tier 1 is doing acceptable work but is not justifying the cost of the synthesis layer. A pipeline whose outputs are 30% Tier 2 is producing real value. The ratio is the diagnostic, not the volume.

---

### Chapter 5. The X+Y=Do Z Formula

*Who this chapter is for: anyone whose AI system makes recommendations, including recommendations to themselves.*

The most actionable output from any intelligence or synthesis system follows this structure:

> **[Asset or capability the actor already has] + [Market gap or unmet need] = [Specific action they should take]**

This is not a template. It is a test. If you cannot fill in all three slots with specifics, the output is not ready.

**The contrast that makes the formula useful.**

Generic recommendation: "Invest in AI infrastructure."

Specific recommendation, using the formula: "Your existing fiber network (X) plus the AI inference latency problem for enterprise customers (Y) equals announce edge inference hosting at your Q3 earnings call before your competitor does (Z)."

The specific version is actionable. The generic version is noise. The difference is not the writing quality; it is the discipline of filling all three slots with concrete content.

**Why this matters for AI systems.** AI-produced recommendations have a structural tendency to drift toward Tier 1 platitudes. The output reads like a recommendation, scores well on grammar checks, and lands in the brief, but it does not actually tell anyone to do anything specific.

The X plus Y formula is the corrective. Every recommendation an AI system produces should be testable against it. If X is missing, the recommendation is generic advice. If Y is missing, the recommendation is wishful thinking. If Z is missing, the recommendation is analysis without a call to action.

**Apply the formula at the prompt boundary.** The cheapest place to enforce this is in the prompt that produces the recommendation. The output schema for any recommendation should explicitly require three fields: `existing_asset`, `unmet_need`, and `specific_action`. Validate that each field is non-empty and concrete before the recommendation ships.

This eliminates an entire class of AI output failure: the recommendation that sounds like advice but is not.

---

### Chapter 6. The Promise Map

*Who this chapter is for: anyone who has read the foreword and wants to know which chapters fulfill which promise.*

The foreword made three promises. Here is where each one is fulfilled.

**Promise 1: Your sessions will stop reloading the same context.**

Fulfilled in Part II, Context and Memory.

- Chapter 7 (The Operating Contract) is the file that ends re-explanation.
- Chapter 8 (Tiered Context Loading) is the discipline that stops bulk-loading.
- Chapter 9 (File-Based Session Handoffs) is the protocol that makes the session-to-session handoff cheap.
- Chapter 10 (The Greater Vault Pattern) is how to reference what is too large to load.
- Chapter 11 (The Skills-Routing Pattern) is the architectural difference that makes the kit not-just-another-instruction-file.

**Promise 2: Your models will stop spending expensive reasoning on cheap tasks.**

Fulfilled in Part III, Token and Cost Optimization, and Part IV, Execution and Orchestration.

- Chapter 12 (LLM Response Caching) is the basic cache.
- Chapter 13 (Cache Attribution) is how to know the cache is working.
- Chapter 14 (Prompt Discipline) is the input-side cost discipline.
- Chapter 15 (Event-Driven Dispatch) eliminates bulk re-sweeps.
- Chapter 16 (Decision Trees) is the routing logic for context, model, and cache.
- Chapter 17 (Model Routing) is the table that puts the right model on the right task.
- Chapters 18 to 20 are the orchestration patterns that make routing reliable across multiple agents.

**Promise 3: Your outputs will become repeatable, auditable, and safer to reuse.**

Fulfilled in Part V, Quality, Lineage, and Reliability.

- Chapter 21 (Schema Validation at LLM Boundaries) is the defense at the input boundary.
- Chapter 22 (Intelligence Lineage) is the audit trail.
- Chapter 23 (Observability-First Scheduled Jobs) is the visibility layer.
- Chapter 24 (The Quality Immune System) is the defense against silent degradation.
- Chapter 25 (The So What Test) is the final quality gate before an output ships.

**Beyond the three promises.** Part VI covers the operational discipline that makes the standards repeatable across projects and platforms: the promotion rule, governance, the new-project checklist, cross-platform translation, and a chapter on when AI is the wrong tool. Part VII shows one worked example, before and after, with real numbers from a real production system. The appendices ship the substitution table, the anti-pattern catalog, the glossary, and the further reading.

Read the parts that match the promise you are most ready to act on. The patterns compose. None of them depends on the others to deliver value; all of them compound when stacked.

---

## Part II. Context and Memory

> **Status:** Complete. Owner: Kiro. Phase C delivered.

### Chapter 7. The Operating Contract

*Who this chapter is for: anyone starting a new project with an AI assistant.*

Every AI session starts with zero context. The operating contract is the file that fixes that. It is a short, machine-readable document that tells the AI what the project is, what it must never do, where the authoritative files live, and what conventions apply. It loads at the start of every session. It replaces the re-explanation that otherwise burns the first 2,000 tokens of every conversation.

The operating contract lives in a file called `AGENT.md` at the project root. The starter kit ships an annotated version (`AGENT.annotated.md`) and a clean deployment version (`AGENT.md`). The annotated version explains every section; the clean version is what you actually use.

**What goes in the operating contract:**

- What this project is (two sentences, not a full spec)
- What this project is NOT (the three most common wrong assumptions)
- Hard constraints (what the AI must never do: never use pip, never touch the production database, never commit secrets)
- Tech stack (language, package manager, database, test runner, scheduler, AI runtimes)
- Context map (where to find current state, recent changes, open items, the file map, the skill registry)
- Context tiers (what to load for each session type)
- Model routing (which task type goes to which model tier)
- Session lifecycle (start protocol, end protocol)
- Governance (what requires a human gate before acting)

**What does NOT go in the operating contract:**

- Full spec documents (link to them, do not inline them)
- Historical session logs (that is `session-log.md`)
- Anything that changes more than once a week (put it in `STATE.md`)
- Detailed design decisions (put them in `_knowledge/decision-log.md`)

The operating contract is stable. It changes when the architecture changes, not when the work changes. If you find yourself editing it every session, you have put the wrong things in it.

**The explicit-path rule.** Every reference in the operating contract uses an explicit relative path, not a vague pointer. "See the design docs" is not a path. `docs/architecture/pipeline-design.md` is a path. Vague pointers cost tokens because the AI has to search. Explicit paths cost nothing.

**The constraint-first discipline.** The most valuable lines in the operating contract are the constraints. "Never use pip" saves more tokens than any amount of positive instruction, because it prevents the AI from going down a path that will require correction. Write the constraints before you write anything else.

The starter kit's `AGENT.md` is a ready-to-fill template. The `AGENT.annotated.md` explains every section with margin notes. Read the annotated version once; deploy the clean version.

---

### Chapter 8. Tiered Context Loading

*Who this chapter is for: anyone who has watched an AI session reload the same spec for the third time.*

The naive approach to context is to paste everything into the prompt. This is the most expensive approach and the least reliable. Most sessions touch one subsystem. Loading the full spec for a session that is only fixing one validator script wastes 3,000 to 8,000 tokens before any work begins.

The right approach is tiered context loading: structure context into four tiers and load only what the session needs.

| Tier | Size | Contents | When to load |
|---|---|---|---|
| Tier 0 | Under 500 tokens | Project name, phase, top three constraints, pointer to deeper context | Always |
| Tier 1 | 500 to 2,000 tokens | Current state, relevant subsystem context | Most sessions |
| Tier 2 | 2,000 to 10,000 tokens | Full spec, full design doc, full session log | Deep work sessions |
| Tier 3 | Never load directly | Full codebase, historical archives, large reference docs | Use search instead |

**Implementation.** Create a `context/` directory in every project:

```
context/
  tier0.md              5-bullet operating contract, under 500 tokens
  tier1-current.md      Current state, auto-updated by sessions
  tier1-subsystem/      Per-subsystem context slices
    agents.md
    pipelines.md
    api.md
```

**Session invocation patterns:**

```bash
# Focused task, under 2 hours, roughly 800 tokens total
ai-cli -p "$(cat context/tier0.md) $(cat context/tier1-current.md) Task: [task]"

# Deep work, 2 to 8 hours, roughly 3,000 to 5,000 tokens total
ai-cli -p "$(cat context/tier0.md) $(cat context/tier1-subsystem/relevant.md) Task: [task]"

# New project bootstrap, one-time full load
ai-cli -p "$(cat requirements.md) $(cat design.md) Task: Bootstrap context/tier0.md and context/tier1-current.md"
```

After bootstrap, all subsequent sessions use the tiered approach. The bootstrap is the one time you load everything.

**Token savings.** A well-maintained tier0 plus tier1 pair replaces 2,000 to 5,000 tokens of re-explanation at session start. Over 50 sessions, that is 100,000 to 250,000 tokens saved before any other optimization.

**The tier1-current discipline.** `tier1-current.md` is the live state file for the context system. Every session that changes something updates it before exiting. A session that does not update `tier1-current.md` is a session that burned tokens without leaving a trace for the next session.

---

### Chapter 9. File-Based Session Handoffs

*Who this chapter is for: anyone running AI sessions that need to resume where they left off.*

Every AI session is stateless. The session exits and everything it knew is gone. The fix is not to keep the session alive; it is to write the state to files before the session exits, so the next session can read it.

The handoff file set:

| File | Purpose | Update frequency |
|---|---|---|
| `AGENT.md` | Project operating contract, constraints, conventions | Per architectural decision |
| `STATE.md` | Live dashboard: what is running, what is blocked, what is next | Per session |
| `session-log.md` | Running log: what changed, what was learned | Per session, prepend newest |
| `BACKLOG.md` | Open items, deferred decisions, known debt | Per session |

**The session end protocol.** Before exiting, every session that changes something must:

1. Update `STATE.md`: what changed, what is blocked, what is next
2. Append to `session-log.md`: what was done, what was learned
3. Update `BACKLOG.md`: close completed items, add newly discovered ones
4. Promote patterns: if a reusable technique emerged, add it to the project knowledge layer
5. Update `context/tier1-current.md`: so the next session starts with accurate state

This takes five to ten minutes and saves thirty to sixty minutes of re-orientation in the next session.

**The session start protocol.** At the start of every non-trivial session:

1. Read `AGENT.md` (the operating contract)
2. Read `STATE.md` (current state)
3. Load the relevant tier1 context slice if the task is subsystem-specific
4. Query the knowledge index if the task is ambiguous or cross-cutting
5. State the task explicitly with the expected output format

**The discipline.** A session that does not follow the end protocol is a session that burned tokens without leaving a trace. The next session will re-derive what this session already knew. That is the reset problem in its most concrete form.

---

### Chapter 10. The Greater Vault Pattern

*Who this chapter is for: anyone working with large reference documents that are too big to load but too important to ignore.*

Some reference material is too large to load directly but too important to leave out. A full taxonomy, a complete entity registry, a long specification document, a historical session archive. Loading any of these in full costs thousands of tokens. Leaving them out means the session has to re-derive what they contain.

The solution is a two-level reference architecture.

**Level 1: Summary file** (loaded in session, roughly 50 tokens):

```markdown
## [Reference Name]
Full reference at: [explicit path]
Key facts: [3 to 5 bullet summary]
For [specific query type]: [query method: DB, file, API]
```

**Level 2: Full reference** (loaded on demand or via search):
The actual full document, database, or data structure.

The session loads Level 1. If it needs the full reference, it loads Level 2 explicitly. Most sessions never need Level 2.

**Apply this pattern to:**

| Large reference | Level 1 summary | Level 2 full |
|---|---|---|
| Large taxonomy or classification system | 3-line summary plus path | Full taxonomy file |
| Full entity registry | "N entities, query by [key] via [method]" | Full registry file |
| Complete specification | "See section X for Y, section Z for W" plus path | Full spec file |
| Historical session archive | "Last session: [one-line summary]. Full log: session-log.md" | Full log file |
| Large reference document | Key facts plus path | Full document |

**The explicit-path rule applies here too.** The Level 1 summary must include the exact path to the Level 2 full reference. "See the docs folder" is not a path. `docs/architecture/pipeline-design.md` is a path.

**Structured data is not the vault.** The vault pattern is for unstructured knowledge. Structured data (databases, JSON registries, taxonomies with query interfaces) should be queried directly, not loaded as files. The vault is for things you read; the database is for things you query.

---

### Chapter 11. The Skills-Routing Pattern

*Who this chapter is for: anyone who wants their AI kit to feel like a product, not a folder of templates.*

The skills-routing pattern is the architectural differentiator that separates a deployable kit from a collection of markdown files. It is the pattern that makes the Compound AI Starter Kit not-just-another-CLAUDE.md.

**The core idea.** Instead of loading a large instruction file at session start, the session loads a small index. The index maps trigger phrases to skill pointers. Each skill pointer is a short file (under 100 lines, target 80) that describes what the skill does and where the real implementation lives. The session loads the index cheaply, invokes the skill cheaply, and only then pays the cost of loading the implementation.

**The three-file pattern:**

```
AGENT.md                    The operating contract (under 200 effective lines)
_skills-index.md            The skill router (a short table of triggers and pointers)
skills/[skill-name]/SKILL.md  The skill pointer (under 100 lines, target 80, routes to source)
```

**The skills index** is a single table:

```markdown
| Skill | Trigger | Pointer | Status |
|---|---|---|---|
| context-loader | "load context", "start session" | skills/context-loader/SKILL.md | active |
| token-economist | "token audit", "optimize context" | skills/token-economist/SKILL.md | active |
| quality-gate | "quality check", "validate output" | skills/quality-gate/SKILL.md | active |
```

The session loads this table (cheap). When a trigger phrase fires, it loads the corresponding SKILL.md (cheap). The SKILL.md points to the actual implementation files (loaded only when needed).

**The pointer discipline.** Each SKILL.md stays under 100 lines, target 80. It contains:
- What this skill does (one sentence)
- When to invoke it (trigger conditions)
- What it produces (output description)
- Where the implementation lives (explicit paths to source files)

It does not contain the implementation itself. The implementation lives in the source files. The pointer is the dispatch mechanism.

**Why this matters for token efficiency.** A session that loads a 2,000-line instruction file at start pays 2,000 tokens before any work begins. A session that loads a 20-line skills index pays 20 tokens. The skill is invoked only when needed. The implementation is loaded only when invoked. The total context cost for a session that never needs a particular skill is zero for that skill.

**The `_map.md` companion.** The skills index handles capability routing. The `_map.md` handles navigation. It is a short file that tells the session where things live in the project: upstream pointers, downstream pointers, child directories, and the files that matter most. Together, `AGENT.md` plus `_skills-index.md` plus `_map.md` give the session everything it needs to orient without loading anything it does not need.

**Universal skill routing for multi-agent machines.** When more than one
agent runtime is active on the same machine, the skills-routing pattern needs
one more layer. Each agent should keep the native skill directory its runtime
expects, but shared skills should route to one canonical master directory.
Claude can keep reading `~/.claude/skills`, Codex or OpenSpace can keep reading
`~/.agents/skills`, and Codex-specific skills can remain in `~/.codex/skills`.
The shared skill itself lives once, for example:

```text
~/.compound-ai/skills/spotlight
```

The runtime roots point to it:

```text
~/.claude/skills/spotlight -> ~/.compound-ai/skills/spotlight
~/.agents/skills/spotlight -> ~/.compound-ai/skills/spotlight
```

This is the difference between two agents having similarly named local skills
and two agents actually sharing one capability. It prevents drift, makes
improvements propagate immediately, and keeps token economics intact because
the agent still loads only the pointer skill it needs. The rule is simple:
edit the canonical skill first, then verify no runtime root has drifted. The
starter kit convention lives at
`doctrine/conventions/universal-skill-routing.md`.

The starter kit ships all three. The annotated versions explain every section. The clean versions are ready to deploy.

---

## Part III. Token and Cost Optimization

> **Status:** Complete. Owner: Kiro. Phase C delivered.

### Chapter 12. LLM Response Caching

*Who this chapter is for: anyone running scheduled AI pipelines or repeated synthesis tasks.*

The most expensive token waste is re-running a synthesis call whose inputs have not changed. The fix is a cache: store every LLM response keyed on a hash of the inputs, check the cache before every call, return the cached response if it exists and has not expired.

**Cache key construction:**

```python
import hashlib

def make_cache_key(model: str, effort: str, prompt: str) -> str:
    normalized = normalize_prompt(prompt)
    raw = f"{model}:{effort}:{normalized}"
    return hashlib.sha256(raw.encode()).hexdigest()
```

**Prompt normalization before hashing** lifts cache hit rates significantly. Strip non-semantic tokens before hashing:
- Dates and timestamps that are incidental to the question
- Whitespace normalization
- Session-specific metadata that does not affect the answer

Two prompts that differ only in "Today is 2026-05-01" vs "Today is 2026-05-02" should produce the same cache key if the date is not semantically relevant to the answer.

**Cache invalidation rules by content type:**

| Content type | TTL | Invalidation trigger |
|---|---|---|
| Parsing and classification results | 24 hours | New source data |
| Synthesis outputs (reports, summaries) | 7 days | New source evidence |
| Daily briefs and digests | 12 hours | New material event, next scheduled run |
| Static reference synthesis | 30 days | Explicit regeneration |
| Taxonomy and classification data | Never (static) | Annual revision |

**The input-fingerprint cache** is the highest-ROI pattern for scheduled pipelines. Before re-running an expensive synthesis call, hash the actual upstream inputs (summaries plus context plus prior state). If the fingerprint matches a recent run, skip the LLM call entirely and reuse the cached output. This is distinct from the response cache: the response cache keys on the prompt; the input-fingerprint cache keys on the source data that produced the prompt.

```python
import hashlib, json

def make_input_fingerprint(summaries: list, context: str, prior_state: str) -> str:
    payload = json.dumps({"summaries": summaries, "context": context, "prior": prior_state},
                         sort_keys=True)
    return hashlib.sha256(payload.encode()).hexdigest()
```

If the fingerprint matches a cached output and the TTL has not expired, skip the synthesis call. The savings on a pipeline that runs nightly with stable inputs are substantial.

---

### Chapter 13. Cache Attribution

*Who this chapter is for: anyone who wants to know whether their cache is actually saving money.*

A cache whose hit rate you do not measure is a cache you cannot improve. Log every hit and miss with enough metadata to answer: which pipeline is saving the most? Which role is missing the most? Where is the normalization failing?

**Minimum viable attribution log:**

```sql
CREATE TABLE llm_cache_attribution (
    id          INTEGER PRIMARY KEY,
    cache_key   TEXT NOT NULL,
    hit         INTEGER NOT NULL,  -- 1 = hit, 0 = miss
    role        TEXT,              -- which pipeline or agent
    pipeline    TEXT,
    prompt_bytes INTEGER,
    recorded_at TEXT NOT NULL
);
```

**The savings query:**

```sql
SELECT role,
       SUM(hit) AS hits,
       COUNT(*) - SUM(hit) AS misses,
       ROUND(100.0 * SUM(hit) / COUNT(*), 1) AS hit_rate_pct,
       SUM(CASE WHEN hit = 0 THEN prompt_bytes ELSE 0 END) AS tokens_spent
FROM llm_cache_attribution
WHERE recorded_at > datetime('now', '-7 days')
GROUP BY role
ORDER BY tokens_spent DESC;
```

Run this weekly. A role with a hit rate below 40% is either using prompts that change too frequently to cache, or the normalization is not stripping enough non-semantic tokens. Both are fixable.

**The duplicate-key-miss detector** finds cases where the same canonical prompt missed twice, which indicates either a TTL problem or a write failure:

```sql
SELECT cache_key, COUNT(*) AS miss_count
FROM llm_cache_attribution
WHERE hit = 0
  AND recorded_at > datetime('now', '-24 hours')
GROUP BY cache_key
HAVING COUNT(*) > 1
ORDER BY miss_count DESC;
```

---

### Chapter 14. Prompt Discipline

*Who this chapter is for: anyone writing prompts for both parsing tasks and synthesis tasks.*

The right prompt for a parsing task and the right prompt for a synthesis task are completely different. Using the wrong shape for either wastes tokens and degrades quality.

**Slim prompts for parsing tasks.** No preamble. No system history. No context about the broader project. The model does not need it for a classification task.

```
Task: Classify the following text as [category A] or [category B].
Text: [INPUT]
Output: {"category": "A" or "B", "confidence": 0.0-1.0, "reason": "one sentence"}
```

**Rich prompts for synthesis tasks.** Structured context, not a wall of text. The prior state is the key efficiency lever: a synthesis that evolves from a prior output uses far fewer tokens than one that rebuilds from scratch, and produces better output because it preserves accumulated context.

```
## Context
[Domain, relevant entities, recent events -- structured, not prose]

## Prior State
[Last synthesis output -- so the model evolves it, not rebuilds it]

## Task
[Specific synthesis task with output schema]

## Constraints
[Quality bar, tone, scope limits]
```

**Schema-first output.** Always specify the output schema in the prompt. This eliminates the retry loop for malformed responses and makes the response more compact because the model is not padding with prose where JSON is expected.

**The "you are a world-class expert" anti-pattern.** Preambles like "You are a world-class expert in X" are a tax, not a lever. They add tokens without improving output quality on well-specified tasks. Skip them for parsing tasks entirely. For synthesis tasks, the context and prior state do more work than any persona declaration.

---

### Chapter 15. Event-Driven Dispatch and Activity Gating

*Who this chapter is for: anyone running scheduled AI pipelines that process data.*

The most expensive scheduled pipeline is one that re-processes everything every run. A nightly classifier that re-processes a 7-day window re-touches thousands of already-processed items. Per-event dispatch processes each item exactly once, the moment it arrives, using the cheapest appropriate model.

**The event-driven pattern.** When new data arrives, a producer enqueues an event. A worker claims and processes it immediately. The event is processed once and marked done. The next run does not re-process it.

```python
# Producer: called when new data arrives
def on_new_article(article_id: int):
    db.execute(
        "INSERT INTO event_queue (event_type, entity_id, queued_at) VALUES (?, ?, ?)",
        ("article_classify", article_id, datetime.utcnow().isoformat())
    )

# Worker: drains the queue
def drain_queue():
    rows = db.execute(
        "SELECT queue_id, event_type, entity_id FROM event_queue "
        "WHERE processed_at IS NULL ORDER BY queued_at LIMIT 50"
    ).fetchall()
    for row in rows:
        process_event(row)
        db.execute(
            "UPDATE event_queue SET processed_at = ? WHERE queue_id = ?",
            (datetime.utcnow().isoformat(), row["queue_id"])
        )
```

**Activity-gated batch work.** Before running an expensive scheduled job for a partition (a sector, a company, a document), check for evidence of change in a short window (24 hours). Skip if none. Force-refresh after N days so genuinely quiet partitions still get periodic updates.

```python
def has_recent_activity(entity_id: str, window_hours: int = 24) -> bool:
    cutoff = (datetime.utcnow() - timedelta(hours=window_hours)).isoformat()
    count = db.execute(
        "SELECT COUNT(*) FROM events WHERE entity_id = ? AND created_at > ?",
        (entity_id, cutoff)
    ).fetchone()[0]
    return count > 0

def should_synthesize(entity_id: str, max_stale_days: int = 3) -> bool:
    if has_recent_activity(entity_id):
        return True
    last_run = get_last_synthesis_time(entity_id)
    if last_run is None:
        return True
    days_since = (datetime.utcnow() - last_run).days
    return days_since >= max_stale_days
```

**Event urgency tiers.** Not all events are equal. Route by impact:

| Tier | Signal | Action | Latency |
|---|---|---|---|
| Routine | Low-impact update | Process on next scheduled cycle | Hours |
| Elevated | Significant change | Invalidate relevant synthesis immediately | Minutes to hours |
| Breaking | High-impact event | Immediate cross-domain synthesis | Seconds to minutes |

The impact scorer runs on the cheapest available model. It is a classification task, not a synthesis task. The output is a score plus a list of affected entities. The routing decision is made by the score, not by the model that produced it.

### Chapter 16. Decision Trees

*Who this chapter is for: anyone trying to make the right choice without re-reading the whole manual.*

Standards become useful when they collapse into choices. The three most common choices in AI operating work are context loading, model routing, and cache invalidation. If those three choices are made well, most of the waste disappears before it starts.

Use these decision trees as the operating default. Override them only when the task has a specific reason to do so.

**Decision Tree 1: Load, query, or ignore?**

Start with the question the session needs answered.

```text
Do you need current project state?
  Yes -> Direct load STATE.md or tier1-current.md.
  No  -> Continue.

Do you need a specific spec, decision, or source file?
  Yes -> Direct load the exact file or section.
  No  -> Continue.

Do you need prior discussion, lessons, or patterns?
  Yes -> Query the knowledge index, then load exact cited files.
  No  -> Continue.

Is the data structured?
  Yes -> Query the database, JSON, CSV, or API directly.
  No  -> Continue.

Is it a large static reference?
  Yes -> Load the Level 1 summary first. Load Level 2 only if needed.
  No  -> Continue.

Is the answer likely in the codebase?
  Yes -> Search exact symbols or file names first. Load exact files second.
  No  -> Do not load more context. Ask whether the missing input exists.
```

The default failure mode is over-loading. Loading context feels safe because it reduces uncertainty, but irrelevant context competes with the task. The better move is to load narrow, prove the missing context is needed, then load the next tier.

**Decision Tree 2: Which model tier should do this?**

Start with the kind of cognition the task requires.

```text
Can a file read, query, test, or deterministic script answer this?
  Yes -> Use no model.
  No  -> Continue.

Is the task classification, extraction, normalization, or formatting?
  Yes -> Use a local or cheap model with a slim schema-first prompt.
  No  -> Continue.

Is the task a mechanical edit with no design judgment?
  Yes -> Use a fast coding model.
  No  -> Continue.

Is the task multi-file implementation or integration?
  Yes -> Use a strong coding model.
  No  -> Continue.

Is the task synthesis, strategy, architecture, or consequence-bearing judgment?
  Yes -> Use a strong reasoning model.
  No  -> Continue.

Is the action irreversible or external?
  Yes -> Use AI to prepare the action, then require a human gate.
  No  -> Use the cheapest competent route and record the choice if repeated.
```

This tree has a built-in bias: no model before small model, small model before strong model, strong model only when the work produces value. The point is not to make every task cheap. The point is to stop paying premium rates for work that does not need premium reasoning.

**Decision Tree 3: Cache, preserve, or rerun?**

Start before the model call.

```text
Does a valid response cache entry exist for the normalized prompt?
  Yes -> Use it.
  No  -> Continue.

Does a valid synthesis cache entry exist for the same input fingerprint?
  Yes -> Use it.
  No  -> Continue.

Did only one component's inputs change?
  Yes -> Rerun that component only.
  No  -> Continue.

Did the prior output pass quality gates and the new output fails them?
  Yes -> Preserve the prior output, record the failure, and flag review.
  No  -> Continue.

Has the user explicitly requested regeneration?
  Yes -> Rerun and record "explicit regeneration" as the invalidation reason.
  No  -> Continue.

Are the inputs missing, stale, or untrusted?
  Yes -> Do not synthesize. Fix the inputs.
  No  -> Rerun, cache the result, and write attribution.
```

This tree prevents the most expensive kind of waste: rerunning synthesis because it is easier than proving whether synthesis is needed. If the input did not change, the output should not pretend it is new.

---

## Part IV. Execution and Orchestration

> **Status:** Complete. Owner: Kiro. Phase C delivered.

### Chapter 17. Model Routing by Cognitive Load

*Who this chapter is for: anyone paying for a frontier model to do work a local model could handle.*

The most expensive token waste is using a synthesis-tier model for a parsing-tier task. A frontier model costs 5 to 10 times more than a fast model for the same token count, and produces no better output on tasks that do not require synthesis or judgment.

Route by task type, not by convenience.

| Task type | Model tier | Rationale |
|---|---|---|
| Parsing, classification, extraction, formatting | Local or smallest available | No design judgment needed. Zero or near-zero cost. |
| Mechanical tasks (copy, rename, no logic changes) | Fast or cheap tier | No synthesis required. 60 to 80 percent savings vs. full model. |
| Multi-file implementation, producer wiring | Mid tier | Real engineering judgment required. |
| Core synthesis (the platform's primary value) | Full tier | This is the product. Do not cheap out. |
| Orchestrator on clean confirmations | Fast or cheap tier | Mechanical confirmation does not need deliberation. |
| Orchestrator on design reviews or blocker triage | Full tier | When the call has consequences. |
| Session start context loading | Not an LLM call | Do not use a model to summarize context you can read directly. |

**Define routing once.** Create a `MODEL_ASSIGNMENTS` constant or equivalent at the project level. Every pipeline reads from it. Routing decisions are not made inline.

```python
MODEL_ASSIGNMENTS = {
    "event_detection":      {"provider": "local",   "effort": "low"},
    "news_classification":  {"provider": "local",   "effort": "low"},
    "financial_extraction": {"provider": "local",   "effort": "low"},
    "executive_summary":    {"provider": "primary", "effort": "max"},
    "competitive_analysis": {"provider": "primary", "effort": "max"},
    "vacuum_detection":     {"provider": "primary", "effort": "max"},
    "mechanical_port":      {"provider": "fast",    "effort": "low"},
}
```

**The provider cascade.** When the primary provider is unavailable, fall back in order. Retry in-place with exponential backoff before cascading to the next provider. A transient 5xx should not immediately trigger a full re-run on a different provider.

```python
PROVIDER_CASCADE = ["primary", "secondary", "fallback"]
RETRY_DELAYS_SECONDS = [2, 4, 8]  # 3 retries before cascade
CIRCUIT_BREAKER_THRESHOLD = 3     # consecutive failures before cooldown
CIRCUIT_BREAKER_COOLDOWN_SECONDS = 600
```

---

### Chapter 18. The Agent Interface Contract

*Who this chapter is for: anyone building a multi-agent system or adding a new agent to an existing one.*

Every agent in a multi-agent system should implement the same three-method interface. This is not a style preference; it is the mechanism that prevents silent drift from cascading through the pipeline.

```python
class BaseAgent:
    def _build_prompt(self, context: dict) -> str:
        """Construct the prompt from structured context. No LLM calls here."""
        ...

    def _parse_response(self, raw: str) -> dict:
        """Parse and validate the raw LLM response against the output schema."""
        ...

    def _validate_output(self, output: dict) -> bool:
        """Apply domain-specific validation beyond schema conformance."""
        ...
```

**Every agent must:**
- Embed a JSON schema for its output
- Validate responses against that schema before returning
- Produce a confidence score in the range 0.0 to 1.0
- Retry once on schema validation failure before raising an error
- Use structured output generation, not raw JSON parsing

**The auto-retry pattern.** On schema validation failure, inject the schema error back into the prompt and retry once. This costs roughly 15 percent additional tokens on drift, zero on clean pass. It eliminates the manual debugging loop for transient format errors.

```python
def generate_structured(prompt: str, schema: dict, model: str) -> dict:
    raw = generate(prompt, model)
    try:
        return validate_against_schema(raw, schema)
    except SchemaValidationError as e:
        retry_prompt = (
            f"{prompt}\n\n"
            f"Previous response failed validation: {e}\n"
            f"Please fix and retry."
        )
        raw = generate(retry_prompt, model)
        return validate_against_schema(raw, schema)  # raise on second failure
```

**Why this matters.** Silent drift is the single biggest class of production bug in agent pipelines. Without schemas, a field that arrives as a list instead of a string produces a half-bogus downstream artifact. With schemas, drift dies at the boundary with a specific error instead of cascading silently through every consumer.

---

### Chapter 19. Multi-Agent Coordination

*Who this chapter is for: anyone running more than one AI agent on the same project.*

The simplest multi-agent coordination mechanism is also the most reliable: files. Agents communicate through files, not through API calls or shared memory. Every decision is a file. Every handoff is a file write followed by a file read.

**The file-based communication pattern:**

```
Agent A writes task spec to shared inbox
Agent B reads inbox, executes, writes result to output
Agent C monitors output, escalates blockers, sends alerts
```

No API calls between agents. Everything is local files, commits, and message relay. This means:
- Zero marginal cost for monitoring agents
- No rate limits on agent coordination
- Full auditability: every decision is a file

**The three-role model.** Most multi-agent systems need three roles, not more:

- **Architect**: Strategic thinking, planning, complex reasoning, architecture decisions. Uses the most capable model. Invoked on demand, not continuously.
- **Operator**: Autonomous monitoring, scheduling, coordination. Runs continuously on the cheapest available model. Escalates only when genuinely blocked.
- **Builder**: Code execution, implementation, file generation. Picks up tasks from queue, executes, commits results.

**The escalation rule.** The Operator runs autonomously and escalates to the Architect only when genuinely blocked. "Blocked" means: cannot proceed without a decision that requires judgment. It does not mean: "I completed a task and want to report it." Reporting goes to the session log. Escalation goes to the Architect.

**Worktree isolation.** When multiple agents work on the same codebase simultaneously, use git worktrees to give each agent its own working directory. This prevents file conflicts without requiring coordination overhead.

---

### Chapter 20. Semantic Search vs Direct File Load vs DB Query

*Who this chapter is for: anyone deciding how to retrieve context for an AI session.*

Three retrieval mechanisms, three different use cases. Using the wrong one wastes tokens or produces wrong answers.

| Situation | Use |
|---|---|
| "What did we decide about X?" | Semantic search over session logs and decision log |
| "What is the current state of Y?" | Direct file load (STATE.md, tier1-current.md) |
| "Find all places where Z is implemented" | Semantic search over codebase embeddings |
| "What does the spec say about W?" | Direct file load (spec section) |
| "How many entities match this filter?" | DB query, not semantic search |
| "What is the current value of field F?" | DB query or direct file read, not semantic search |

**Semantic search is for unstructured knowledge retrieval.** Structured data (databases, JSON registries, taxonomies) should be queried directly. Semantic search over structured data produces approximate answers where exact answers are available. Use the right tool.

**What to index in your knowledge index:**
- Operating contracts (AGENT.md files, all projects)
- Design docs and requirements docs
- Session logs
- Decision logs
- Patterns and playbooks

**What NOT to index:**
- Generated artifacts (briefs, reports, decks): query the database instead
- Binary files, images, compiled outputs
- Temporary files and logs

**The vault principle.** The semantic index is for knowledge about the system, not data produced by the system. If it is a fact about the world that the system ingested, it belongs in the database. If it is a decision about how the system works, it belongs in the knowledge index.

**The promotion rule.** When a pattern emerges in a session log that is reusable across projects, promote it to the shared patterns reference. A pattern that lives only in a session log is a pattern that gets re-derived in the next session. The session log is the source. The patterns reference is the destination.

---

## Part V. Quality, Lineage, and Reliability

> **Status:** Complete. Owner: Kiro. Phase C delivered. The Quality Immune System is the signature original concept from this body of work.

### Chapter 21. Schema Validation at LLM Boundaries

*Who this chapter is for: anyone who has ever had an AI pipeline produce a subtly wrong output that cascaded downstream.*

Every LLM response is an untrusted boundary. The model might return a list where a string is expected, a string where a number is expected, or a missing key where a required field was specified. Without validation, these errors cascade silently through every downstream consumer.

**The pattern.** Every LLM response is parsed via a schema validator that enforces required keys and types. On failure, route to the agent's fallback path with a specific error log line.

```python
import json
from typing import Any

def validate_against_schema(raw: str, schema: dict) -> dict:
    """Parse raw LLM response and validate against schema. Raises on failure."""
    try:
        # Extract JSON from response (handle markdown code blocks)
        text = raw.strip()
        if text.startswith("```"):
            lines = text.split("\n")
            text = "\n".join(lines[1:-1])
        data = json.loads(text)
    except json.JSONDecodeError as e:
        raise SchemaValidationError(f"JSON parse failed: {e}") from e

    errors = []
    for field, field_schema in schema.get("properties", {}).items():
        if field in schema.get("required", []) and field not in data:
            errors.append(f"Missing required field: {field}")
        elif field in data:
            expected_type = field_schema.get("type")
            if expected_type and not isinstance(data[field], _type_map[expected_type]):
                errors.append(f"Field {field}: expected {expected_type}, got {type(data[field]).__name__}")

    if errors:
        raise SchemaValidationError(f"Schema validation failed: {'; '.join(errors)}")
    return data

_type_map = {"string": str, "number": (int, float), "integer": int,
             "boolean": bool, "array": list, "object": dict}
```

**The anti-pattern.** `json.loads(response)` with no schema check. This is prayer, not engineering. The response will eventually drift, and when it does, the error will appear in a downstream consumer, not at the boundary where it originated.

**Schema constants at the module level.** Define schemas as module-level constants, not inline. This makes them reviewable, testable, and reusable.

```python
CLASSIFICATION_SCHEMA = {
    "type": "object",
    "required": ["category", "confidence", "reason"],
    "properties": {
        "category": {"type": "string"},
        "confidence": {"type": "number"},
        "reason": {"type": "string"}
    }
}
```

---

### Chapter 22. Intelligence Lineage

*Who this chapter is for: anyone whose AI system produces outputs that influence real decisions.*

Every synthesized artifact should answer: what created this, from what evidence, when, with what model, under what assumptions? Without lineage, the answer is "the AI said so," which is not an answer that survives scrutiny.

**The lineage graph.** Every synthesized artifact writes provenance edges pointing at the raw evidence that produced it.

```
synthesized_output -> derived_from -> source_evidence
synthesized_output -> confirmed_by -> corroborating_evidence
synthesized_output -> contradicted_by -> conflicting_evidence
synthesized_output -> superseded_by -> newer_output
```

**Minimum viable lineage table:**

```sql
CREATE TABLE intelligence_lineage (
    lineage_id   INTEGER PRIMARY KEY,
    subject_type TEXT NOT NULL,
    subject_id   TEXT NOT NULL,
    source_type  TEXT NOT NULL,
    source_id    TEXT NOT NULL,
    relation     TEXT NOT NULL,  -- derived_from, confirmed_by, contradicted_by, superseded_by
    created_at   TEXT NOT NULL,
    UNIQUE (subject_type, subject_id, source_type, source_id, relation)
);
```

The UNIQUE constraint enforces idempotency: inserting the same edge twice results in exactly one row. Use `INSERT OR IGNORE` to make lineage writes safe to retry.

**Lineage writes are best-effort.** A lineage write failure should log a warning and not block the main pipeline. The pipeline's job is to produce the artifact. Lineage is the audit trail. If the audit trail fails, the artifact still ships; the failure is logged and investigated separately.

**Why lineage matters.** Lineage enables:
- "Why does this say X?" (provenance audit)
- "Which outputs were affected when source Y was corrected?" (retraction propagation)
- "What evidence supports this claim?" (trust building with downstream consumers)
- "When was this last updated and from what?" (freshness tracking)

Start simple. Even crude "derived_from source" edges are worth the 20 minutes to add. The schema can evolve.

---

### Chapter 23. Observability-First Scheduled Jobs

*Who this chapter is for: anyone running scheduled AI pipelines that need to survive failures without human intervention.*

A scheduled job that fails silently is worse than a job that does not run. The failure is invisible, the downstream consumers get stale data, and the operator finds out when someone complains. The fix is observability: every scheduled phase records start, end, and status in a queryable store.

**Minimum viable observability table:**

```sql
CREATE TABLE pipeline_runs (
    run_id        INTEGER PRIMARY KEY,
    pipeline_name TEXT NOT NULL,
    phase         TEXT,
    status        TEXT NOT NULL,  -- running, success, failed
    started_at    TEXT NOT NULL,
    ended_at      TEXT,
    error_message TEXT
);
```

**The phase wrapper pattern (bash).** In shell scripts using `set -euo pipefail`, wrap phase commands so a single phase failure does not abort the entire pipeline:

```bash
run_phase() {
    local name="$1"; shift
    record_start "$name"
    if "$@"; then
        record_success "$name"
    else
        local code=$?
        record_failure "$name" "$code"
        # Do NOT exit -- let the next phase run
    fi
}

# Usage
run_phase "news-classify" python scripts/classify_news.py
run_phase "vacuum-detect" python scripts/detect_vacuums.py
run_phase "daily-brief"   python scripts/synthesize_brief.py
```

**The phase wrapper pattern (Python):**

```python
from contextlib import contextmanager
from datetime import datetime

@contextmanager
def track_phase(pipeline_name: str, phase: str):
    run_id = db.execute(
        "INSERT INTO pipeline_runs (pipeline_name, phase, status, started_at) VALUES (?, ?, 'running', ?)",
        (pipeline_name, phase, datetime.utcnow().isoformat())
    ).lastrowid
    try:
        yield
        db.execute(
            "UPDATE pipeline_runs SET status='success', ended_at=? WHERE run_id=?",
            (datetime.utcnow().isoformat(), run_id)
        )
    except Exception as e:
        db.execute(
            "UPDATE pipeline_runs SET status='failed', ended_at=?, error_message=? WHERE run_id=?",
            (datetime.utcnow().isoformat(), str(e), run_id)
        )
        raise

# Usage
with track_phase("overnight", "vacuum-detect"):
    detect_vacuums()
```

**Surface phase health in your morning brief.** If you are not looking at pipeline health every morning, you will find out about failures when a downstream consumer complains. The `pipeline_runs` table is queryable. Query it.

---

### Chapter 24. The Quality Immune System

*Who this chapter is for: anyone whose AI pipeline produces narrative content that can degrade over time.*

LLM synthesis pipelines occasionally produce degraded output: short paragraphs, missing sections, token truncation. Without protection, a thin generation silently overwrites a rich prior output. Over time the system regresses: rich to thin to thinner. You find out weeks later when someone opens a page that used to be good.

This is not a hypothetical. It is a failure mode that appears in production systems that run long enough. The fix is a four-layer immune system.

**Layer 1: Application-level merge-preserve (primary gate).**

Before writing a new synthesis output, compare it against the historical best for that section. If the new output is below a richness floor (for example, less than 50 percent of historical max length), preserve the prior version instead.

```python
def merge_preserve(
    new_content: str,
    prior_content: str,
    floor_chars: int,
    historical_max: int
) -> tuple[str, str]:
    """
    Returns (content_to_write, action).
    action is one of: 'written', 'preserved', 'aborted'
    """
    if len(new_content) >= floor_chars:
        richness_ratio = len(new_content) / max(historical_max, 1)
        if richness_ratio >= 0.5:
            return new_content, "written"
    if prior_content:
        return prior_content, "preserved"
    return new_content, "aborted"
```

**Layer 2: Database-level trigger (defense-in-depth).**

A database trigger refuses any UPDATE that drops the primary narrative column below 50 percent of historical max. This catches new pipelines that bypass the application layer.

```sql
CREATE TRIGGER enforce_no_thin_overwrite
BEFORE UPDATE ON reports
FOR EACH ROW
WHEN NEW.content IS NOT NULL
  AND OLD.content IS NOT NULL
  AND length(NEW.content) < 0.5 * (
      SELECT MAX(length(content)) FROM reports WHERE report_id = NEW.report_id
  )
BEGIN
    SELECT RAISE(ABORT, 'Thin overwrite rejected: new content below 50% of historical max');
END;
```

**Layer 3: Append-only quality ledger (observability).**

Every write decision appends one row: action (preserved, written, aborted), new length, prior length, floor. This gives "why did this regress?" an audit trail.

```sql
CREATE TABLE report_quality_ledger (
    ledger_id    INTEGER PRIMARY KEY,
    subject_id   TEXT NOT NULL,
    section      TEXT NOT NULL,
    action       TEXT NOT NULL,  -- written, preserved, aborted
    new_len      INTEGER,
    prior_len    INTEGER,
    floor        INTEGER,
    created_at   TEXT NOT NULL
);
```

**Layer 4: Scheduled sweep and auto-heal (safety net).**

A daily job scans for subjects whose latest output is below the richness floor, restores from history, and fires an alert if anything was healed.

```python
def quality_sweep():
    regressions = db.execute("""
        SELECT subject_id, section, length(content) as current_len,
               MAX(length(content)) OVER (PARTITION BY subject_id, section) as historical_max
        FROM report_quality_ledger
        WHERE action = 'written'
        ORDER BY created_at DESC
    """).fetchall()

    for row in regressions:
        if row["current_len"] < 0.5 * row["historical_max"]:
            restore_from_history(row["subject_id"], row["section"])
            send_alert(f"Quality regression healed: {row['subject_id']} / {row['section']}")
```

**The rule.** The quality guard ships with the pipeline, not after the first bad Monday. Every new pipeline that persists narrative content must call `merge_preserve` and declare its section floors before it ships to production.

---

### Chapter 25. The "So What" Test

*Who this chapter is for: anyone whose AI system produces outputs that a human will act on.*

Every intelligence output, recommendation, or synthesized artifact must be explainable in terms of why it matters to someone's decision, business, or career. If you cannot explain the "so what," it does not ship.

This is not a quality bar for AI systems specifically. It is a quality bar for any output that a human will act on. Apply it to reports, briefs, recommendations, alerts, and summaries.

**The test.** For any output, ask: "If a senior decision-maker read only this and nothing else this morning, would they arrive informed and able to act?" If the answer is no, the output is not ready.

**The two failure modes:**

1. **Too generic.** "AI infrastructure investment is increasing." This is true but not actionable. The "so what" is missing.
2. **Too specific without context.** "NVDA revenue grew 122% YoY." This is a fact but not an insight. The "so what" is missing.

**The passing form.** "NVDA's 122% YoY revenue growth is driven by data center AI infrastructure demand that is outpacing supply, which means the hyperscalers are capacity-constrained and will pay premium prices for the next 18 months. The strategic implication: any company in the inference stack has pricing power it has not yet exercised."

That is the "so what." It connects the fact to the implication to the action. If your synthesis pipeline cannot produce that form, the pipeline is not done.

---

## Part VI. Engagement Reuse, Governance, and Translation

> **Status:** Complete. Mixed ownership (Kiro: Ch 26, 28; Claude: Ch 27, 30; Codex: Ch 29).

### Chapter 26. The Promotion Rule

*Who this chapter is for: anyone who has solved the same problem twice in different sessions.*

When a pattern emerges in a session log that is reusable across projects, promote it to the shared patterns reference. A pattern that lives only in a session log is a pattern that gets re-derived in the next session. That re-derivation costs tokens, time, and the risk of arriving at a slightly different answer.

**The promotion checklist:**
- Does this pattern apply to more than one project?
- Would a new session benefit from knowing this before starting?
- Is there a reference implementation that can be pointed to?

If yes to all three, promote it. The session log is the source. The patterns reference is the destination.

**The promotion format:**

```markdown
## Pattern: [Name]

**Problem:** [What situation does this solve?]
**Solution:** [The pattern in one paragraph]
**Reference implementation:** [Explicit path to where this is implemented]
**When NOT to use:** [The conditions where this pattern is wrong]
**First observed:** [Session ID or date]
```

**The promotion discipline.** Promote on first reuse, not on first occurrence. A pattern that appears once might be a one-off. A pattern that appears twice is a pattern. Promote it before the third occurrence.

---

### Chapter 27. Governance and Blast Radius

*Who this chapter is for: anyone running an AI system with broad write access to files, services, or external accounts.*

The default an AI agent should operate under is the same default a senior engineer operates under: act, do not ask. The cost of asking permission for safe operations is the human's attention, and the human's attention is the most expensive resource in the system. Most operating-contract designs fail in one of two opposite directions: they over-gate, and the agent burns the human's attention on safe operations; or they under-gate, and the agent eventually does something it should not have.

The discipline that fixes both failures is **blast-radius gating**: explicit limits on what the agent does without a human gate, calibrated to the cost of getting it wrong.

**The blast-radius framework.** Every action an agent can take falls into one of three categories.

| Category | Definition | Default behavior |
|---|---|---|
| **Local and reversible** | Edits in the working directory, file creation, test runs, local commits | Act, do not ask |
| **Shared or hard-to-reverse** | Pushes, merges, deletions outside the working directory, dependency changes, schema migrations | Confirm, then act |
| **External or irreversible** | Public posts, sent emails, deployments to shared infrastructure, billing changes, secrets management | Always confirm; verify the request was actually issued |

The agent should be able to identify which category any given action falls into. The operating contract makes the categorization explicit so the agent does not have to guess.

**The red lines.** Inside every operating contract, the following are gated by default. Each line is hook-enforceable; do not rely on the model's discretion alone.

- Destructive git operations: `push --force`, `reset --hard`, `branch -D`, `clean -f`, history rewrites on shared branches.
- Anything that costs money beyond the existing subscription. Cloud spin-ups, paid API calls, billing changes.
- External publishing: social posts, emails, pull requests to public repos, messages to channels with non-team members.
- Schema changes that drop data: migrations that `DROP COLUMN` or `DROP TABLE` get human approval, no exceptions.
- Modifying authentication, permissions, or secrets in any file the harness reads (`settings.json`, `.env`, key files).
- Skipping safety checks: `--no-verify` on commits, disabling hooks, suppressing test failures.

For everything else: act, do not ask. The closing line of the governance section is the most important sentence in the entire operating contract. Without it, the agent will ask for permission on safe operations and burn the human's attention. With it, and with a tight red-lines list above, the human's attention is spent only on actual risk.

**The dual-use trap.** A tool the agent uses safely today can be repurposed to cause damage tomorrow. A CLI helper that reads files can be redirected to exfiltrate credentials. A scheduling system that posts to one channel can be redirected to post anywhere. The governance contract should not enumerate every tool; it should enumerate every *outcome class* (destructive, costly, external, sensitive) and gate on the outcome, not the tool.

**The audit trail.** Every gated action that proceeds writes an audit-trail entry. The minimum viable trail is the action, the input, the human approval (timestamp and method), and the result. Audit trails do not exist for normal users; they exist for the case where something went wrong and you need to reconstruct what the agent thought it was doing. The cost of writing them is small; the value of having them when needed is large.

**The escalation rule for autonomous systems.** Long-running autonomous agents need an escalation rule. The rule is not "escalate when uncertain"; that produces too many escalations. The rule is "escalate only when blocked by a decision that requires human judgment." Completing a task and wanting to report it is not blocked; trying to proceed and finding a red line is. Get the threshold right and the human's attention compounds with the system.

The starter kit's `AGENT.md` ships with a governance section that lists these red lines and a closing "act, do not ask" line. Customize the red lines to your project. The structure stays the same.

---

### Chapter 28. New Project Bootstrap Checklist

*Who this chapter is for: anyone starting a new project that will use AI assistance.*

Before the first AI session on a new project, complete this checklist. Each item takes minutes and saves hours.

**1. Create AGENT.md** (30 minutes, saves hours)
- Project name and one-sentence description
- The three hardest constraints (what NOT to do)
- The tech stack (language, package manager, database, test runner)
- The current phase and what "done" means
- Explicit paths to the spec, design doc, and backlog

**2. Create the context tier structure**
- `context/tier0.md`: 5-bullet operating contract, under 500 tokens
- `context/tier1-current.md`: current state (starts empty, updated by sessions)

**3. Seed the decision log**
- Record the founding architectural decisions before the first session
- "We chose X over Y because..." is worth 500 tokens now vs. 5,000 tokens of re-deliberation later

**4. Define the handoff protocol**
- Which files does each session update?
- What is the format for session log entries?
- Where does the backlog live?

**5. Define the model routing table**
- Which tasks use which model tier?
- What is the fallback chain when the primary provider is unavailable?

**6. Add schema validation before the first dependent consumer**
- Every LLM-returning function routes through a schema validator
- Schema constants are defined at the module level, not inline

**7. Add observability before the first scheduled job**
- `pipeline_runs` table or equivalent
- Phase wrapper that records start, end, and status

The starter kit's `checklists/new-project.md` is a ready-to-use version of this checklist.

### Chapter 29. Cross-Platform Translation

*Who this chapter is for: anyone who wants the architecture to outlive the current tool.*

The starter kit uses `AGENT.md` as its public operating contract because the file name is vendor-neutral. The content is what matters. Each runtime has its own native load mechanism, but the operating standard stays the same.

The translation rule is simple:

1. Keep the canonical source in `AGENT.md`.
2. Copy, symlink, or generate the platform-native file from it.
3. Keep platform-specific settings outside the operating contract.
4. Do not fork the instructions per tool unless the work genuinely differs.

| Platform | Native file | How to translate |
|---|---|---|
| Claude Code | `CLAUDE.md` | Copy or symlink `AGENT.md` to `CLAUDE.md`. Claude Code auto-loads it at repo root and can cascade nested files. |
| Codex | `AGENTS.md` | Copy or symlink `AGENT.md` to `AGENTS.md`. Keep repo-specific coding rules here and put tool configuration elsewhere. |
| Cursor | `.cursorrules` or `.cursor/rules/*.mdc` | Use `.cursorrules` for one repo-wide contract. Use `.mdc` rule files only when rules need file-glob scoping. |
| GitHub Copilot | `.github/copilot-instructions.md` | Copy the stable operating contract here. Keep CI, branch, and PR rules explicit because Copilot sees repository context. |
| Aider | `CONVENTIONS.md` plus `.aider.conf.yml` | Keep the contract in `CONVENTIONS.md` and point Aider at it through config. Do not bury the contract inside YAML. |
| Continue.dev | Referenced instruction file from config | Store the contract as Markdown and reference it from the configuration's system message or instructions field. |
| Generic AI CLI | `AGENT.md` | Load with `cat AGENT.md` or the runtime's equivalent include mechanism. |

The kit should not require a user to pick one AI vendor. It should let them preserve operating discipline while switching tools. That is the difference between a prompt file and a portable operating standard.

**Portable skill routing.** Skills translate the same way. A skill has three parts:

1. A trigger description.
2. A short operating rule.
3. A pointer to deeper source material.

Claude Code may call that a skill. Cursor may call it a rule or custom workflow. Codex may implement it as an instruction file plus a script. The label changes; the pattern does not.

**Portable hooks.** Hooks are just enforcement points. If the runtime has native hooks, use them. If it does not, use pre-commit hooks, shell wrappers, CI checks, or small scripts. A no-em-dash rule, a manifest verifier, and a session-closeout reminder do not need to care which model is in the chair.

**Portable knowledge.** A knowledge index can be Chroma, LanceDB, Postgres full-text search, a folder of Markdown files, or an enterprise search system. The operating rule is still the same: use retrieval for unstructured historical knowledge, and use direct queries for structured data.

The AI is interchangeable. The architecture is not.

### Chapter 30. When NOT to Use AI

*Who this chapter is for: anyone whose AI initiative has started to feel like a religion.*

This manual is an advocacy document for one specific thing: AI work that compounds. It is not an advocacy document for AI as the right tool for every problem. The operators who get the most out of AI are the ones who know when to put it down. This chapter is the list of conditions where AI is the wrong tool, written so an operator can spot the mismatch before paying for it.

**When the answer is in a file, do not summarize it.** If `STATE.md` says what the current state is, load `STATE.md`. Do not ask an AI to read it and tell you what it says. The cost of the summary is a model call; the cost of reading the file is zero. This is the single most common AI misapplication: using a $0.01 model call to do work a $0 file read already did.

**When the data is structured, use a query, not retrieval.** Databases, JSON registries, CSV files, and typed APIs are not RAG candidates. They are query candidates. Use SQL, use `jq`, use the language. Retrieval-augmented generation over structured data is slower, less accurate, and more expensive than the query that the structure was designed for. RAG is for unstructured knowledge; queries are for structured data.

**When the operation is exact, do not paraphrase.** Calculations, transformations, format conversions, and constraint checks should be done by code. AI is good at fuzzy work; it is not good at exact work. A model that produces JSON 95% of the time is producing broken JSON 5% of the time. The cost of writing the deterministic version is small. The cost of debugging a pipeline that fails non-deterministically is not.

**When the decision is irreversible, do not delegate it.** Production deployments, schema migrations on data with no backup, public posts, contracts. The operating-contract red lines from Chapter 27 exist because the cost of AI getting these wrong dominates the savings of having it do them at all. The right pattern is to use AI to *prepare* the action, then have a human approve it. The wrong pattern is to let the AI complete the irreversible step.

**When the cost of error exceeds the cost of work.** A draft costs nothing to throw away. A misclassified medical record, a wrongly disabled production service, a wrongly sent email to a customer, an erroneous compliance filing, all cost more to fix than the original work would have cost to do by hand. AI's productivity gain is real, but it is conditional on the error rate being affordable. When the error is not affordable, the productivity gain does not apply.

**When the requirement is provenance.** Some work needs to be defensible: legal, regulatory, scientific, journalistic. AI outputs that cannot be traced to a verifiable source do not pass the provenance bar, regardless of how correct they look. If the answer needs a citation, the AI can help find the citation but it should not be the citation. A pipeline that produces source-grounded outputs (Chapter 22, Intelligence Lineage) is the corrective. A pipeline that produces unsourced outputs and is asked to act in a provenance-required context is the wrong tool.

**When the task is the user's expertise development.** Some work is not productive; it is educational. A learner solving a problem to learn the problem, an analyst working a domain to internalize it, an engineer reading code to understand a system. The AI completion shortcuts the expertise the user was building. The right pattern is to use AI as a tutor, not a substitute; the wrong pattern is to never engage the work directly.

**When you do not have the inputs.** AI cannot synthesize signal it does not have. A recommendation pipeline that has no access to the actor's actual assets, costs, and constraints produces generic advice (the failure mode from Chapter 5's X+Y=Do Z). The fix is to add the inputs, not to ask the model harder. Without the inputs, the AI is wishful thinking with confidence intervals.

**When the team is not ready for the operating discipline.** This manual is an operating standard, not a model recommendation. A team that cannot maintain the operating discipline (the session protocols, the file-based handoffs, the schema validation, the cache attribution) will get less out of AI than a team that does not use AI at all and just has clear documentation. The discipline is the multiplier; without it, the AI is friction.

**A summary that fits on a sticky note.** Do not use AI when the answer is in a file, when the data is structured, when the operation is exact, when the decision is irreversible, when the cost of error exceeds the cost of work, when provenance is required, when expertise is the goal, when the inputs are missing, or when the team cannot maintain the discipline. Use AI when none of these apply. That is most of the time. But it is not all of the time, and the discipline of knowing the difference is what separates a compounding system from a noisy one.

Hype ages fast. Tools that work age well. A field manual that did not include this chapter would be advocacy. With it, it is engineering.

### Chapter 31. The Agent Panel Planning Pattern

*Who this chapter is for: anyone whose high-stakes deliverable does not yet have a locked plan, and who suspects their own framing has gaps.*

Most multi-agent council patterns assume the plan exists and ask agents to evaluate it. The panel pattern that produced this kit[^panel-coordination-v1] started one step earlier: the agents converged on the plan itself. Three sealed independent plans, one round of cross-feedback with element-level voting, a private revise cycle that included path-forward suggestions for the other agents, a reconvene, a vote, a ratification, and finally a strength-matched task split based on what each agent demonstrated in this round. The output was a plan that no single agent could have produced and a task split with explicit empirical justification.

The pattern is implemented as the `agent-panel-planning` skill (Tier 1). It is the upstream sibling of `agent-panel-review` (Chapter 32): planning produces what to build and who builds what; review produces "is what we built any good." Run planning when the plan itself is the question. Run review when execution drafts are landing.

#### 31.1 When to convene a planning panel

A planning panel costs more operator time than a review panel because each agent produces a complete plan, not a focused critique. The threshold should match.

Convene a planning panel when the plan itself is what needs to be right (not just execution); when multiple agents have genuinely different framings of the problem; when the work will be split across agents and the operator needs strength-matched routing; or when the operator suspects their own framing has gaps and wants independent reframings to test against.

One alternative to convening per-deliverable: the **standing panel**[^adam-federman]. Two or three agents in a permanent operating relationship, used as the default operating structure rather than convened anew each time. The standing panel trades role flexibility for accumulated context: it always knows the prior decisions, and its postures refine over time. The trade-off is steeper discipline: every non-trivial decision goes through the panel, not just high-stakes ones. For operators who can sustain that discipline, a standing panel is stronger than convening per-deliverable; for everyone else, the convened pattern in this chapter is the right default.

Do not convene a planning panel when the plan is obvious and only execution matters (go straight to `agent-panel-review` on the drafts), when one agent has already framed the problem well (use `pressure-test` or `nod-protocol` on that framing instead), when time pressure dominates accuracy, or when you already know the answer and want validation. The most common operator-humility signal that warrants planning: "I have a draft plan but I want to test it against alternatives." When the operator says or thinks this, the kit's router offers the panel.

#### 31.2 Independent plans, sealed

Stage 2 is the load-bearing move. Each agent produces a complete plan covering the same scope, with no visibility into the others. The seal preserves the independent framings that the entire pattern depends on.

What each first-pass plan must contain at minimum: the problem framed in the agent's own words, the structural spine of the proposed solution, decision points the operator should rule on, owners for each major piece (proposed, not final), dependencies and sequencing, and the open questions the agent cannot resolve alone. A panelist who produces only the spine without owners or open questions has produced a sketch, not a plan; ask for a revision before Stage 3.

Same-platform panels (three Claude sessions, three Codex sessions) work as well as cross-platform panels for most planning work. The discipline is that the sessions be genuinely separate: no shared session history, no leaky workspace context, no operator paraphrasing one plan to another agent. Verify the contexts are isolated before Stage 2.

#### 31.3 Cross-feedback with element-level voting

Stage 3 sends each panelist the other plans for structured cross-feedback. The same four-cell template that powers `agent-panel-review` applies (strongest claim, weakest claim, shared blind spot, one thing worth stealing), but planning adds a second block: element-level votes on specific decision points the operator surfaced during framing.

The reason for element-level voting rather than whole-plan voting: tribalism. Whole-plan voting asks panelists to defend their first pass against the others. Element-level voting asks them to recognize specific wins by other plans without surrendering their whole framing. A panelist may vote against their own title proposal while keeping their structural spine, or vote for another's provenance design while retaining their own license framework. The granularity is what makes the votes honest.

Operator discipline at framing: surface three to seven decision points, no more. Anything beyond seven becomes noise. Each panelist's vote requires one-line reasoning. The reasoning is the audit trail.

#### 31.4 The collaborative revise: concession, plan revision, and path-forward for others

Stage 4 is sealed again. Each panelist produces three outputs without seeing the others' revisions. The third output is the move that distinguishes this pattern from any other multi-agent council pattern the team has seen.

The three outputs:

1. **Concessions with attribution.** Each panelist names what they concede and to which other agent on what dimension. "Concede to Codex on structural spine; concede to Kiro on substance density in Part V; hold on cross-platform translation chapter because both others omit it." The attribution is the no-ego discipline made visible.

2. **Revised private plan.** The agent's own plan, revised to absorb the conceded points. Unaccepted critiques get one line of dissent each. No 500-word defenses.

3. **Path-forward suggestions for the OTHER agents.** This is the collaborative move. Each panelist, having absorbed the critique of its own plan, proposes specific adjustments for each other panelist's plan. Not "you should do what I did." Concrete and actionable suggestions for how each other agent's plan should evolve given what the cross-feedback surfaced.

Without the third output, every agent revises only its own plan and Stage 5 reconvene becomes a guessing game. With it, each agent arrives at reconvene with two sets of incoming suggestions for themselves plus the revised plans of the others. The collective shaping information is what makes convergence at Stage 5 honest rather than imposed.

#### 31.5 Reconvene and ratification

Stage 5 reconvene is the first stage with no seal. Each panelist reads the others' revised plans plus the cross-suggestions written for them, and produces a short response: which incoming suggestions are accepted, which are rejected (with one-line reasoning), and where the panelist now stands on the contested decision points from Stage 3.

The rule is no relitigation. Reconvene is for adoption and adjustment, not for re-arguing the original position. A response that re-states the first-pass position is wasted motion.

Stage 6 is the operator's job. Surface the remaining contested decision points (if any survive Stage 5), run a final vote with one-line reasoning per panelist, then ratify. The operator votes too. The panel is advisory; the operator decides. Operator override of a unanimous panel is allowed but should be rare and on the record.

Ratification produces a one-page document with locked decisions, deferred open questions, and the task assignment table.

#### 31.6 Strength-matched task assignment

The task split is empirical, not categorical. Each task goes to whoever **demonstrated dominant capability on that dimension in this round**, not to whoever has the role label.

The rule unpacks: read the Stage 3 cross-feedback's strongest-claim cells. Whichever panelist gets named most often as strongest on a dimension owns that dimension. Ties break by which panelist's plan most directly addressed the dimension; if still tied, by which agent's cross-suggestions on that dimension were most actionable; if still tied, the operator decides.

The assignment is on the record with a "why" column: structural spine to Codex because its first-pass spine had the most breadth; substance body to Kiro because its first-pass code samples were strongest; foreword and attribution to Claude because its first-pass plan included the annotated artifact concept. The same agents on a different panel for a different deliverable might end up with different roles. Strengths are demonstrated per-round, not preset.

Strength-matched assignment is the antidote to council theater. Without it, panels produce three agents who agree but no one is accountable for the work. With it, the plan ships with explicit owners whose ownership is defensible from the panel's own outputs.

#### 31.7 Execution with operator-in-the-loop escalation

The planning panel ends at Stage 6 ratification. Execution begins. The discipline that makes the plan durable through execution: when an agent hits a decision point not covered by ratification, escalate to the operator with the panel's prior context, not decide solo.

Escalation is bounded. Agents do not escalate every choice; that is helplessness. They escalate when (a) the decision is not covered by ratification, (b) it commits to one of multiple valid paths, (c) reversibility is non-trivial, and (d) it affects work assigned to other panelists. The fourth condition is the key: if a decision only affects the deciding agent's own work, the agent decides and notes it. If it affects the others' work, escalate.

The operator's exits on escalation: decide and respond, run a fast mini-panel on the contested decision, or punt to a later checkpoint. The wrong move is silence, which agents read as "proceed at your discretion" and which produces drift the panel did not see.

The pattern is implemented across `agent-panel-planning/SKILL.md` and its reference files: `protocol.md` covers the six stages, `cross-feedback-template.md` defines the Stage 3 format with element-level voting, `concession-discipline.md` covers the Stage 4 three-output structure including path-forward-for-others, `voting-format.md` covers Stage 3 and Stage 6 voting, `task-assignment.md` covers the strength-matched split, `escalation-discipline.md` covers post-ratification execution, `when-to-convene.md` is the threshold guide, and `worked-example.md` shows the protocol applied to a synthetic deliverable. Run the skill on your next planning question, especially when you have a draft plan and want to test it against alternatives.

### Chapter 32. The Agent Panel Review Pattern

*Who this chapter is for: anyone shipping a high-stakes deliverable who suspects one agent is not enough but does not want to convene a roundtable.*

This chapter operationalizes the pattern that produced the deliverables this kit ships[^panel-coordination-v1]. After the planning panel (Chapter 31) ratifies the plan and assigns tasks, the execution phase produces drafts. The panel review pattern is what catches blind spots in the drafts before they ship. It is the downstream sibling of `agent-panel-planning`: where planning asks "what should we build and who is best at each piece," review asks "is what we built any good."

The pattern is implemented as the `agent-panel-review` skill (Tier 1). What follows is the staged method.

#### 32.1 When to convene a review panel

A panel costs time, attention, and orchestration discipline. The threshold should be deliberately high. Most work does not need a panel.

Convene a panel when at least one of the following is true: the deliverable is high-stakes and durable (a field guide, a foreword, a public release); the work spans multiple genuinely-different functions (voice + substance + architecture, or builder + critic + integrator); the decision is irreversible at meaningful cost; you suspect groupthink in the single-agent output; or the work explicitly requires multiple perspectives.

Do not convene a panel when the work is routine code, when one good prompt would have done it, when the decision is reversible at low cost, or when you already know what you want. The convergence-theater test catches the last case: if you imagine the panel converging on loop 1 with all agents agreeing with your current instinct, and you would find that valuable, you do not need a panel, you need confirmation. A panel is bad at producing confirmation. Use it when you want the panel to disagree with your instinct and surface what you are missing.

#### 32.2 Role assignment without ego

Roles are functions, not identities. Any agent can hold any role. The three canonical templates:

**Editorial work (three roles):** voice (tone, arc, attribution), substance (the content body, technical accuracy), architecture (structural spine, packaging, provenance). This is the template that produced the v1 kit and the field guide you are reading.

**Code review (two roles):** builder (produces the patch) and critic (finds bugs, edge cases, tests). Add an integrator role for high-stakes changes like data migrations or public APIs.

**Strategic analysis (three roles):** researcher (gathers evidence and base rates), skeptic (constructs the opposing case), synthesizer (produces the integrated position with stated confidence). This template pairs naturally with the `nod-protocol` skill, which formalizes the skeptic's gated opposite-construction.

The ego rule: the producing agent does not defend the original draft when the critique lands. It revises. Defenses are limited to one-line dissents when the critique misreads scope. Anything longer is relitigation, which destroys the panel.

#### 32.3 The sealed independent pass

The hard rule, the load-bearing one: in Stage 2, no panelist sees another panelist's draft, summary, or framing. Each writes from scratch.

This is the discipline that separates structured panel review from convergence theater. Models anchor heavily on prior context. If panelist B sees even a paragraph of panelist A's draft, panelist B's output is no longer independent. It is anchored. The whole point of the panel is the unanchored signal each agent produces. When that signal is preserved, the cross-critique surfaces real blind spots. When it is destroyed, the panel just produces three flavors of the first draft.

The operator's job at this stage is to hold the seal. Do not run sessions in adjacent tabs of the same agent. Do not paste cross-session content. Do not summarize one agent's output to another. If the seal breaks, restart that panelist's first pass. The lost time is cheaper than the lost signal.

There is one common failure mode worth naming: leaky session memory. Some agent platforms share context across sessions in the same workspace. Verify your panel members are running in genuinely separate contexts. A shared system prompt is fine. A shared session history is not.

#### 32.4 Structured critique

After Stage 2 produces three independent first passes, Stage 3 sends each output to the other panelists for critique. The critique format is the discipline that keeps it from becoming negging.

Every critique covers four cells per output reviewed:

1. **Strongest claim.** The single most defensible move in this output. Specific. Cite the line or section.
2. **Weakest claim.** The single most vulnerable move. Name the vulnerability, not a vague worry.
3. **Shared blind spot.** Something this output and yours both missed. This is the cell where the panel earns its cost: it requires the reviewer to read another agent's output through the lens of what their own output also missed.
4. **One thing worth stealing.** What you would adopt from this output into yours. Concrete: a framing, a phrase, a structural move.

The cells force discipline. Without the strongest-claim cell, critique becomes a list of complaints. Without the weakest-claim cell, critique stays at the safe "this could be improved" level. Without the shared-blind-spot cell, the panel does not surface the things no single agent would have caught. Without the one-thing-to-steal cell, the revisions in Stage 4 do not incorporate the others' work.

The anti-pattern to watch: critiquing the agent instead of the work. "Claude's output is weak on attribution" is wrong. "This output is weak on attribution" is right. The work is the unit.

#### 32.5 Convergence and the no-ego revise

Stage 4 sends each panelist the critiques of its own work and asks for a revision. The discipline is to adopt or dissent in one line, then move on.

A healthy revision adopts roughly 60-80% of critiques, dissents on the rest with one-line reasoning, and produces a stronger version of the original output. Two failure modes bracket this:

**Relitigation.** A revision that turns into a 500-word defense of the original draft. The protocol breaks here. The producing agent should adopt what lands and write a single line of dissent for what does not. No 500-word defenses.

**Capitulation.** A revision that adopts every critique without judgment. Equally bad. Each panelist should retain some of its original signal. Adopting every critique flattens the panel into groupthink, which is exactly what the panel was supposed to prevent.

After Stage 4 produces three revisions, Stage 5 is the operator's job: pick the merge architecture. The merge takes the strongest layer from each, not an average. The hard part is executing the principle without operator bias collapsing the panel's signal. It is easy to call the layer that matches your instinct "strongest" and proceed; the merge framework exists to prevent that drift.

The merge procedure is per-dimension, not per-revision. List the dimensions of the deliverable (structural spine, substance density, voice, attribution, opening hook, closing arc). For each dimension, score from the panel's own outputs: the Stage 3 strongest-claim cells (which revision did the OTHER panelists name as strongest on this dimension), the Stage 4 concession lines (who conceded to whom on this dimension), and the Stage 4 one-thing-to-steal cells (what each panelist proposed to adopt). The dimension's strongest treatment is whichever revision is most frequently named across these three sources. Tally is the audit trail.

Before locking the strongest call on a dimension, run two operator-bias questions: "am I calling this strongest because I agree with it?" and "if the dominant revision were from the panelist I respect least, would I still call it strongest?" Two yeses means the merge call is safe. A no on either means escalate the merge to a fast mini-panel on that dimension, or accept the override with explicit reasoning. Silent override breaks the panel's audit trail and turns the merge into operator preference dressed up as panel output.

Integrate with attribution: the merge document or commit message names the source revision per dimension and the reason. Without the attribution, the merge looks arbitrary; with it, the merge is defensible from the panel's outputs. The full procedure with operator-bias check, integration patterns, and common failure modes lives in `reference/merge-framework.md`.

Stage 6 is the loop-or-ship decision. Healthy convergence happens between loops 1 and 3. Loop 1 convergence usually means you did not need a panel; the work could have been done by one agent with a good prompt. Loop 4 still arguing is a failure mode with five identifiable causes (question too broad, hidden assumption splitting the panel, wrong panel composition, scope creep, panelist fatigue) and a specific recovery move per cause. The wrong move on Loop 4 is keeping the panel running through the same disagreement; the right move is diagnostic first, recovery move second, then either one more focused loop or ship-the-imperfect. The full procedure lives in `reference/loop-4-recovery.md`.

The pattern is implemented as the `agent-panel-review` skill. The skill's `reference/protocol.md` has the full six-stage procedure, `reference/roles.md` covers role templates, `reference/critique-format.md` defines the four-cell template, `reference/merge-framework.md` covers Stage 5 with operator-bias checks, `reference/loop-4-recovery.md` covers diagnostic-driven recovery, `reference/when-to-convene.md` is the threshold guide, `reference/agent-strengths.md` lists known model strengths for panel composition, and `reference/worked-example.md` shows the protocol applied to a synthetic deliverable. Run the skill on your next high-stakes deliverable and you will know within one loop whether it was the right call.

---

## Part VII. A Worked Example

> **Status:** Complete. Owner: Kiro. Loop 3 delivered. Anonymized per Loop 4 decision: the downloadable package teaches the technique; the website and GitHub page may name IIP as the source proof point.

### Chapter 33. Before and After

*Who this chapter is for: anyone who wants to see the standards applied end-to-end on a real system.*

This chapter traces one production intelligence system through the transition from Era 01 to Era 03. The system is anonymized per the Loop 4 decision because the downloadable package is meant to be actionable for agents using the repo. The website and GitHub page can name IIP as the source proof point. The numbers are real.

---

**The system.** A market intelligence platform running on a single machine. It ingests news, filings, and financial data across hundreds of companies, synthesizes intelligence reports, and delivers daily briefs. It runs autonomously on a schedule. At the start of this story, it was in Era 01.

---

**Before: Era 01 (Demo)**

The system worked. It produced output. But every session started from scratch.

**Context loading:** Every session loaded the full specification document (approximately 8,000 tokens), the full design document (approximately 12,000 tokens), and the full session history (approximately 5,000 tokens). Total context per session: 25,000 tokens before any work began. On a day with three sessions, that was 75,000 tokens of re-explanation.

**Model routing:** One model for everything. Classification tasks (is this news article relevant to this company?) used the same frontier model as synthesis tasks (write a competitive analysis). The classification tasks cost the same as the synthesis tasks and produced no better output.

**Caching:** No cache. Every synthesis call ran from scratch. The nightly pipeline re-processed a 7-day window of news articles every run, re-touching thousands of already-classified articles.

**Quality:** No quality gates. A thin generation could silently overwrite a rich prior report. The operator found out weeks later when a page looked wrong.

**Observability:** Print statements. When a phase failed, the failure was invisible until the operator checked the logs manually.

**Session handoffs:** No STATE.md, no session log. Every session re-explained the project. The operator spent the first 20 minutes of every session re-orienting the AI.

**Total cost per overnight run:** Approximately 180,000 tokens. Most of it redundant.

---

**The transition: applying the standards**

The transition happened in three phases, corresponding to the three eras.

**Phase 1: Era 01 to Era 02 (two weeks)**

1. Created `AGENT.md` with the project name, constraints, tech stack, and context map. 30 minutes. Replaced 8,000 tokens of re-explanation per session.
2. Created `context/tier0.md` (5 bullets, 400 tokens) and `context/tier1-current.md` (current state, 800 tokens). Replaced the full spec load for most sessions.
3. Created `STATE.md` and `session-log.md`. Established the session end protocol.
4. Added a provider fallback chain. The primary provider was unavailable 3 times in the first week; the fallback handled it without manual intervention.
5. Added a basic LLM response cache (sha256 key, 24-hour TTL).

**Result after Phase 1:** Context per session dropped from 25,000 tokens to 1,200 tokens for most sessions. The system ran unattended overnight for the first time.

**Phase 2: Era 02 to Era 03, part 1 (one month)**

1. Added schema validation at every LLM boundary. The first week caught 12 schema violations that had been silently producing malformed outputs.
2. Added the `pipeline_runs` table and phase wrapper. Silent failures became visible within minutes instead of days.
3. Added model routing. Classification tasks moved to a local model (zero API cost). Synthesis tasks stayed on the frontier model. The routing table was defined once in `MODEL_ASSIGNMENTS`.
4. Added the input-fingerprint cache for the most expensive synthesis calls. On nights with no new data, the cache hit rate for those calls was 100%.

**Result after Phase 2:** Overnight token cost dropped from 180,000 to 42,000. Cache hit rate for synthesis calls: 67% on average, 100% on quiet nights. Schema violations caught at the boundary: 0 in production (all caught in development).

**Phase 3: Era 02 to Era 03, part 2 (two weeks)**

1. Added the quality immune system. The merge-preserve module, the DB-level trigger, the quality ledger, and the scheduled sweep. The first sweep found 3 reports that had regressed; all three were restored automatically.
2. Added intelligence lineage. Every synthesized artifact now has at least one "derived_from" edge. The "why does this say X?" question is now answerable in seconds.
3. Added event-driven dispatch. The nightly news classifier stopped re-processing the 7-day window. Each article is now processed exactly once, the moment it arrives.

**Result after Phase 3:** Overnight token cost: 18,000 (down from 180,000, a 90% reduction). Quality regressions: 0 in the 60 days since the immune system was deployed. A new operator can read `AGENT.md` + `STATE.md` and start contributing without an oral history.

---

**The numbers, summarized**

| Metric | Before (Era 01) | After (Era 03) | Change |
|---|---|---|---|
| Context per session (typical) | 25,000 tokens | 1,200 tokens | -95% |
| Overnight pipeline token cost | 180,000 tokens | 18,000 tokens | -90% |
| Cache hit rate (synthesis calls) | 0% | 67% average | +67pp |
| Schema violations reaching production | Unknown (silent) | 0 | Eliminated |
| Quality regressions in 60 days | Unknown (silent) | 0 | Eliminated |
| Time to orient a new session | 20 minutes | 2 minutes | -90% |
| Time to diagnose a phase failure | Hours to days | Minutes | -95% |

---

**What the transition required**

No new infrastructure. No new vendors. No new models. The same machine, the same subscription, the same codebase. The transition required:

- 30 minutes to create `AGENT.md`
- 2 hours to create the context tier structure
- 4 hours to add schema validation across all LLM boundaries
- 2 hours to add the `pipeline_runs` table and phase wrapper
- 3 hours to add model routing
- 4 hours to add the quality immune system
- 2 hours to add event-driven dispatch

Total: approximately 17 hours of engineering work. The payoff was a 90% reduction in token cost and the elimination of two entire classes of silent failure.

---

**The lesson**

The transition from Era 01 to Era 03 is not a rewrite. It is a series of additions, each one independent, each one compounding with the others. The system that existed at Era 01 still exists at Era 03. It just has more layers of discipline around it.

The patterns in this manual are those layers. Each one is described in the chapter that covers it. The starter kit ships the templates and code examples that make each layer deployable in hours, not days.

The system described in this chapter is real. The numbers are real. The transition is repeatable.



## Part VIII. The Enterprise Translation

> **Status:** Complete. Owner: Claude. Chapter 34 added in v3.0.8; Chapter 35 (fleet measurement) in v3.0.9.

### Chapter 34. The Enterprise Translation

*Who this chapter is for: anyone carrying this operating system into an organization that cannot run it as-is, a consultant, a deployed engineer, or an operator whose client just asked "where does our data actually go."*

Everything in this guide runs on hardware you own, subscriptions you already pay for, and a trust model with exactly one human in it. An enterprise can adopt none of that directly. The moment an IT owner asks the five questions they are paid to ask (where does data reside, how long is it retained, who can act as whom, what is the audit story, what is the spend ceiling), a personal fleet stops being an answer. What survives the move is not the infrastructure. It is the doctrine.

**The translation rule: map function by function, never tool by tool.** Every component in a personal fleet does a job, and every cloud has a managed service class that does the same job inside an account the organization owns. The mapping below uses AWS names because they are the most recognizable; Azure and GCP have direct equivalents for every row.

| Personal fleet component | The job it does | Enterprise service class (AWS example) |
|---|---|---|
| The spine machine + scheduled jobs | Always-on orchestration | Container orchestration + event scheduler (Fargate/ECS + EventBridge) |
| Files-as-API git state | Shared truth, auditable history | Object store + NoSQL, org-key encrypted (S3 + DynamoDB + KMS) |
| Env files and keychains | Credentials | Secrets Manager; agents fetch at invoke time, nothing on disk |
| Write-own / one-writer-per-store contracts | Ownership discipline | IAM least-privilege roles + RBAC, enforced by the backend, not the screen |
| Correction guards and hooks | Mechanical rule enforcement | Policy gates + model guardrails at the inference boundary |
| The utilization ledger + allowance routing | Spend awareness | Cost Explorer + hard budget caps + per-agent cost attribution |
| Verification artifacts before "done" claims | Change discipline | Change-management evidence trails |
| Boundary guard + leak gate | Egress hygiene | DLP scanning on every outbound response |
| Local vector recall | Shared memory | Managed vector store, embedded in-account |
| Subscription model access | Inference | An in-account model gateway (Bedrock-class): frontier model as planner, cheap models as workhorses |

Two principles from this guide translate so directly they should be carried over verbatim.

**The turn chokepoint.** In a personal fleet, gates accrete where the incidents happened: a hook here, a verifier there. An enterprise cannot afford scattered enforcement, and neither, it turns out, can you. Route every agent action through one pipe with an ordered gate chain: identity, kill switch, budget, guardrail, dispatch, egress scan, audit. One pipe means every safety property is checked in one place, and adding a gate is one change instead of seven.

**Fail-closed budgets.** A cost cap that only alerts is a suggestion. The enterprise-grade posture is: if the system cannot compute current spend, it refuses the request rather than letting spend run. This is cheap to build and it is the difference between a bounded bad day and an unbounded one.

**What does not translate, and must be repriced honestly.** Subscription economics do not survive the move: an enterprise build pays a fixed infrastructure floor every month before the first token, plus metered inference on top. Quote it as two numbers, floor and variable, never one. The single-operator trust model does not survive either: with more than one human, the backend becomes the authority on who may do what, and "act, do not ask" gets scoped per role and per blast radius (Chapter 27). And the human vault does not translate at all; an organization has knowledge bases, not a brain, and pretending otherwise produces a compliance problem wearing a memory system's clothes.

**The discipline.** Keep the doctrine identical on both sides of the translation: loop specs before recurring jobs, panels for contested decisions, mechanics over prose, verification before completion claims. Swap only the substrate. An operator who has run this system personally can walk into the enterprise conversation with something rare: not a slide about agents, but a working referent for every control the IT owner is about to ask for.

### Chapter 35. Measuring the Fleet: DORA for Agent Dispatch

*Who this chapter is for: anyone who has been asked "is the agent fleet actually getting better?" and does not want to answer with an anecdote.*

A fleet you cannot measure is a fleet you re-baseline by vibes. The software delivery world already solved this measurement problem once: the DORA metrics (deployment frequency, lead time, change-failure rate, time to restore) survived two decades of methodology fashion because they measure outcomes, not activity. Agent dispatch is a delivery pipeline, so the same four questions apply with almost no translation:

| DORA metric | Fleet translation | What it tells you |
|---|---|---|
| Deployment frequency | Dispatch frequency per lane | Is work actually flowing, or is the fleet decorative? |
| Lead time for changes | Submit-to-terminal time, p50 and p90 | Where dispatch latency really sits, not where it feels like it sits |
| Change-failure rate | Failed dispatches, attributed per gate, plus substitution rate | WHICH control rejects work, and how often a fallback agent had to finish the job |
| Time to restore | Time from a failed dispatch to the next success on that lane | Whether failures are blips or outages |

**The one rule that makes this work: instrument before the pilot.** Metrics bolted on after cutover have no baseline, and a number with no baseline is a mood. Put the measurement at the dispatch chokepoint (Chapter 34) on day zero, run the old path in observe-only mode, and day one of real traffic arrives with its "before" already recorded. Migrating a caller onto the new path then produces a before-and-after you can defend in a steering meeting.

Three instruments cover the whole surface, and each one answers a different failure of memory:

1. **Chokepoint DORA.** One command over the dispatch event log, plus a nightly derived rollup into a dated file. Because every dispatch passes one pipe, the metrics are complete by construction; nothing routes around the counter.
2. **The utilization ledger.** Append-only, per-agent, per-task verdicts (strong, adequate, weak, failed) with a short friction code. This is the re-baselining input: when you compose the next project's seats, the bench is picked from recorded evidence, and an agent that has drifted weak gets benched by record, not by recollection. Corrections are new lines, never edits, so the record keeps its own history honest.
3. **Lane health probes.** Cheap scheduled auth-and-latency checks per agent lane, written to a machine-readable health file the scheduler consumes. Drift in a lane's availability becomes data before it becomes an incident.

Two honesty rules keep the numbers trustworthy. Every metric prints its sample size, and a thin window says "insufficient data" instead of inventing a trend; a p90 over four dispatches is not a p90, it is a coin flip wearing statistics. And every measurement artifact is derived from the event log by a scheduled job, never hand-typed; a hand-maintained metrics file is a future lie (the derived-not-typed rule, Chapter 20, applied to your own scorecard).

The enterprise translation here is nearly free, which is the point. These are the exact numbers a delivery organization already expects, so the fleet's scorecard and the client's KPI sheet can be the same artifact, co-owned from the first week. When someone asks whether the agents are working, the answer is a dashboard row with a sample size, a baseline, and a trend, the same shape of answer they would demand from any other pipeline they fund.

---

## Appendices

### Appendix A. Vendor-Neutral Substitution Table

Use this table during public editing. Internal examples can cite real tools, but the framework should teach the portable pattern first.

| Specific term | Public term | Notes |
|---|---|---|
| `CLAUDE.md` | Operating contract or `AGENT.md` | Mention Claude-specific filename only in translation sections. |
| `AGENTS.md` | Operating contract or `AGENT.md` | Use as the Codex-native alias. |
| `.cursorrules` | Cursor operating contract | Use when discussing Cursor specifically. |
| Chroma | Knowledge index | Chroma is one implementation, not the pattern. |
| Ollama | Local model runtime | Use named runtime only in examples. |
| launchd | OS scheduler | Cron, systemd, GitHub Actions, and cloud schedulers are equivalent patterns. |
| SQLite | Persistent store | Use database-specific language only when the example depends on it. |
| IIP | Production intelligence platform | Name IIP only when intentionally used as a public case study. |
| Claude Code | Agentic coding environment | Name Claude Code in translation and reference sections. |
| Cursor | Agentic IDE | Name Cursor in translation sections. |
| Codex | Agentic coding environment | Name Codex in translation sections. |
| MCP server | Tool connector | Explain the protocol only when needed. |
| Skill | Pointer skill or reusable capability | The concept transfers across runtimes. |
| Hook | Enforcement point | May be native hook, pre-commit hook, CI check, or wrapper. |
| Project database file (e.g. `<project>.db`) | Persistent store | Keep source-specific database names out of public body copy. |
| Project session/enhancement log | Session log | Refer to it by role, not by its source filename. |

### Appendix B. Glossary

> **Status:** Complete. Owner: Claude. Phase F delivered.

Terms used throughout this manual, defined precisely. Where a term has multiple meanings in the AI literature, this glossary defines it as it is used here.

**Activity-gated batch work.** A scheduled job that checks for evidence of change in a short window before running. Skips if nothing changed; force-refreshes after a fallback interval so genuinely quiet partitions still get periodic updates. See Chapter 15.

**AGENT.md.** The operating contract file for a project. Filename is portable: Claude Code reads `CLAUDE.md`, Codex CLI reads `AGENTS.md`, Cursor reads `.cursorrules`, Copilot reads `.github/copilot-instructions.md`, Aider reads `CONVENTIONS.md`. Same content, different load mechanism per platform. See Chapter 7.

**Anti-pattern.** A practice that looks like a solution but produces the opposite of the intended result. The anti-pattern catalog (Appendix C) lists 20 specific patterns to avoid, each with a verified replacement.

**Arrested development.** An Era 01 system left in production. The demo worked, someone started depending on it, the operator never added the durable patterns. Failure mode: silent break with no diagnostic trail. See Chapter 3.

**Blast radius.** The scope of consequence if an action is taken incorrectly. Local-and-reversible blast radius is small; external-or-irreversible is large. The governance contract gates by blast radius, not by tool. See Chapter 27.

**Cache attribution.** Per-call logging of cache hits and misses with metadata (role, pipeline, prompt size). The data that turns "we have a cache" into "the cache is saving X tokens per week, the misses cluster in role Y." See Chapter 13.

**Compound system.** An AI work system whose value accumulates across sessions. Memory in files, context in tiers, synthesis evolving from prior state, expensive operations cached and measured. The opposite of a resetting system. See Chapter 1.

**Context tier (Tier 0, 1, 2, 3).** The four loading levels for context. Tier 0 always loads (under 500 tokens). Tier 1 loads for most sessions (500-2,000 tokens). Tier 2 loads on demand (2,000-10,000 tokens). Tier 3 is never loaded directly; use search or queries. See Chapter 8. Not to be confused with the output tiers in the Two-Tier Output Model (Chapter 4).

**Demo (Era 01).** The first era of AI system maturity. Question it answers: can this work? Signals: built fast, no downstream consumer, silent failures equal empty tables, observability is print statements. See Chapter 3.

**Durable (Era 03).** The third era of AI system maturity. Question it answers: can others rely on it? Signals: schema validation at every LLM boundary, lineage on every artifact, observability in the morning brief, token efficiency measured. The patterns in this manual are Era 03 standards.

**Event-driven dispatch.** Processing data when an event signals new input rather than on a fixed schedule. Replaces nightly re-scan of unchanged data with per-event work. See Chapter 15.

**Greater Vault pattern.** A two-level reference architecture. Level 1 is a small summary file with an explicit path to Level 2. Level 2 is the full reference, loaded on demand. See Chapter 10.

**Hard constraint.** A line in the operating contract that the agent must never violate. Phrased as imperatives: "Never use pip." "Always run tests before commit." Each constraint earns its place by referring to a specific past failure.

**Input-fingerprint cache.** A cache keyed on the hash of the upstream inputs to a synthesis call (summaries plus context plus prior state), not the prompt itself. Highest-ROI pattern for scheduled pipelines. See Chapter 12.

**Intelligence lineage.** The provenance graph that connects synthesized artifacts to the raw evidence that produced them. Edges include `derived_from`, `confirmed_by`, `contradicted_by`. Required for any system where the output influences real decisions. See Chapter 22.

**LLM boundary.** Any point where output from a language model enters the system as input to a downstream consumer. Every LLM boundary requires schema validation before the output is trusted. See Chapter 21.

**Model routing.** The policy that assigns task types to model tiers. Parsing and classification go to the cheapest model; mechanical edits go to a fast tier; multi-file engineering goes to a mid tier; architecture decisions and synthesis go to the top tier. Defined in a model-routing table at the project level. See Chapter 17.

**Observable insight (Tier 1 output).** An insight that any reasonably attentive analyst could spot. The AI's contribution is speed and coverage, not synthesis. Contrast with Synthetic insight. See Chapter 4.

**Operating contract.** Synonym for the AGENT.md file. The machine-oriented contract that defines what the project is, what the AI must never do, where context lives, and which conventions apply. See Chapter 7.

**Phase wrapper.** A bash function that wraps a phase of a pipeline with start, end, and status logging plus error tolerance. Lets one phase fail without aborting the rest of the pipeline. See Chapter 23 and `code/phase_wrapper.sh` in the starter kit.

**Pipeline runs table.** A SQL table that records every scheduled phase's start, end, status, and error message. The minimum viable observability layer. See Chapter 23 and `code/pipeline_runs.sql` in the starter kit.

**Pointer skill.** A skill file (`SKILL.md`) under 100 lines, target 80 that describes a capability and points to where the actual implementation lives. The session loads the pointer cheaply and only pays the cost of loading the implementation when the skill is invoked. See Chapter 11.

**Premature polish.** Era 03 obsession applied to an Era 01 system. The operator builds schemas, lineage, and quality gates before the underlying approach has been validated. The output is well-traced and wrong. See Chapter 3.

**Promotion rule.** The discipline of moving reusable patterns from session logs to a shared patterns reference on first reuse. Patterns that live only in session logs get re-derived in every new session. See Chapter 26.

**Prompt normalization.** Stripping non-semantic tokens (incidental dates, whitespace, session metadata) from a prompt before hashing it for cache lookup. Lifts cache hit rates significantly. See Chapter 12.

**Quality immune system.** A four-layer defense against silent narrative regression: application-level merge-preserve, database-level write trigger, append-only quality ledger, scheduled sweep with auto-heal. Prevents thin AI outputs from quietly overwriting rich prior outputs. See Chapter 24.

**Ramp-up (Era 02).** The second era of AI system maturity. Question it answers: can this run unattended? Signals: scheduled jobs produce artifacts, someone downstream depends on them, drift is noticed in the weekly review. See Chapter 3.

**Red lines.** The gated actions in the governance contract. Destructive git operations, paid actions, external publishing, data-dropping migrations, auth and secret changes. Hook-enforced where possible. See Chapter 27.

**Reset problem.** The failure mode where every AI session starts from zero context, re-explains the project, re-summarizes the same source files, and re-derives state the previous session already established. The opposite of compounding. See Chapter 1.

**Resetting system.** An AI work system that loses state at every session boundary. Pays the full cost on every call. The default failure mode for AI work without an operating standard. See Chapter 1.

**Response cache.** A cache that stores LLM responses keyed on a hash of (model + effort + normalized_prompt). Distinct from the input-fingerprint cache, which keys on the upstream source data. See Chapter 12.

**Schema validation.** Parsing an LLM response against a typed schema before downstream use. Catches drift at the boundary instead of letting it cascade. See Chapter 21.

**Session lifecycle.** The protocol every non-trivial session follows. Start: read AGENT.md, read STATE.md, load relevant tier1, optionally search the knowledge index. End: update STATE.md, append to session-log, update BACKLOG, promote patterns. See Chapter 9.

**Skills-routing pattern.** The architectural discipline of routing capability through a small `_skills-index.md` plus pointer SKILL.md files, instead of bundling all instructions into one large operating contract. The differentiator that makes a kit feel like a product. See Chapter 11.

**So What test.** A quality gate applied to every intelligence output: can the result be explained in terms of why it matters to someone's decision, business, or career? If not, it does not ship. See Chapter 25.

**STATE.md.** The live state file for a project. Updated by every session that changes something. Records what is running, what is blocked, what is next.

**Synthetic insight (Tier 2 output).** An insight that requires cross-domain synthesis to formulate, invisible without the multi-domain view. The valuable output of a Compound AI system. Contrast with Observable insight. See Chapter 4.

**Universal skill routing.** The multi-agent extension of the skills-routing
pattern. Each runtime keeps its native skill root, while shared skills are
symlinked to one canonical master directory such as `~/.compound-ai/skills`.
Prevents Claude, Codex, OpenSpace, and future agents from drifting into
different local copies of the same skill. See Chapter 11.

**Two-Tier Output Model.** The classification of AI-produced insights as Tier 1 Observable (any analyst could spot this) or Tier 2 Synthetic (requires cross-domain synthesis). Pipelines optimize for the Tier 1 to Tier 2 ratio, not for volume. See Chapter 4.

**Verify-origin.** The optional online verification script in the starter kit. Reports `VERIFIED`, `LOCAL-ONLY`, `MODIFIED`, `FORKED`, or `UNKNOWN`. Never required for normal use; only blocks the claim "verified official release."

**X+Y=Do Z formula.** The structure of an actionable recommendation: existing asset (X) plus unmet need (Y) equals specific action (Z). A test, not a template. Outputs that fail the formula are generic advice. See Chapter 5.

### Appendix C. Anti-Pattern Catalog

> **Status:** Complete. Owner: Kiro. Phase C delivered.

Every pattern in this catalog has been observed in production. Each entry: the anti-pattern, why it burns, and the replacement.

| Anti-pattern | Why it burns | Replace with |
|---|---|---|
| Loading full spec on every session | 5,000 to 10,000 redundant tokens per session | Tiered context loading (tier0 plus relevant tier1) |
| Re-deriving project state from scratch | Burns tokens on work already done | STATE.md plus session log handoffs |
| Using AI to summarize what a file already says | Redundant synthesis | Load the file directly |
| Vague context pointers ("see the docs") | Session burns tokens searching | Explicit paths in AGENT.md |
| No session end protocol | Next session re-orients from scratch | STATE.md plus session log update before exit |
| Full-tier model for parsing tasks | 5 to 10x cost for no quality gain | Cheapest model for parsing, full model for synthesis |
| Rebuilding synthesis from scratch each run | Ignores accumulated context | Prior state in synthesis prompt |
| Indexing everything in semantic search | Noise degrades retrieval quality | Index knowledge about the system; query DB for data |
| No cache invalidation strategy | Stale outputs served as fresh | Explicit TTL plus input-fingerprint cache |
| Patterns that live only in session logs | Re-derived in every new session | Promote to patterns reference on first reuse |
| `json.loads(response)` with no schema check | Silent drift cascades to every consumer | Schema validation at every LLM boundary |
| Bulk nightly re-sweep of unchanged data | Burns tokens on quiet days | Event-driven dispatch plus activity gate |
| "I'll add quality guards later" | Every narrative regression in production started this way | Quality guard ships with the pipeline |
| Print statements as observability | Log grows, nothing queryable, stuck jobs invisible | `pipeline_runs` table plus phase wrapper |
| Demo-era "it works on my machine" | Dependent jobs break silently when shape drifts | Schema contracts plus lineage plus observability |
| Numeric IDs in public subscription URLs | Enumeration bypasses the gate | Opaque base62 slugs |
| `"$@"` in `set -e` bash without `if/then` | One phase failure kills the whole overnight | `if "$@"; then code=0; else code=$?; fi` |
| Defensive `isinstance` checks at every read site | Normalization scattered everywhere, easy to miss one | Write-time canonicalization |
| Cache hit rate "assumed good" | No visibility into whether it is actually saving tokens | `llm_cache_attribution` sidecar plus `report_cache_savings()` |
| Synthesis-tier model for orchestrator confirmations | Expensive deliberation on mechanical decisions | Fast model for confirmations, full model for judgment calls |

### Appendix D. The Starter Kit, Annotated Tour

> **Status:** Complete. Owner: Claude. Phase F delivered.

The starter kit is the deployable version of every pattern in this manual. This tour walks every file in the v1.0 release, in the order a new user encounters them, with a one-line purpose statement and a pointer to the chapter that explains the design choice. A reader who has finished the field guide can skim this appendix in five minutes; a reader who lands here first will know which chapter to read for any file they touch.

**Top-level files (the cold-start surface)**

```
compound-ai-starter-kit/
  README.md                     Cold-start guide, "operational in under an hour"
  LICENSE.md                    CC BY 4.0 (docs) + Apache 2.0 (code) with NOTICE clause
  NOTICE.md                     Apache NOTICE preservation, attribution required on redistribution
  CITATION.cff                  Academic-style citation file, machine-readable
  codemeta.json                 Schema.org-aligned software metadata
  compound-ai.manifest.json     Origin, version, license, file-by-file sha256, aggregate hash
  compound-ai.sha256            Plain-text checksum file matching the manifest aggregate
```

These seven files are the provenance surface. A new user who runs `verify-integrity.py` against them gets a clean local check of "this is the unmodified v1.0 release." See Chapter 27 (Governance) and the attribution architecture established in the build plan. The license split (CC BY 4.0 for docs, Apache 2.0 for code) is the standard combination for a kit that mixes prose and reusable code samples.

**The operating-contract surface**

```
  AGENT.md                      Clean operating contract template, ready to fill
  AGENT.annotated.md            Same template with eleven section-level margin notes
  Project.md                    Human-readable project overview template
  STATE.md                      Live state dashboard template
  session-log.md                Append-only build log template
  BACKLOG.md                    Open items, deferred decisions, known debt
  _map.md                       Navigational manifest for this tier
  _skills-index.md              Lazy-loaded router for the kit's skills
```

`AGENT.md` is the deployable version; `AGENT.annotated.md` is the teaching version. Read the annotated version once, deploy the clean version. See Chapter 7 (The Operating Contract). `Project.md` is the human counterpart, narrative-style for stakeholders. `STATE.md` is the live dashboard updated by every session that changes something (Chapter 9). `_map.md` and `_skills-index.md` together implement the skills-routing pattern from Chapter 11; the index keeps the always-loaded surface small while the map handles navigation.

**Context tiers**

```
  context/
    tier0.md                    Always-load operating bullet, under 500 tokens
    tier1-current.md            Auto-updated live state, loaded by most sessions
    tier1-subsystem/
      README.md                 How to create per-subsystem context slices
```

These three files implement the tiered context loading architecture from Chapter 8. `tier0.md` ships with five-bullet placeholders; `tier1-current.md` ships empty, populated by the first real session. The `tier1-subsystem/` directory is empty by default; create one file per subsystem as the project grows.

**Conventions (the in-kit reference layer)**

```
  conventions/
    token-efficiency.md         Token discipline rules with worked examples
    skill-author-guide.md       Pointer-skill discipline, under-80-lines rule
    session-log-format.md       Append-only, newest at top, format conventions
    provenance.md               Origin and attribution mesh, manifest format
    style-guide.md              Public, vendor-neutral deliverable style rules
```

These five files are the in-kit reference layer. The session loads them on demand, not by default. Token efficiency aligns with Part III. Skill author guide is the discipline for writing new pointer skills (Chapter 11). Session log format documents the append-only protocol used by `session-log.md`. Provenance documents the attribution architecture, the manifest schema, and the verifier flow. Style guide documents the public visual and editorial defaults for generated deliverables.

**Skills (the routing layer)**

```
  skills/
    context-loader/SKILL.md             Decides Tier 0/1/2/3 for the task
    token-economist/SKILL.md            Audits a workflow for redundant context and misrouting
    quality-gate/SKILL.md               Verifies schema, lineage, preservation, closeout
    pattern-promoter/SKILL.md           Moves a pattern from session log to knowledge layer
    engagement-bootstrap/SKILL.md       Creates AGENT.md, Project.md, STATE.md, _map.md
    provenance-check/SKILL.md           Reports origin, version, manifest match, optional online
```

Six pointer skills, each under 100 lines, target 80, each dispatching to the relevant implementation or convention file. The skills are the practical interface to the manual: a session that wants to optimize context tiers invokes a routing skill, not "read Chapter 8 of the field guide." See Chapter 11 (Skills-Routing Pattern) for the architecture.

> Note: this section documents the original starter-kit skill layout. Several of these pointer skills (`context-loader`, `pattern-promoter`, `provenance-check`, `trigger-indexer`) were consolidated into broader skills or demoted to CI in the v3.0.0 merge. `_skills-index.md` is the authoritative, derived list of the current routable skills; treat it, not this historical appendix, as ground truth for what exists today.

**Checklists (the operational interface)**

```
  checklists/
    session-start.md            Five-step start protocol
    session-closeout.md         Five-step end protocol, the discipline gate
    new-project.md              Seven-step bootstrap checklist for a fresh project
    pattern-promotion.md        Three-question checklist for promoting a pattern
    model-routing.md            Decision table for model-tier assignment
    era-01-to-02.md             Demo to Ramp-up transition criteria
    era-02-to-03.md             Ramp-up to Durable transition criteria
```

Seven checklists, each readable in under two minutes, each tied to a specific chapter. The session-start and session-closeout checklists implement Chapter 9. The new-project checklist is Chapter 28. The era checklists are Chapter 3's diagnostic in actionable form.

**Templates (the deliverable scaffolds)**

```
  templates/
    token-budget.md             Worksheet for sizing a session's token budget
    model-routing.md            Project-level model-routing table template
    quality-gates.md            Per-output-type quality gate checklist
    lineage-record.md           Provenance-edge template for synthesized artifacts
```

Four templates that scaffold the deliverables the manual references. Token-budget is the Chapter 8 sizing exercise. Model-routing is the Chapter 17 routing table for a specific project. Quality-gates and lineage-record fulfill Chapters 21 and 22.

**Code (the runnable reference implementations)**

```
  code/
    schema_validator.py         Generic LLM schema validator with auto-retry
    cache_key.py                Response cache + input-fingerprint cache + ResponseCache
    phase_wrapper.sh            Bash phase wrapper with SQLite logging
    pipeline_runs.sql           Observability + cache attribution + quality ledger schema
```

Four files, all vendor-neutral, all Apache 2.0 licensed, all runnable. `schema_validator.py` is the Chapter 21 boundary defense. `cache_key.py` ships both cache types from Chapter 12. `phase_wrapper.sh` is the Chapter 23 phase-level observability primitive. `pipeline_runs.sql` is the schema that makes the wrapper's writes queryable. A user can copy any of these directly into a project and run them.

**Scripts (the kit-maintenance tools)**

```
  scripts/
    build-manifest.py           Computes file-by-file sha256, writes manifest.json
    verify-integrity.py         Verifies local files against the bundled manifest
    verify-origin.py            Optional online verification; reports VERIFIED/LOCAL-ONLY/etc.
    new-project.sh              Scaffolds a fresh project from the kit templates
```

Four scripts. The first two are the integrity loop: `build-manifest` is run by the maintainer when a release is cut; `verify-integrity` is run by users to confirm their copy is unmodified. `verify-origin` is the optional online check (Chapter 27 attribution architecture); never required for normal use. `new-project.sh` is the bootstrap script that creates a fresh project tree from the kit's templates.

**Hooks (the convention-enforcement layer)**

```
  hooks/
    pre-commit/no-em-dashes.sh        Blocks commits containing em dashes
    post-session/append-state.sh      Writes a STATE.md entry at session end
```

Two hooks, both optional, both demonstrating the principle from Chapter 10: conventions enforced by tooling outlive conventions stated as preferences. The em-dash hook is the canonical small example; the post-session hook is the operational discipline from Chapter 9 made automatic.

**File count by category**

| Category | Files |
|---|---|
| Top-level (provenance + license + manifest) | 7 |
| Operating contract surface | 8 |
| Context tiers | 3 |
| Conventions | 5 |
| Skills | 6 |
| Checklists | 7 |
| Templates | 4 |
| Code | 4 |
| Scripts | 4 |
| Hooks | 2 |
| **Total** | **50** |

A kit with 50 files might sound large. It is not. The always-loaded surface is `AGENT.md` plus `_map.md` plus `_skills-index.md`, which together total under 600 lines. Everything else loads on demand, when the session needs it. The skills-routing architecture from Chapter 11 is what makes this work: the kit ships rich capability with a cheap default context cost.

**Deployment checklist for a new user**

1. Download the v1.0 release zip from `cameronsutcliff.com/compound-ai` or clone the GitHub repo.
2. Run `scripts/verify-integrity.py`; expect a `LOCAL-ONLY` result with all files matching the bundled manifest.
3. Copy the kit into your project as a starting tree, or run `scripts/new-project.sh` to scaffold a fresh project.
4. Fill in `AGENT.md` (read `AGENT.annotated.md` first if it is your first time).
5. Initialize `STATE.md` and `session-log.md` from the templates.
6. Bootstrap the first session by loading `context/tier0.md` plus the relevant `context/tier1-*.md` slice.
7. Invoke the skills you need from `_skills-index.md` as triggers arise.
8. At session end, run `hooks/post-session/append-state.sh` (or the equivalent in your AI runtime).

A user who follows the checklist is operational in under an hour. A user who fills in the templates without reading the field guide will still get value from the kit; the kit is designed to stand alone. A user who reads the field guide first will understand why each file is shaped the way it is.

### Appendix F. Further Reading

> **Status:** Complete. Owner: Claude. Phase F delivered.

A short, opinionated list. No padding. If a reference is here, it informed the work or is the right thing to read next.

**The prior-art frame.** Matei Zaharia, Omar Khattab, Lin Chen, Jared Davis, Heather Miller, Chris Potts, James Zou, Michael Carbin, Jonathan Frankle, Naveen Rao, Ali Ghodsi. "The Shift from Models to Compound AI Systems." *Berkeley AI Research Blog*, February 2024. Names the shift this manual operationalizes. BAIR theorized the architecture; this is the operating layer.

**Agentic IDE documentation.** For platform-specific implementation details, the canonical documentation is the canonical reference. Anthropic's Claude Code docs (skills, hooks, MCP). OpenAI's Codex CLI docs (AGENTS.md, agent configuration). Cursor's docs on `.cursorrules` and `.cursor/rules`. GitHub's Copilot CLI documentation. Aider's conventions documentation. Continue.dev's configuration reference. These do not need to be read end-to-end; reference them when implementing a specific feature from the kit on a specific platform.

**On agentic systems and orchestration.** Andrej Karpathy's writing and talks on agentic AI, especially his framing of "Software 3.0" and the autoresearch pattern. The original CLAUDE.md examples that triggered the operator-contract pattern in the broader field. The argument is the same as this manual's, applied at the example level rather than the standard level.

**On prompt engineering and LLM safety.** Simon Willison's blog (`simonwillison.net`) is the running operator's notebook for the field. Especially useful for prompt injection, structured output, and the day-to-day of treating LLMs as systems rather than oracles. Every operator should follow it.

**On retrieval and embeddings.** The Chroma documentation for the practical patterns. The OpenAI embeddings cookbook for the canonical reference. The pgvector documentation for the SQL-native approach. The skill in this manual is knowing when to use retrieval at all (Chapter 20 and Appendix A); the platform docs handle the implementation.

**On reliability and durable systems.** The Patterns for Durable Agentic Systems reference document, the source from which several patterns in this manual were distilled. The manual generalizes; the patterns document keeps the IIP-specific implementation details. If you want the original case material, that is where it lives.

**On scaled engagement.** The `_ClaudeDelivery` reference pack, the multi-tier deployment pattern that inspired the skills-routing architecture in Chapter 11. Use it as the heavier-weight version of this manual's lighter starter kit when you need a multi-client, multi-tier deployment with full convention enforcement.

**On knowing when to stop.** Donald Knuth's *The Art of Computer Programming* preface, the Joel Spolsky archive at `joelonsoftware.com`, and Edsger Dijkstra's "The Humble Programmer" Turing Lecture. None of these are about AI. All of them are about the same problem this manual addresses: how to build systems that survive being depended on. Read them when the AI specifics start to feel like the whole story; they are not.

**On nothing else.** Resist the temptation to fill this list. A reference that does not change your work is a citation, not a reading. If you need more depth on a specific topic in this manual, the chapter cites the source. If a topic is not covered, this manual was not designed to cover it.

---

*Compound AI Operating Standards v1.0.0-draft. Foreword complete; remainder in progress. Build coordinated in the rolling build log.*

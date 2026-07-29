# Universal Skill Routing

Compound AI is not a set of special "compound" skills. It is an operating
pattern for sharing skills across agents without loading every skill into
context.

## Principle

Each agent keeps using the skill directory its manufacturer expects. Shared
skills route from that native directory to one canonical skill source of truth.

Typical layout:

```text
~/.compound-ai/
  operating-standards/
  skills/
    spotlight/
    ceo/
    skill-creator/

~/.claude/skills/spotlight  -> ~/.compound-ai/skills/spotlight
~/.agents/skills/spotlight  -> ~/.compound-ai/skills/spotlight
~/.codex/skills/spotlight   -> ~/.compound-ai/skills/spotlight
```

## Rules

1. Native runtime roots remain native. Do not make Claude read Codex's root or
   Codex read Claude's root when the runtime already has its own directory.
2. Shared skills live once under the canonical global directory.
3. Runtime roots contain symlinks for shared skills.
4. Tool-specific skills can remain tool-specific.
5. Edit the canonical skill copy first.
6. Run a drift audit after changing any shared skill.
7. Do not duplicate the same shared skill into multiple runtime roots unless a
   runtime cannot follow symlinks.

## Recommended Paths

| Purpose | Path |
|---|---|
| Global operating standards | `~/.compound-ai/operating-standards` |
| Global shared skills | `~/.compound-ai/skills` |
| Claude native root | `~/.claude/skills` |
| OpenSpace or shared agent root | `~/.agents/skills` |
| Codex-specific skills | `~/.codex/skills` |

## Verification

Use a drift audit that compares resolved skill directory contents across
runtime roots.

Expected result:

```text
OK spotlight missing=-
OK ceo       missing=-
```

`missing=codex` can be acceptable when Codex already sees the shared skill
through another configured root, such as `~/.agents/skills`, or when the skill
is intentionally not available to Codex.

Any `DRIFT` row means two runtimes have different copies of what appears to be
the same shared skill. Resolve by choosing or merging the canonical copy, then
replace runtime copies with symlinks.

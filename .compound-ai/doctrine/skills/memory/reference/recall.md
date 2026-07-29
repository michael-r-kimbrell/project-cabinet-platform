# Mode: recall

Retrieve prior context by search instead of by re-reading whole files or
trusting memory. Use when the operator asks "what do we know about", "what
happened with", "search memory", or "find past context".

## Principle

Search beats scanning. The knowledge graph and session logs are designed to be
queried, not bulk-loaded. Recall from files; never recall from context alone, and
always cite the source file you retrieved from.

## Search strategy (pick by question shape)

| Question shape | Method | Why |
|---|---|---|
| Conceptual, fuzzy wording ("when did we decide to...") | semantic search | matches meaning, not exact words |
| A specific phrase, name, or path | keyword search (BM25) | exact-token precision |
| "Find anything related to this idea" | vector similarity | nearest concepts, even with different wording |

A capable backend layers all three (vectors + keyword + reranking). If the store
has a query tool, prefer it over grep. If not, fall back to keyword grep over the
knowledge folders and session logs.

## Steps

1. Pick the method from the table by the question's shape.
2. Search the knowledge graph first (curated facts), then session logs (timeline).
3. Read only the matching `summary.md` or Quick Reference sections, not whole files.
4. If results conflict, prefer the most recent non-superseded fact; note the
   supersession chain.
5. Answer with the retrieved context and cite each source file.

## Check

Every claim in the recall answer traces to a named source file. If nothing was
found, say so plainly rather than filling the gap from memory.

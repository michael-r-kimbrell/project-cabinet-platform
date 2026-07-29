# Model Routing Checklist

Use the cheapest competent route.

| Task | Recommended route |
|---|---|
| File read or status check | No model |
| Classification | Small or local model |
| Extraction | Small or local model |
| Mechanical edit | Fast coding model |
| Multi-file implementation | Strong coding model |
| Synthesis | Strong reasoning model |
| Architecture decision | Strongest reasoning model plus human gate if high-risk |

Before using a strong model, ask:

1. Is this synthesis or just parsing?
2. Is there a file or database query that answers it directly?
3. Has this already been computed?

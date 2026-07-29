# Contributing

Thanks for considering a contribution. This kit is co-owned by Cameron Sutcliff
and Joshua Sutcliff and is dual licensed (CC-BY-4.0 for docs, Apache-2.0 for
code). By contributing you agree your contribution ships under those terms.

## How this repo is maintained

This repository is published from a canonical source and scrubbed for release,
so substantial changes are reconciled into that source by the maintainers and
re-derived. That means:

- **Small fixes (typos, broken links, doc clarity, a failing edge case):** open
  a pull request directly. We will integrate it upstream and it will reappear on
  the next derive.
- **Larger changes (a new skill, a new capability, a runtime adapter):** open an
  issue first so we can agree on shape before you build. New skills must follow
  `doctrine/conventions/skill-author-guide.md` and register in the trigger
  registry; new runtimes must satisfy the conformance tests in
  `capabilities/adapter-contract.md`.

## The bar: keep the gates green

Enforcement is the point of this kit, so the kit holds itself to it. Before you
open a PR, run both and make sure they pass:

```bash
bash enforcement/bin/check-kit.sh
bash enforcement/tests/run-selftest.sh
```

CI runs the same checks on every push and pull request
(`.github/workflows/enforce.yml`). A PR that reds the gates will not merge. In
particular:

- Skill counts are derived, never hand-typed (`check-counts.sh`).
- Benchmark figures live only in the generated `proof/.../results.md`, never
  hand-typed into docs (`check-benchmark-figures.sh`).
- No personal paths, names, or private project references
  (`check-portability.sh`). This is a public kit; keep it portable.
- Pointer files stay within the line cap; tier-0 stays lean.

If you add a gate or a runtime, add a matching planted-fixture assertion to
`enforcement/tests/run-selftest.sh` so the new check is itself tested.

## Style

No em-dashes. Plain Markdown and YAML in the portable layers (`doctrine/`,
`capabilities/`). Keep claims honest and labeled: state what is mechanically
enforced versus advisory, the way `docs/known-limits.md` does.

## Reporting problems

Bugs and security issues: see `SECURITY.md`. Everything else: open an issue.

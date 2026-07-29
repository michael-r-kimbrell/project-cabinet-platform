# Enforced Runtime Agents

The pinned cheap workers recognized by `usage-guard.sh` Policy 1:

- `researcher`
- `code-generator`
- `tester`

Their portable contracts are folded (co-credited) into the `delegation` skill
(research/generate/test worker references). The vendored guard recognizes these
names so the runtime wiring and fail-open self-tests run against them.

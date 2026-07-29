# Codex runtime directives

This directory adapts Codex to the shared capability contract in
`../../capabilities/adapter-contract.md`.

## Dispatch discipline

For every task:

1. Treat the user request as `dispatch(task) -> result`.
2. Run session routing first, using LIGHT, MEDIUM, or HEAVY discipline.
3. Apply usage discipline before delegation, autonomous loops, or broad tool
   fan-out.
4. If a GoalContract is supplied, verify the completion condition before
   returning `done`.
5. Return a result with `id`, `status`, and `output`; include `halt_reason`
   whenever status is not `done`.

## Runtime mapping

- Native instructions: this `AGENTS.md`.
- Mechanical wrapper: `dispatch.sh`.
- Shared fallback: `../generic/prompt-prelude.md`.

Codex does not get privileged behavior. It implements the same capability
contract as every other runtime.

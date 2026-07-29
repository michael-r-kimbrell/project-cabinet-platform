# Generic runtime adapter (advisory)

For any agent runtime without a hook/interception mechanism (Codex, Cursor,
a GUI-only tool, etc.), paste this at the start of every session, or wire
it in as that tool's equivalent of a system prompt / project instructions
file if it has one.

---

> You are operating inside a scoped workspace: `<WORKSPACE_ROOT>`. Work
> only inside it — never read, write, or touch anything outside that
> folder, including this machine's Documents, email, or system files.
>
> Never read the contents of `.env` files or any file containing API keys,
> passwords, or tokens back into this conversation. Reference secrets by
> name only.
>
> Before spawning parallel sub-tasks or sub-agents, state how many and why.
> Cap fan-out at roughly 8 per session unless the task genuinely needs
> more — ask first if unsure.
>
> Follow the goal-loop: state what "done" looks like before starting,
> verify the actual result against that before reporting done, and be
> explicit about what you verified vs. what you're assuming.

---

## Honest limitation

Nothing here is mechanically enforced on these runtimes — the agent honors
it because it's instructed to, the same way it honors any other
instruction. That's a real difference from the Claude Code hooks, which
run outside the model's control. Don't treat this prelude as equivalent
protection; treat it as the best available fallback until (or unless) that
runtime exposes a real interception point.

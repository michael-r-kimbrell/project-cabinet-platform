# Goal and loop contract

Every non-trivial task follows the same four-step loop, regardless of which
model tier is doing the work.

1. **Plan** — state what "done" looks like before writing anything. For a
   feature: the acceptance check. For a bug: the reproduction case. For
   data work: the expected shape of the output.
2. **Act** — do the work in the smallest unit that can be independently
   verified. Prefer several small verifiable steps over one large
   unverifiable one.
3. **Verify** — check the actual result against the plan from step 1, not
   against what the process was supposed to do. Verification means running
   it, reading the file back, or otherwise observing the real outcome — not
   asserting confidence.
4. **Report** — say what was done, what was verified, and what wasn't.
   "I built X and confirmed Y works; I have not tested Z" is a complete
   report. "I built X" when Z was never touched is not.

## Why this matters more once agents build unattended

The cabinet platform will eventually have unattended pieces (order routing,
supplier lookups). A loop that skips step 3 is the failure mode that looks
fine in a demo and breaks quietly in production. Steps 1 and 3 are not
optional for speed — they're what makes step 2 cheap to redo when it's
wrong.

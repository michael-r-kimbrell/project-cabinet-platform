# release-captain: Output Template

The ship-gate report is the canonical output. It documents that each
step ran, what the evidence was, and the final SHIP / BLOCK decision.
The report goes into the release commit message and (for full releases)
into a `releases/<version>/ship-gate-report.md` file.

---

## Standard format

```
SHIP-GATE REPORT: [Kit Version]

Release candidate: compound-ai-starter-kit-vN.N.N.zip
SHA256: [hash]
Operator: [name or "agent"]
Date: YYYY-MM-DD

Step 1: Clean unzip into /tmp
  Status: PASS / FAIL
  Evidence: [unzip exit code; top-level directory]
  [If FAIL: remediation taken]

Step 2: verify-integrity.py
  Status: PASS / FAIL
  Evidence: [stdout summary; "LOCAL-ONLY: local files match bundled manifest"]
  File count: NNN
  [If FAIL: missing/extra files listed]

Step 3: verify-origin.py --online
  Status: PASS / FAIL
  Evidence: [Status line from output]
  Manifest URL: [URL]
  [If FAIL: divergent fields]

Step 4: Three-version reconciliation
  Status: PASS / FAIL
  Bundled manifest: vN.N.N
  Public manifest:  vN.N.N
  Page hero badge:  vN.N.N
  [If FAIL: which value is wrong]

Step 5: SHA256SUMS coverage
  Status: PASS / FAIL
  Evidence: [diff result]
  [If FAIL: assets without SHA rows]

Step 6: Field guide badge ↔ markdown version
  Status: PASS / FAIL
  Markdown filename: Compound-AI-Operating-Standards-vN.N.N.md
  Badge text: vN.N.N
  [If FAIL: mismatch detail]

Step 7: releaseUrl resolves to current tag
  Status: PASS / FAIL
  URL points to: vN.N.N
  HTTP response: 200 / 404
  [If FAIL: tag missing or URL pointing at wrong version]

Step 8: Public downloads return 200
  Status: PASS / FAIL
  Assets checked: [count]
  Failed: [count]
  [If FAIL: list of 404'd URLs]

Step 9: SKILL.md line-count budget
  Status: PASS / FAIL
  Files over 100 lines: [list with line counts]
  [If FAIL: which files need trimming]

Step 10: Screenshots
  Status: PASS / FAIL
  Landing page: screenshots/vN.N.N-landing.png
  Field guide:  screenshots/vN.N.N-fieldguide.png
  Visual issues: [none / list]

---

DECISION: SHIP / BLOCK

[If SHIP: ready for tag + push + GitHub release]
[If BLOCK: failing step number(s); remediation plan; estimated time to fix]
```

---

## Compact format (for inline reporting)

When the ship gate runs as a sub-step of another skill (rare, but
possible if a panel includes release-captain as a verification stage),
a compact form is acceptable:

```
SHIP-GATE: vN.N.N
  Steps 1-10: [10 pass / 9 pass 1 fail step-N]
  Decision: SHIP / BLOCK
  [If BLOCK: one-line remediation]
```

Compact output still requires every step to have run. It just
suppresses the evidence prose.

---

## Sample report (synthetic)

```
SHIP-GATE REPORT: v2.3.2

Release candidate: compound-ai-starter-kit-v2.3.2.zip
SHA256: 5dc9d42e44dfbe353b5310657ce9ba7079b776115614287c168fd1ce07e5e584
Operator: agent (Claude session)
Date: 2026-05-14

Step 1: Clean unzip into /tmp
  Status: PASS
  Evidence: unzip exit 0; top-level kit-v2/
  No anomalies.

Step 2: verify-integrity.py
  Status: PASS
  Evidence: "LOCAL-ONLY: local files match bundled manifest"
  File count: 167
  Aggregate SHA: baa27c29a73cf6b7b8715858df28c4206e456967d7e3f25b89f72d4ae9b9ed8b

Step 3: verify-origin.py --online
  Status: PASS
  Evidence: "Status: VERIFIED"
  Manifest URL: https://cameronsutcliff.com/compound-ai/manifest.json

Step 4: Three-version reconciliation
  Status: PASS
  Bundled manifest: v2.3.2
  Public manifest:  v2.3.2
  Page hero badge:  v2.3.2

Step 5: SHA256SUMS coverage
  Status: PASS
  All current assets have SHA rows. Legacy v1.x SHAs preserved.

Step 6: Field guide badge ↔ markdown version
  Status: PASS
  Markdown: Compound-AI-Operating-Standards-v2.3.2.md
  Badge:    v2.3.2

Step 7: releaseUrl resolves to current tag
  Status: PASS
  URL: https://github.com/cameronpsutcliff/compound-ai/releases/tag/v2.3.2
  HTTP: 200

Step 8: Public downloads return 200
  Status: PASS
  Assets checked: 6
  All returned 200.

Step 9: SKILL.md line-count budget
  Status: PASS
  Files over 100 lines: none
  Largest SKILL.md: request-router at 98 lines (under budget by 2).

Step 10: Screenshots
  Status: PASS
  Landing page: screenshots/v2.3.2-landing.png
  Field guide:  screenshots/v2.3.2-fieldguide.png
  Visual issues: none

---

DECISION: SHIP

Ready for tag + push + GitHub release.
```

---

## Sample report with a BLOCK (synthetic, illustrative)

```
SHIP-GATE REPORT: v2.3.1 (the actual failure that motivated this skill)

Release candidate: compound-ai-starter-kit-v2.3.1.zip
Operator: agent (retrospective)
Date: 2026-05-13

Step 1: Clean unzip into /tmp
  Status: PASS

Step 2: verify-integrity.py
  Status: FAIL
  Evidence:
    "MODIFIED: local files do not match bundled manifest"
    "Missing:"
    "  - releases/v2.1.0/RELEASE-NOTES.md"
    "  - releases/v2.2.0/RELEASE-NOTES.md"
    "  - releases/v2.3.0/RELEASE-NOTES.md"
    Aggregate expected: b920eaf5...
    Aggregate actual:   fe0b0d67...
  Remediation: ZIP build script was deleting historical release notes
  before zipping. Fix: preserve releases/*/RELEASE-NOTES.md in the
  build directory; regenerate manifest from the preserved tree;
  rebuild ZIP from that tree.

---

DECISION: BLOCK

Failing step: 2 (verify-integrity).
Remediation: change ZIP build to retain releases/*/RELEASE-NOTES.md.
Estimated time to fix: 15 minutes.
Re-run steps 1-3 after remediation; if PASS, continue to step 4.
```

This retrospective example is included to make clear: the ship gate
would have caught v2.3.1's failure. The cost of running the gate (15
minutes) is much smaller than the cost of shipping broken and
remediating with v2.3.2 (an entire patch release).

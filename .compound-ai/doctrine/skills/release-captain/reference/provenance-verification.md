# Provenance Verification Reference
# Compound AI Operating Standards v3.0.10
# Source: github.com/cameronpsutcliff/compound-ai | License: Apache 2.0

Provenance verification is Step 3 of the ship gate. This reference covers
the procedure in detail and documents the standalone use case (verifying a
received copy without running a full release).

## When to use this reference

- During a release: `release-captain` Step 3 points here for the exact
  commands. The ship gate drives provenance verification; this reference
  provides the per-step detail.
- When a copy of the kit is received: run the offline check (Step 1) to
  confirm the received copy was not modified in transit.
- When adoption audits require origin confirmation: run the full check
  (Steps 1-3) and attach the report to the audit record.

## Offline integrity check

Verifies that local files match the bundled manifest. No network access.

```bash
cd <kit-root>
python3 reference-impl/scripts/verify-integrity.py
```

Expected output: `local files match bundled manifest`

Any other output is a failure. Do not proceed with a release until the
integrity check passes on a clean unzip (not the working copy).

## Origin verification (online)

Verifies the local copy against the canonical manifest published at the
kit's public URL.

```bash
python3 reference-impl/scripts/verify-origin.py --online
```

Expected output: one of:

| Result | Meaning |
|---|---|
| `VERIFIED` | Matches the canonical published manifest exactly. |
| `LOCAL-ONLY` | Integrity check passed; online check skipped (no network). |
| `MODIFIED` | Files differ from the canonical manifest. |
| `FORKED` | Origin headers indicate a fork, not the canonical source. |
| `UNKNOWN` | Could not retrieve or parse the canonical manifest. |

Only `VERIFIED` or `LOCAL-ONLY` unblocks Step 3 of the ship gate.
`MODIFIED` or `FORKED` blocks the release until the discrepancy is explained.

## Source materials

- `compound-ai.manifest.json` -- bundled manifest
- `compound-ai.sha256` -- SHA256 checksums for public-facing assets
- `reference-impl/scripts/verify-integrity.py` -- offline check
- `reference-impl/scripts/verify-origin.py` -- online check
- `NOTICE.md` -- attribution and license summary
- `CITATION.cff` -- machine-readable citation record

## Normal use

Normal session use must not require network access. The offline integrity
check is the default. The online origin check is release-gated and audit-gated
only.

## Origin note

Prior to v3.0.0 provenance verification was a standalone tier-1 skill
(`provenance-check`). It was merged into `release-captain` reference in the
v3.0.0 consolidation: provenance verification is a release-time procedure, not
an independent session-routable skill. The triggers ("verify origin",
"check provenance") now route to `release-captain`, which invokes this
reference at Step 3.

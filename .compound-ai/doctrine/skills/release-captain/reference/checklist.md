# release-captain: The Ten-Step Ship Gate

Every step has a pass/fail criterion. Any failure blocks the ship. No
overrides; remediation is the only path forward.

The full set takes 15-30 minutes per release. That cost is paid in
operator time. The cost of NOT running the gate is paid in shipped-and-
broken releases (see v2.3.1) and the corrective patches they require.

---

## Step 1: Clean unzip into /tmp

**Procedure.**
```bash
cd /tmp
rm -rf release-captain-test
unzip -q /path/to/candidate-release.zip -d release-captain-test
```

**Pass criterion.** The unzip command exits 0. The extracted directory
contains the kit at the top level (e.g. `release-captain-test/kit-v2/`).

**Why a clean unzip matters.** The local working copy has uncommitted
state, build artifacts, and editor side-files. Only a clean unzip
reflects what an external user will actually receive.

**Common failures.**
- ZIP corruption (rare)
- Top-level path name unexpected (manifest assumes `kit-v2/` prefix)
- Missing files because the build script deleted them before zipping

---

## Step 2: Run verify-integrity.py

**Procedure.**
```bash
cd /tmp/release-captain-test/kit-v2
python3 scripts/verify-integrity.py
```

**Pass criterion.** Returns one of:
- `LOCAL-ONLY: local files match bundled manifest`
- (no `MODIFIED` or `Missing:` lines)

**Why this matters.** This is the check that v2.3.1 failed. The
manifest declares which files should be present and their hashes; the
script confirms the bundle matches. If files are missing or hashes drift,
the package is not what its own manifest says it is.

**Common failures.**
- Files in manifest but missing from ZIP (build script deleted them)
- Files in ZIP but not in manifest (build script added them after the
  manifest was generated)
- Aggregate SHA mismatch (any per-file change without manifest regeneration)

**Remediation.** Regenerate manifest with `python3 scripts/build-manifest.py`,
rebuild ZIP from the source tree the manifest was built against, restart
step 1.

---

## Step 3: Run verify-origin.py --online

**Procedure.**
```bash
cd /tmp/release-captain-test/kit-v2
python3 scripts/verify-origin.py --online
```

**Pass criterion.** Returns `Status: VERIFIED`.

**Why this matters.** Confirms the bundled manifest matches the
canonical public manifest. If the public manifest is stale or the
bundle was built from a different source, this check catches it.

**Common failures.**
- `Status: FORKED` -- public manifest's version, origin_id, or aggregate_sha256
  differs from local
- `Status: LOCAL-ONLY` with online unavailable -- public manifest URL not
  reachable, indicating the public side did not get the manifest update

**Remediation.** Sync the public-side manifest to match the bundled
manifest. For versioned manifests, ensure BOTH `manifest.json` (latest)
and `releases/<version>/manifest.json` (immutable) are written.

---

## Step 4: Confirm manifest version matches page version

**Procedure.** Three values must agree:
1. ZIP's internal `compound-ai.manifest.json` `version` field
2. Public `public/compound-ai/manifest.json` `version` field
3. Website hero badge text (`vN.N.N · N skills · N shells`)

**Pass criterion.** All three values identical (string-equal).

**Why this matters.** Version mismatches confuse users about what they
downloaded vs. what the page advertises. A user comparing the
downloaded `verify-origin.py` output to the page version expects a
match.

**Common failures.** Hero badge hardcoded to a stale version; public
manifest forgotten in the version bump sweep.

**Remediation.** Update all three to the same value. Use a `KIT_VERSION`
constant in the page source so badges cannot drift.

---

## Step 5: Confirm SHA256SUMS covers current assets

**Procedure.**
```bash
cd public/compound-ai
ls -1 *.zip *.md _citations.md 2>/dev/null | sort > /tmp/assets.txt
awk '{print $2}' SHA256SUMS | sort > /tmp/shas.txt
diff /tmp/assets.txt /tmp/shas.txt
```

**Pass criterion.** `diff` returns empty (or only legacy assets in
SHA256SUMS that no longer exist on disk -- those are tolerated).

**Why this matters.** SHA256SUMS is the public verification artifact.
A file in the public directory without a SHA row cannot be verified.

**Common failures.** New markdown or new ZIP added to public without
appending to SHA256SUMS.

**Remediation.** Compute missing hashes with `shasum -a 256` and append
to SHA256SUMS.

---

## Step 6: Confirm field guide UI badge matches markdown version

**Procedure.**
1. Load `https://cameronsutcliff.com/compound-ai/field-guide` (or
   localhost for pre-deploy check)
2. Read the version badge in the page header
3. Confirm it matches the version in the loaded markdown filename
   (e.g. `Compound-AI-Operating-Standards-v2.3.2.md` → badge `v2.3.2`)

**Pass criterion.** Badge string equals filename version.

**Why this matters.** This is the exact failure v2.3.1 shipped with.
Reader was serving v2.3.1 markdown but the UI badge said `v1.0.0`. A
user has no way to know which is the truth.

**Common failures.** Badge hardcoded as a literal string rather than
derived from the URL constant.

**Remediation.** Bind the badge to the same `KIT_VERSION` constant the
URL is built from. One source of truth.

---

## Step 7: Confirm release-notes link points to the current release

**Procedure.**
1. Read the `releaseUrl` (or equivalent) constant in the page source
2. Fetch the URL with `curl -I` or visit in a browser
3. Confirm it returns 200 and the page shows the current release tag

**Pass criterion.** URL resolves; tag matches `KIT_VERSION`; page is
not the v1.0.0 release.

**Why this matters.** v2.3.1 shipped with `releaseUrl` pointing at the
v1.0.0 GitHub release. Users clicking "release notes" would land on
ancient content.

**Common failures.** Hardcoded URL; tag not yet pushed to GitHub.

**Remediation.** Tag the release on GitHub (`git tag vN.N.N; git push
--tags`), create the GitHub release with assets, bind the URL to
`KIT_VERSION`.

---

## Step 8: Confirm every public download returns 200

**Procedure.**
```bash
for asset in compound-ai-starter-kit-vN.N.N.zip Compound-AI-Operating-Standards-vN.N.N.md _citations.md SHA256SUMS manifest.json; do
  echo "Checking $asset..."
  curl -sI -o /dev/null -w "%{http_code} %{url_effective}\n" \
    https://cameronsutcliff.com/compound-ai/$asset
done
```

**Pass criterion.** Every URL returns 200. No 404s.

**Why this matters.** A successful Vercel deploy does not guarantee
every asset is served correctly. Cache invalidation, build artifacts,
and filename typos all produce 404s that block downloads.

**Common failures.** Vercel cache lag (wait 60s and re-check); filename
typo between source and link.

**Remediation.** Fix the filename or wait for cache; do not ship until
all return 200.

---

## Step 9: Confirm SKILL.md files within line-count budget

**Procedure.**
```bash
cd /tmp/release-captain-test/kit-v2
find . -name SKILL.md -exec wc -l {} \; | awk '$1 > 100'
```

**Pass criterion.** Empty output (no file over 100 lines).

**Why this matters.** The kit ships claiming `SKILL.md` files are
pointer files under 100 lines, target 80. v2.3.1 shipped with `request-router/
SKILL.md` at 231 lines (2.9x the ceiling). The kit must practice the
token optimization discipline it teaches.

**Common failures.** Adding new sections to `SKILL.md` instead of
pushing to `reference/`.

**Remediation.** Move prose into `reference/<name>.md` files; replace
in `SKILL.md` with one-line pointers.

---

## Step 10: Screenshot the website and field guide

**Procedure.**
1. Capture landing page hero (full viewport, browser at 1440x900 or
   similar): `public/compound-ai/screenshots/v2.3.2-landing.png`
2. Capture field guide reader (with TOC visible): `screenshots/v2.3.2-fieldguide.png`
3. Commit the screenshots alongside the release

**Pass criterion.** Both screenshots saved, version-stamped, committed.

**Why this matters.** Visual sanity catches what command-line checks
cannot: broken layout, color regressions, font issues, off-by-one
stat numbers in the hero, missing sections. Also serves as release
history.

**Common failures.** Screenshots taken at the wrong viewport; old
screenshots not replaced.

**Remediation.** Re-capture at the canonical viewport.

---

## Final decision

After all ten steps complete, the operator writes a one-line SHIP /
BLOCK decision based on the results. Format in
`reference/output-template.md`.

SHIP requires all ten passes. BLOCK on any failure; remediation
restarts at the failing step.

The discipline that makes this work: there is no "minor failure" exit.
Either every step passes or the ship is blocked. The cost of false
blocks is small (15 minutes of remediation). The cost of false ships
is large (shipping broken artifacts, requiring corrective patches,
eroding trust in the kit's own provenance claims).

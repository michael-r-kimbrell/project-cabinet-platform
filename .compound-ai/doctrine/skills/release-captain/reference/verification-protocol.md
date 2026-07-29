# release-captain: Verification Protocol

Exact commands and expected outputs per step. Run as a script or
manually; either way, the outputs go into the ship-gate report.

This protocol assumes the kit's standard file layout. Substitute paths
for projects that fork the structure.

---

## Pre-flight: gather context

```bash
# What version is shipping?
KIT_VERSION="v2.3.2"   # set to the actual candidate
RELEASE_DIR="/tmp/release-captain-test"
WEBSITE_PUBLIC="/path/to/your-website/public/compound-ai"
SOURCE_KIT="/tmp/compound-ai-v2"  # or wherever the kit source lives
```

---

## Step 1: Clean unzip

```bash
rm -rf "$RELEASE_DIR"
unzip -q "$WEBSITE_PUBLIC/compound-ai-starter-kit-${KIT_VERSION}.zip" -d "$RELEASE_DIR"
ls "$RELEASE_DIR"   # should show kit-v2/
```

**Capture for report:** unzip exit code; top-level directory name.

---

## Step 2: verify-integrity.py

```bash
cd "$RELEASE_DIR/kit-v2"
python3 scripts/verify-integrity.py
```

**Expected output:**
```
LOCAL-ONLY: local files match bundled manifest
Package: Compound AI Operating Standards
Version: 2.3.2
Origin:  https://cameronsutcliff.com/compound-ai
Files:   NNN
```

**Capture for report:** full stdout; exit code; file count.

**Fail if:** any line containing `MODIFIED`, `Missing:`, or `Extra:`.

---

## Step 3: verify-origin.py --online

```bash
cd "$RELEASE_DIR/kit-v2"
python3 scripts/verify-origin.py --online
```

**Expected output:**
```
LOCAL-ONLY: local files match bundled manifest
[...local integrity ok...]
Status: VERIFIED
Manifest URL: https://cameronsutcliff.com/compound-ai/manifest.json
```

**Capture for report:** Status line; manifest URL.

**Fail if:** `Status: FORKED` or `Status: LOCAL-ONLY` with online
unavailable (the latter means the public manifest is missing or the
domain is unreachable).

---

## Step 4: Three-version reconciliation

```bash
# Bundled manifest version

# Public manifest version
PUBLIC=$(jq -r .version "$WEBSITE_PUBLIC/manifest.json")

# Hero badge version from the built site (or local preview)
PAGE_BADGE=$(curl -s https://cameronsutcliff.com/compound-ai | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+ · [0-9]+ skills' | head -1 | awk '{print $1}')

echo "Bundled:    $BUNDLED"
echo "Public:     $PUBLIC"
echo "Page badge: $PAGE_BADGE"
[ "$BUNDLED" = "$PUBLIC" ] && [ "v$BUNDLED" = "$PAGE_BADGE" ] && echo "PASS" || echo "FAIL"
```

**Capture for report:** all three values; pass/fail.

---

## Step 5: SHA256SUMS coverage

```bash
cd "$WEBSITE_PUBLIC"
ls -1 *.zip *.md _citations.md 2>/dev/null | sort > /tmp/assets.txt
awk '{print $2}' SHA256SUMS | sort > /tmp/shas.txt
diff /tmp/assets.txt /tmp/shas.txt
```

**Pass if:** diff is empty (or only shows legacy SHA entries for
removed files, which is tolerated). Active assets without SHA rows are
a fail.

**Capture for report:** any missing-SHA assets.

---

## Step 6: Field guide badge ↔ markdown version

```bash
# Pull the loaded markdown URL from the deployed page
LOADED_MD=$(curl -s "https://cameronsutcliff.com/compound-ai/field-guide" \
  | grep -oE 'Compound-AI-Operating-Standards-v[0-9]+\.[0-9]+\.[0-9]+\.md' \
  | head -1)
MD_VERSION=$(echo "$LOADED_MD" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+')

# Read the badge from the rendered page (requires a headless browser or
# a deployed-build inspection; for local dev, read CompoundAIFieldGuide.tsx)
BADGE_VERSION=$(grep -oE 'KIT_VERSION\s*=\s*'\''v[0-9]+\.[0-9]+\.[0-9]+'\''' \
  /path/to/CompoundAIFieldGuide.tsx | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+')

echo "Markdown: $MD_VERSION"
echo "Badge:    $BADGE_VERSION"
[ "$MD_VERSION" = "$BADGE_VERSION" ] && echo "PASS" || echo "FAIL"
```

**Capture for report:** both values; pass/fail.

---

## Step 7: releaseUrl resolves to current tag

```bash
RELEASE_URL_VERSION=$(grep -oE 'releases/tag/v[0-9]+\.[0-9]+\.[0-9]+' \
  /path/to/CompoundAI.tsx | head -1 | sed 's|releases/tag/||')

echo "Release URL points at: $RELEASE_URL_VERSION"
[ "$RELEASE_URL_VERSION" = "$KIT_VERSION" ] && echo "URL matches kit version" || echo "URL MISMATCH"

# Verify the tag exists on GitHub
curl -sI "https://github.com/cameronpsutcliff/compound-ai/releases/tag/$KIT_VERSION" \
  | head -1
```

**Capture for report:** release URL version; HTTP response code.

**Fail if:** URL points at a different version, OR HTTP code is not 200.

---

## Step 8: Public downloads return 200

```bash
ASSETS=(
  "compound-ai-starter-kit-${KIT_VERSION}.zip"
  "Compound-AI-Operating-Standards-${KIT_VERSION}.md"
  "_citations.md"
  "SHA256SUMS"
  "manifest.json"
  "releases/${KIT_VERSION}/manifest.json"
)
FAILED=0
for asset in "${ASSETS[@]}"; do
  code=$(curl -sI -o /dev/null -w "%{http_code}" \
    "https://cameronsutcliff.com/compound-ai/$asset")
  echo "$code  $asset"
  [ "$code" = "200" ] || FAILED=$((FAILED + 1))
done
[ "$FAILED" = "0" ] && echo "PASS" || echo "FAIL: $FAILED 404s"
```

**Capture for report:** every asset's HTTP code.

---

## Step 9: SKILL.md line-count budget

```bash
cd "$RELEASE_DIR/kit-v2"
OVER_BUDGET=$(find . -name SKILL.md -exec wc -l {} \; | awk '$1 > 100')
if [ -z "$OVER_BUDGET" ]; then
  echo "PASS: all SKILL.md files under 100 lines"
else
  echo "FAIL: over-budget SKILL.md files:"
  echo "$OVER_BUDGET"
fi
```

**Capture for report:** any over-budget files with their line counts.

---

## Step 10: Screenshots

Screenshots are operator-driven. The verification protocol cannot
fully automate them without a headless browser. Minimum:

1. Open https://cameronsutcliff.com/compound-ai in a browser at 1440x900
2. Capture full-page screenshot, save to `screenshots/${KIT_VERSION}-landing.png`
3. Navigate to https://cameronsutcliff.com/compound-ai/field-guide
4. Capture full-page screenshot, save to `screenshots/${KIT_VERSION}-fieldguide.png`
5. Visual check: hero badge, stats, TOC visible, version badge correct

**Capture for report:** screenshot paths.

**Fail if:** any visual regression noticed during capture (off-by-one
stats, broken layout, version mismatch, missing sections).

---

## Composite output

After all ten steps run, the operator (or operating agent) writes the
ship-gate report using `output-template.md`. The report goes into the
release directory and into the commit message of the release.

---

## Common environment issues

- **jq not installed.** Use `python3 -c "import json; print(json.load(open('manifest.json'))['version'])"` as a substitute.
- **Public URL not yet propagated.** Vercel cache can lag ~30-90 seconds after a successful deploy. If step 3 or 8 fails immediately after a push, wait 90 seconds and re-run.
- **GitHub API rate limit.** Step 7's `curl` may hit rate limits in heavy session use. Use `gh release view $KIT_VERSION` as an authenticated alternative.

The protocol is designed to be runnable by either an operator or an
agent. An agent executing it should follow each step in order, capture
the output, and produce the structured report. Steps cannot be reordered;
the dependency graph is sequential.

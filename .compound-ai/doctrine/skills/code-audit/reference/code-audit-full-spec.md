# Skill: Code Audit

<!-- @origin: compound-ai-operating-standards v2.0.0 -->

## Trigger
User asks to: audit code, find problems, review project health, identify issues, check for bugs, system cleanup.

## What This Does
Systematic code and project structure audit across all initiatives. Surfaces structural problems, dead code, broken pipelines, missing dependencies, and skill opportunities  -  not nitpicky style issues.

## Audit Checklist

### 1. Dependency Audit
```bash
# Python (uv)
uv run pip check 2>&1 | head -20
# Check for missing modules referenced in code
grep -rn "import " src/ --include="*.py" | grep -v ".pyc" | awk '{print $2}' | sort -u
```

### 2. Dead Code / Unused Exports
- Files with no imports from other files
- Functions defined but never called
- Config keys defined but never read
```bash
grep -rn "def " src/ --include="*.py" | wc -l  # volume check
```


### 3. Environment / API Keys
```bash
# Check .env has required keys
grep -E "^[A-Z_]+=.+" .env | sed 's/=.*/=***/' | sort
# Verify no keys are expired (manual review)
```

### 4. Orphaned Scripts
```bash
# Scripts not referenced by any automation config or cron
ls scripts/*.sh scripts/*.py 2>/dev/null | while read f; do
  base=$(basename $f)
  if ! grep -r "$base" . --include="*.json" --include="*.yaml" --include="*.toml" >/dev/null 2>&1; then
    echo "ORPHANED: $f"
  fi
done
```

### 5. Test Coverage Gaps
```bash
# Files in src/ with no corresponding test
for f in $(find src/ -name "*.py" | grep -v __init__ | grep -v .pyc); do
  base=$(basename $f .py)
  if ! find tests/ -name "*${base}*" >/dev/null 2>&1; then
    echo "NO TESTS: $f"
  fi
done
```

### 6. Known Issue Tracking
Check each project's `CLAUDE.md` "Known Issues" section. For each:
- Is it still present in the code?
- Is there a GitHub issue?
- Has the impact grown?

## Output Template

After running the audit, produce:
```
## Code Audit Report  -  [DATE]

### Critical Issues (block production)
- [list]

### Moderate Issues (degrade quality)
- [list]

### Low Issues (cleanup / tech debt)
- [list]

### Orphaned Scripts
- [list]

### Skill Opportunities
- [list]

### Recommended Actions (priority order)
1. Action required: [X]
2. Claude can fix: [Y]
3. Cursor task: [Z]
```

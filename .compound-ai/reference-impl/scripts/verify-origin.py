#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path
from urllib.error import URLError
from urllib.request import urlopen


ROOT = Path(__file__).resolve().parents[2]
MANIFEST_PATH = ROOT / "compound-ai.manifest.json"
VERIFY_INTEGRITY = ROOT / "reference-impl" / "scripts" / "verify-integrity.py"
PROVENANCE_FILES = [
    ROOT / "NOTICE",
    ROOT / "NOTICE.md",
    ROOT / "CITATION.cff",
]


def load_local_manifest() -> dict:
    return json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))


def fetch_manifest(url: str) -> dict:
    with urlopen(url, timeout=8) as response:
        return json.loads(response.read().decode("utf-8"))


def local_integrity_ok() -> bool:
    result = subprocess.run(
        [sys.executable, str(VERIFY_INTEGRITY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    print(result.stdout.strip())
    if result.stderr.strip():
        print(result.stderr.strip(), file=sys.stderr)
    return result.returncode == 0


def local_provenance_problems(manifest: dict) -> list[str]:
    problems: list[str] = []
    required_manifest_fields = [
        "package_name",
        "origin_id",
        "authors",
        "canonical_url",
        "source_repo",
        "version",
        "license_docs",
        "license_code",
    ]
    for field in required_manifest_fields:
        if not manifest.get(field):
            problems.append(f"manifest missing {field}")

    missing_files = [path.name for path in PROVENANCE_FILES if not path.exists()]
    if missing_files:
        problems.append(f"missing provenance file(s): {', '.join(missing_files)}")

    texts = {
        path.name: path.read_text(encoding="utf-8", errors="replace")
        for path in PROVENANCE_FILES
        if path.exists()
    }
    combined = "\n".join(texts.values()).lower()
    required_terms = [
        "compound ai operating standards",
        "cameron sutcliff",
        "joshua sutcliff",
        "https://cameronsutcliff.com/compound-ai",
        "https://github.com/cameronpsutcliff/compound-ai",
        "cc by 4.0",
        "apache 2.0",
    ]
    for term in required_terms:
        if term not in combined:
            problems.append(f"provenance metadata missing {term}")

    canonical_url = str(manifest.get("canonical_url", "")).lower()
    source_repo = str(manifest.get("source_repo", "")).lower()
    if canonical_url and canonical_url not in combined:
        problems.append("canonical_url not reflected in provenance files")
    if source_repo and source_repo not in combined:
        problems.append("source_repo not reflected in provenance files")

    authors = manifest.get("authors", [])
    if isinstance(authors, list):
        for author in authors:
            if str(author).lower() not in combined:
                problems.append(f"author not reflected in provenance files: {author}")

    return problems


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify Compound AI Starter Kit origin.")
    parser.add_argument("--online", action="store_true", help="Compare against the canonical online manifest.")
    parser.add_argument("--manifest-url", help="Override canonical manifest URL.")
    args = parser.parse_args()

    if not MANIFEST_PATH.exists():
        print("UNKNOWN: local manifest missing")
        return 2

    try:
        local = load_local_manifest()
    except json.JSONDecodeError as exc:
        print(f"Status: UNKNOWN")
        print(f"Local manifest could not be parsed: {exc}")
        return 2

    integrity_result = subprocess.run(
        [sys.executable, str(VERIFY_INTEGRITY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    print(integrity_result.stdout.strip())
    if integrity_result.stderr.strip():
        print(integrity_result.stderr.strip(), file=sys.stderr)
    if integrity_result.returncode == 2:
        print("Status: UNKNOWN")
        return 2
    if integrity_result.returncode != 0:
        print("Status: MODIFIED")
        return 1

    provenance_problems = local_provenance_problems(local)
    if provenance_problems:
        print("Status: FORKED")
        print("Local provenance metadata differs from the canonical attribution contract:")
        for problem in provenance_problems:
            print(f"  - {problem}")
        return 1

    if not args.online:
        print("Status: LOCAL-ONLY")
        print("Online verification not requested.")
        return 0

    manifest_url = args.manifest_url
    if not manifest_url:
        canonical = str(local.get("canonical_url", "")).rstrip("/")
        manifest_url = f"{canonical}/manifest.json"

    try:
        remote = fetch_manifest(manifest_url)
    except (URLError, TimeoutError, json.JSONDecodeError) as exc:
        print(f"Status: LOCAL-ONLY")
        print(f"Online verification unavailable: {exc}")
        return 0

    comparable_fields = ["origin_id", "version", "aggregate_sha256"]
    mismatches = [
        field for field in comparable_fields
        if local.get(field) != remote.get(field)
    ]
    if mismatches:
        print("Status: FORKED")
        print("Remote manifest differs in:")
        for field in mismatches:
            print(f"  - {field}")
        return 1

    print("Status: VERIFIED")
    print(f"Manifest URL: {manifest_url}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

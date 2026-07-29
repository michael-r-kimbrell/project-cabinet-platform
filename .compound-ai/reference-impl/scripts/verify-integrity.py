#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
MANIFEST_PATH = ROOT / "compound-ai.manifest.json"
SHA_PATH = ROOT / "compound-ai.sha256"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def aggregate_hash(entries: list[dict[str, Any]]) -> str:
    digest = hashlib.sha256()
    for entry in entries:
        line = f"{entry['path']}:{entry['sha256']}:{entry['bytes']}\n"
        digest.update(line.encode("utf-8"))
    return digest.hexdigest()


def load_sha256_file() -> tuple[str, dict[str, str]]:
    aggregate = ""
    file_hashes: dict[str, str] = {}
    for line_number, raw_line in enumerate(SHA_PATH.read_text(encoding="utf-8").splitlines(), 1):
        line = raw_line.strip()
        if not line:
            continue
        parts = line.split(None, 1)
        if len(parts) != 2:
            raise ValueError(f"line {line_number} is not a checksum entry")
        checksum, rel = parts
        rel = rel.strip()
        if rel == "<aggregate>":
            aggregate = checksum
        else:
            file_hashes[rel] = checksum
    return aggregate, file_hashes


def main() -> int:
    if not MANIFEST_PATH.exists():
        print("UNKNOWN: compound-ai.manifest.json is missing")
        return 2
    if not SHA_PATH.exists():
        print("UNKNOWN: compound-ai.sha256 is missing")
        return 2

    try:
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
        sha_aggregate, sha_entries = load_sha256_file()
    except (json.JSONDecodeError, ValueError) as exc:
        print(f"UNKNOWN: provenance metadata could not be parsed: {exc}")
        return 2

    expected = manifest.get("files", [])
    if not expected:
        print("UNKNOWN: manifest has no file entries")
        return 2

    checked: list[dict[str, Any]] = []
    missing: list[str] = []
    modified: list[str] = []
    checksum_mismatches: list[str] = []

    for entry in expected:
        rel = entry["path"]
        path = ROOT / rel
        if not path.exists():
            missing.append(rel)
            continue
        actual_hash = sha256_file(path)
        actual_size = path.stat().st_size
        checked.append({"path": rel, "sha256": actual_hash, "bytes": actual_size})
        if actual_hash != entry["sha256"] or actual_size != entry["bytes"]:
            modified.append(rel)
        if sha_entries.get(rel) != entry["sha256"]:
            checksum_mismatches.append(rel)

    aggregate = aggregate_hash(checked)
    aggregate_expected = manifest.get("aggregate_sha256", "")
    aggregate_ok = (
        aggregate == aggregate_expected
        and sha_aggregate == aggregate_expected
        and len(checked) == len(expected)
    )

    extra_sha_entries = sorted(set(sha_entries) - {entry["path"] for entry in expected})

    if missing or modified or checksum_mismatches or extra_sha_entries or not aggregate_ok:
        print("MODIFIED: local files do not match bundled manifest")
        if missing:
            print("Missing:")
            for rel in missing:
                print(f"  - {rel}")
        if modified:
            print("Modified:")
            for rel in modified:
                print(f"  - {rel}")
        if checksum_mismatches:
            print("Checksum file mismatch:")
            for rel in checksum_mismatches:
                print(f"  - {rel}")
        if extra_sha_entries:
            print("Extra checksum entries:")
            for rel in extra_sha_entries:
                print(f"  - {rel}")
        if not aggregate_ok:
            print(f"Aggregate expected: {aggregate_expected}")
            print(f"Aggregate actual:   {aggregate}")
            print(f"SHA file aggregate: {sha_aggregate}")
        return 1

    print("LOCAL-ONLY: local files match bundled manifest")
    print(f"Package: {manifest.get('package_name')}")
    print(f"Version: {manifest.get('version')}")
    print(f"Origin:  {manifest.get('canonical_url')}")
    print(f"Files:   {len(checked)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

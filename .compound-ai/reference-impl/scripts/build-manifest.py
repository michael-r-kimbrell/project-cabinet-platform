#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
MANIFEST_PATH = ROOT / "compound-ai.manifest.json"
SHA_PATH = ROOT / "compound-ai.sha256"
EXCLUDED = {
    "compound-ai.manifest.json",
    "compound-ai.sha256",
}
EXCLUDED_NAMES = {
    ".DS_Store",
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def iter_files() -> list[Path]:
    files: list[Path] = []
    for path in ROOT.rglob("*"):
        if not path.is_file():
            continue
        rel = path.relative_to(ROOT).as_posix()
        if rel in EXCLUDED:
            continue
        if path.name in EXCLUDED_NAMES:
            continue
        if "/.git/" in f"/{rel}/":
            continue
        files.append(path)
    return sorted(files, key=lambda item: item.relative_to(ROOT).as_posix())


def aggregate_hash(entries: list[dict[str, Any]]) -> str:
    digest = hashlib.sha256()
    for entry in entries:
        line = f"{entry['path']}:{entry['sha256']}:{entry['bytes']}\n"
        digest.update(line.encode("utf-8"))
    return digest.hexdigest()


def main() -> int:
    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    entries: list[dict[str, Any]] = []
    for path in iter_files():
        rel = path.relative_to(ROOT).as_posix()
        entries.append(
            {
                "path": rel,
                "bytes": path.stat().st_size,
                "sha256": sha256_file(path),
            }
        )

    manifest["generated_at"] = datetime.now(timezone.utc).isoformat()
    manifest["files"] = entries
    manifest["aggregate_sha256"] = aggregate_hash(entries)
    MANIFEST_PATH.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")

    lines = [f"{manifest['aggregate_sha256']}  <aggregate>\n"]
    lines.extend(f"{entry['sha256']}  {entry['path']}\n" for entry in entries)
    SHA_PATH.write_text("".join(lines), encoding="utf-8")

    print(f"Wrote {MANIFEST_PATH}")
    print(f"Wrote {SHA_PATH}")
    print(f"Files indexed: {len(entries)}")
    print(f"Aggregate SHA256: {manifest['aggregate_sha256']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

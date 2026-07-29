"""
cache_key.py
Compound AI Operating Standards -- Reference Implementation
Source: cameronsutcliff.com/compound-ai
License: Apache 2.0
Version: 1.0.0

Cache key construction with prompt normalization.
Two patterns:
  1. Response cache: key on normalized prompt (for repeated LLM calls)
  2. Input-fingerprint cache: key on upstream inputs (for expensive synthesis)

Usage:
    from cache_key import make_response_cache_key, make_input_fingerprint

    # Response cache
    key = make_response_cache_key(model="primary", effort="max", prompt=prompt)

    # Input-fingerprint cache (for synthesis pipelines)
    fingerprint = make_input_fingerprint(
        summaries=article_summaries,
        context=vertical_context,
        prior_state=last_synthesis_output
    )
"""

from __future__ import annotations

import hashlib
import json
import re
from typing import Any, Callable


# ---------------------------------------------------------------------------
# Prompt normalization
# ---------------------------------------------------------------------------

_TIMESTAMP_PATTERNS = [
    # ISO 8601 dates and datetimes
    re.compile(r"\d{4}-\d{2}-\d{2}(?:T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z?)?"),
    # "Today is ...", "As of ...", "Current date: ..."
    re.compile(r"(?:today is|as of|current date[:\s]+)[^\n.]+", re.IGNORECASE),
    # Session IDs and run IDs
    re.compile(r"(?:session[_-]?id|run[_-]?id)[:\s]+\S+", re.IGNORECASE),
]

_WHITESPACE_PATTERN = re.compile(r"\s+")


def normalize_prompt(prompt: str) -> str:
    """
    Strip non-semantic tokens before hashing.
    Removes incidental dates, timestamps, session IDs, and normalizes whitespace.

    This lifts cache hit rates on prompts that share a logical response but
    differ only in envelope metadata (e.g., "Today is 2026-05-01" vs
    "Today is 2026-05-02" when the date is not semantically relevant).
    """
    text = prompt
    for pattern in _TIMESTAMP_PATTERNS:
        text = pattern.sub("", text)
    text = _WHITESPACE_PATTERN.sub(" ", text).strip()
    return text


# ---------------------------------------------------------------------------
# Response cache key
# ---------------------------------------------------------------------------

def make_response_cache_key(model: str, effort: str, prompt: str) -> str:
    """
    Construct a cache key for an LLM response.
    Key is sha256(model:effort:normalized_prompt).

    Args:
        model:  Model identifier (e.g., "primary", "fast", "local")
        effort: Effort level (e.g., "max", "low")
        prompt: The raw prompt string

    Returns:
        64-character hex string (sha256)
    """
    normalized = normalize_prompt(prompt)
    raw = f"{model}:{effort}:{normalized}"
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()


# ---------------------------------------------------------------------------
# Input-fingerprint cache key
# ---------------------------------------------------------------------------

def make_input_fingerprint(
    summaries: list[str],
    context: str,
    prior_state: str,
    extra: dict[str, Any] | None = None,
) -> str:
    """
    Construct a fingerprint for the upstream inputs to an expensive synthesis call.
    If the fingerprint matches a recent run, skip the LLM call and reuse the output.

    This is distinct from the response cache:
    - Response cache: keys on the prompt (what you asked)
    - Input fingerprint: keys on the source data (what produced the prompt)

    Args:
        summaries:   List of source document summaries
        context:     The vertical or domain context string
        prior_state: The last synthesis output (for evolution-based synthesis)
        extra:       Any additional deterministic inputs

    Returns:
        64-character hex string (sha256)
    """
    payload: dict[str, Any] = {
        "summaries": sorted(summaries),  # sort for determinism
        "context": context,
        "prior_state": prior_state,
    }
    if extra:
        payload["extra"] = extra

    serialized = json.dumps(payload, sort_keys=True, ensure_ascii=True)
    return hashlib.sha256(serialized.encode("utf-8")).hexdigest()


# ---------------------------------------------------------------------------
# Cache store (minimal reference implementation)
# ---------------------------------------------------------------------------

class ResponseCache:
    """
    Minimal LLM response cache backed by SQLite.
    Checks cache before every generate() call.
    """

    def __init__(self, db_path: str, ttl_hours: int = 24):
        import sqlite3
        self.db_path = db_path
        self.ttl_hours = ttl_hours
        self._conn = sqlite3.connect(db_path, timeout=30)
        self._conn.row_factory = sqlite3.Row
        self._ensure_table()

    def _ensure_table(self) -> None:
        self._conn.execute("""
            CREATE TABLE IF NOT EXISTS llm_cache (
                cache_key  TEXT PRIMARY KEY,
                model      TEXT NOT NULL,
                effort     TEXT NOT NULL,
                response   TEXT NOT NULL,
                created_at TEXT NOT NULL,
                expires_at TEXT NOT NULL
            )
        """)
        self._conn.commit()

    def get(self, model: str, effort: str, prompt: str) -> str | None:
        """Return cached response if it exists and has not expired."""
        from datetime import datetime, timezone
        key = make_response_cache_key(model, effort, prompt)
        now = datetime.now(timezone.utc).isoformat()
        row = self._conn.execute(
            "SELECT response FROM llm_cache WHERE cache_key = ? AND expires_at > ?",
            (key, now)
        ).fetchone()
        return row["response"] if row else None

    def put(self, model: str, effort: str, prompt: str, response: str) -> None:
        """Store a response in the cache."""
        from datetime import datetime, timedelta, timezone
        key = make_response_cache_key(model, effort, prompt)
        now = datetime.now(timezone.utc)
        expires = (now + timedelta(hours=self.ttl_hours)).isoformat()
        self._conn.execute(
            """INSERT OR REPLACE INTO llm_cache
               (cache_key, model, effort, response, created_at, expires_at)
               VALUES (?, ?, ?, ?, ?, ?)""",
            (key, model, effort, response, now.isoformat(), expires)
        )
        self._conn.commit()

    def cached_generate(
        self,
        model: str,
        effort: str,
        prompt: str,
        generate_fn: "Callable[[str, str, str], str]",
    ) -> str:
        """
        Check cache, call generate_fn on miss, store result.

        Args:
            model:       Model identifier
            effort:      Effort level
            prompt:      The prompt
            generate_fn: Callable(model, effort, prompt) -> response string
        """
        cached = self.get(model, effort, prompt)
        if cached is not None:
            return cached
        response = generate_fn(model, effort, prompt)
        self.put(model, effort, prompt, response)
        return response

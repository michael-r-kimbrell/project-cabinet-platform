"""
schema_validator.py
Compound AI Operating Standards -- Reference Implementation
Source: cameronsutcliff.com/compound-ai
License: Apache 2.0
Version: 1.0.0

Validates LLM responses against a JSON schema.
Includes one-shot auto-retry with error injection.

Usage:
    from schema_validator import generate_structured, SchemaValidationError

    SCHEMA = {
        "type": "object",
        "required": ["category", "confidence", "reason"],
        "properties": {
            "category":   {"type": "string"},
            "confidence": {"type": "number"},
            "reason":     {"type": "string"}
        }
    }

    result = generate_structured(prompt, SCHEMA, model="your-model")
"""

from __future__ import annotations

import json
import re
from typing import Any, Callable


class SchemaValidationError(Exception):
    pass


_TYPE_MAP: dict[str, type | tuple[type, ...]] = {
    "string":  str,
    "number":  (int, float),
    "integer": int,
    "boolean": bool,
    "array":   list,
    "object":  dict,
    "null":    type(None),
}


def _extract_json(raw: str) -> str:
    """Strip markdown code fences if present."""
    text = raw.strip()
    if text.startswith("```"):
        lines = text.split("\n")
        # Drop first line (```json or ```) and last line (```)
        text = "\n".join(lines[1:-1]).strip()
    return text


def validate_against_schema(raw: str, schema: dict[str, Any]) -> dict[str, Any]:
    """
    Parse raw LLM response and validate against a JSON schema subset.
    Supports: type, required, properties.
    Raises SchemaValidationError on failure.
    """
    try:
        data = json.loads(_extract_json(raw))
    except json.JSONDecodeError as e:
        raise SchemaValidationError(f"JSON parse failed: {e}") from e

    if not isinstance(data, dict):
        raise SchemaValidationError(f"Expected object, got {type(data).__name__}")

    errors: list[str] = []
    required = schema.get("required", [])
    properties = schema.get("properties", {})

    for field in required:
        if field not in data:
            errors.append(f"Missing required field: '{field}'")

    for field, field_schema in properties.items():
        if field not in data:
            continue
        expected_type = field_schema.get("type")
        if expected_type and expected_type in _TYPE_MAP:
            if not isinstance(data[field], _TYPE_MAP[expected_type]):
                actual = type(data[field]).__name__
                errors.append(
                    f"Field '{field}': expected {expected_type}, got {actual}"
                )

    if errors:
        raise SchemaValidationError(
            f"Schema validation failed ({len(errors)} error(s)): "
            + "; ".join(errors)
        )

    return data


def generate_structured(
    prompt: str,
    schema: dict[str, Any],
    generate_fn: Callable[[str], str],
    max_retries: int = 1,
) -> dict[str, Any]:
    """
    Call generate_fn(prompt), validate against schema.
    On failure, inject the error into the prompt and retry once.

    Args:
        prompt:      The prompt to send to the LLM.
        schema:      JSON schema dict (type, required, properties).
        generate_fn: Callable that takes a prompt string and returns a raw string.
        max_retries: Number of retry attempts on validation failure (default 1).

    Returns:
        Validated dict.

    Raises:
        SchemaValidationError: If validation fails after all retries.
    """
    raw = generate_fn(prompt)
    for attempt in range(max_retries + 1):
        try:
            return validate_against_schema(raw, schema)
        except SchemaValidationError as e:
            if attempt >= max_retries:
                raise
            retry_prompt = (
                f"{prompt}\n\n"
                f"Your previous response failed validation:\n{e}\n\n"
                f"Please correct the response and return valid JSON matching the schema."
            )
            raw = generate_fn(retry_prompt)

    # unreachable, but satisfies type checkers
    raise SchemaValidationError("Exhausted retries")

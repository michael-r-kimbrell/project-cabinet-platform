-- pipeline_runs.sql
-- Compound AI Operating Standards -- Reference Implementation
-- Source: cameronsutcliff.com/compound-ai
-- License: Apache 2.0
-- Version: 1.0.0
--
-- Observability schema for scheduled AI pipelines.
-- Compatible with SQLite (primary) and PostgreSQL (with minor type adjustments).
--
-- Usage:
--   sqlite3 your_project.db < pipeline_runs.sql
--
-- Then use the track_phase context manager (Python) or run_phase wrapper (bash)
-- to record phase health automatically.

-- Core observability table
CREATE TABLE IF NOT EXISTS pipeline_runs (
    run_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    pipeline_name TEXT    NOT NULL,
    phase         TEXT,
    status        TEXT    NOT NULL CHECK (status IN ('running', 'success', 'failed')),
    started_at    TEXT    NOT NULL,  -- ISO 8601 UTC
    ended_at      TEXT,              -- NULL while running
    error_message TEXT               -- NULL on success
);

CREATE INDEX IF NOT EXISTS idx_pipeline_runs_pipeline
    ON pipeline_runs (pipeline_name, started_at DESC);

CREATE INDEX IF NOT EXISTS idx_pipeline_runs_status
    ON pipeline_runs (status, started_at DESC);

-- LLM cache attribution sidecar
-- Tracks cache hits and misses per role/pipeline for efficiency measurement
CREATE TABLE IF NOT EXISTS llm_cache_attribution (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    cache_key    TEXT    NOT NULL,
    hit          INTEGER NOT NULL CHECK (hit IN (0, 1)),  -- 1=hit, 0=miss
    role         TEXT,    -- which agent or pipeline role
    pipeline     TEXT,    -- which pipeline
    prompt_bytes INTEGER, -- size of the prompt in bytes
    recorded_at  TEXT    NOT NULL  -- ISO 8601 UTC
);

CREATE INDEX IF NOT EXISTS idx_cache_attribution_role
    ON llm_cache_attribution (role, recorded_at DESC);

-- Quality ledger: append-only record of every narrative write decision
CREATE TABLE IF NOT EXISTS report_quality_ledger (
    ledger_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id TEXT    NOT NULL,  -- e.g. ticker, entity_id, report_id
    section    TEXT    NOT NULL,  -- which section of the report
    action     TEXT    NOT NULL CHECK (action IN ('written', 'preserved', 'aborted')),
    new_len    INTEGER,           -- length of the new content
    prior_len  INTEGER,           -- length of the prior content
    floor      INTEGER,           -- the richness floor that was applied
    created_at TEXT    NOT NULL   -- ISO 8601 UTC
);

CREATE INDEX IF NOT EXISTS idx_quality_ledger_subject
    ON report_quality_ledger (subject_id, section, created_at DESC);

-- Useful queries (run these to monitor pipeline health)

-- Recent phase failures
-- SELECT pipeline_name, phase, started_at, error_message
-- FROM pipeline_runs
-- WHERE status = 'failed'
--   AND started_at > datetime('now', '-24 hours')
-- ORDER BY started_at DESC;

-- Cache hit rate by role (last 7 days)
-- SELECT role,
--        SUM(hit) AS hits,
--        COUNT(*) - SUM(hit) AS misses,
--        ROUND(100.0 * SUM(hit) / COUNT(*), 1) AS hit_rate_pct,
--        SUM(CASE WHEN hit = 0 THEN prompt_bytes ELSE 0 END) AS tokens_spent_on_misses
-- FROM llm_cache_attribution
-- WHERE recorded_at > datetime('now', '-7 days')
-- GROUP BY role
-- ORDER BY tokens_spent_on_misses DESC;

-- Quality regressions (sections below 50% of historical max)
-- SELECT subject_id, section,
--        MAX(new_len) AS historical_max,
--        (SELECT new_len FROM report_quality_ledger r2
--         WHERE r2.subject_id = r.subject_id AND r2.section = r.section
--         ORDER BY created_at DESC LIMIT 1) AS current_len
-- FROM report_quality_ledger r
-- WHERE action = 'written'
-- GROUP BY subject_id, section
-- HAVING current_len < 0.5 * historical_max;

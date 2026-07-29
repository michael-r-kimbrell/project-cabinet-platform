#!/usr/bin/env node
"use strict";

/*
 * Local compatibility workflow. Its portable doctrine is folded (co-credited)
 * into the agent-panel-review skill as the phased-review mode.
 */

const { spawnSync } = require("node:child_process");
const path = require("node:path");

const runtimeDir = path.resolve(__dirname, "..");
const defaultGuard = path.join(runtimeDir, "hooks", "usage-guard.sh");
const guardPath = process.env.USAGE_GUARD || defaultGuard;

const config = {
  waves: Number.parseInt(process.env.PHASED_REVIEW_WAVES || "3", 10),
  workersPerWave: Number.parseInt(process.env.PHASED_REVIEW_WORKERS || "3", 10),
  blockPct: Number.parseInt(process.env.USAGE_GUARD_BLOCK_PCT || "90", 10),
};

function usagePct() {
  const result = spawnSync("bash", [guardPath, "pct"], {
    input: JSON.stringify({
      hook_event_name: "Workflow",
      tool_name: "Workflow",
      tool_input: { workflow: "phased-review" },
    }),
    encoding: "utf8",
  });

  if (result.status !== 0) {
    return -1;
  }

  const value = Number.parseInt(String(result.stdout).trim(), 10);
  return Number.isFinite(value) ? value : -1;
}

function plan() {
  const waves = [];
  for (let wave = 1; wave <= config.waves; wave += 1) {
    waves.push({
      wave,
      maxWorkers: config.workersPerWave,
      beforeWave: "check usage guard pct",
      afterWave: "summarize findings and decide continue, compress, or halt",
    });
  }
  return {
    status: "local-compat reference plan",
    guardPath,
    blockPct: config.blockPct,
    waves,
  };
}

function main() {
  if (process.argv.includes("--dry-run") || process.argv.includes("--plan")) {
    console.log(JSON.stringify(plan(), null, 2));
    return;
  }

  const pct = usagePct();
  if (pct >= config.blockPct) {
    console.log(JSON.stringify({
      decision: "halt",
      reason: "usage guard block threshold reached before phased review",
      usagePct: pct,
    }));
    return;
  }

  console.log(JSON.stringify({
    decision: "plan-only",
    reason: "local compatibility workflow; run with --dry-run to inspect the capped wave plan",
    usagePct: pct,
    plan: plan(),
  }, null, 2));
}

main();

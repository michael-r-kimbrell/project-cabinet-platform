# simulation-to-action-bridge: Protocol

This protocol operationalizes the conversion from analytical output to sequenced, ownable action. It is the last step in the reasoning pipeline, not the first. Every input to this protocol is a decision that has already been made -- not a question still being evaluated. If the decision is unresolved, route to `consequence-simulation` or `detached-judgment` first. Bridging to action on an unresolved question produces activity, not progress.

The structural discipline here is ownership and forcing functions. An action without a single named owner does not happen. An action without a definition of done cannot be verified. The protocol enforces both constraints as non-negotiable before generating output.

---

## Step-by-step procedure

1. **Confirm the decision is closed.** State the decision in one sentence in past tense: "We have decided to X." If the sentence cannot be written confidently, the decision is still open. Stop here. Do not proceed to action sequencing on an open question -- name what is still unresolved and return it upstream.

2. **Identify what changed.** Describe the new state the decision creates versus the prior state. This surfaces what actions are actually required. Decisions that do not change anything do not generate real actions; they generate theater. If you cannot describe what is different after the decision versus before, the decision may be nominal rather than real.

3. **Generate the raw action list.** List every action required to move from the prior state to the new state. Do not sequence or filter yet -- generate fully first. Include actions that seem obvious (they still need an owner and a date), and include actions that require external parties (they still need a named point of contact on the internal side).

4. **Assign a single owner to each action.** Every action must have one human owner: the person accountable for it completing, not the person who will do the work. Teams do not own actions. If no single owner can be named, escalate -- the action will not happen until ownership is resolved.

5. **Sequence by dependency.** Identify which actions cannot start until other actions complete. Draw explicit dependencies. Parallel actions are desirable -- flag them as such so the plan can compress timeline where possible. Circular dependencies are a plan failure: if A depends on B and B depends on A, the plan is broken and must be restructured.

6. **Apply OODA structure for ongoing situations.** If the decision is not a one-time execution but an ongoing operational posture (a response to a market change, a response to an adversary, a monitoring posture after a system change), frame the action plan as an OODA loop: what information triggers the next decision point, how that information is interpreted, what the standing decision rule is, and what the default action is when the rule fires.

7. **Set forcing functions.** For each action, define: due date and definition of done. "Work on X" is not an action. "Deliver [specific artifact] by [specific date], success means [measurable outcome]" is. If a due date cannot be set, name the specific condition that triggers the action rather than leaving it open-ended.

---

## Output template

```
SIMULATION-TO-ACTION BRIDGE
Decision (confirmed, past tense): [one sentence beginning "We have decided to..."]
Decision owner: [name / role -- the person accountable for the outcome, not just the first action]

State change:
  Prior state: [what was true before this decision]
  New state:   [what will be true when actions complete]

---

Action sequence:
  1. [action description]
     Owner: [name / role]
     Due: [date or trigger condition]
     Done when: [measurable outcome]
     Depends on: [action N, or "none"]

  2. [action description]
     Owner: [name / role]
     Due: [date or trigger condition]
     Done when: [measurable outcome]
     Depends on: [action N, or "none"]

  [continue for all actions]

---

Parallel tracks (can run simultaneously):
  Track A: [actions N, M, ...] -- no dependencies on each other
  Track B: [actions P, Q, ...] -- no dependencies on each other

---

OODA loop (if ongoing situation, otherwise omit):
  Observe:  [what information signals the next decision point]
  Orient:   [how to interpret that signal]
  Decide:   [the standing decision rule -- if [condition], then [option]]
  Act:      [the default action when the rule fires]
  Loop cadence: [how often the observation check runs]

---

Blocking dependencies: [list any actions that cannot start due to unresolved upstream issues, or "none"]

Open questions that could invalidate this plan: [list or "none"]
```

---

## Worked example

**Decision confirmed:** We have decided to implement a hard concurrency cap on the ingest pipeline, replacing the existing advisory rate limit.

**Decision owner:** Engineering manager, platform team.

**State change:**
- Prior state: ingest pipeline has an advisory rate limit that can be bypassed by concurrent batch jobs. Latency degrades under high concurrency.
- New state: hard cap enforced at the infrastructure layer; concurrent jobs queue rather than bypass the limit. Latency stays within SLA bounds under Monday's projected load.

**Action sequence:**

1. Write the concurrency cap configuration and deploy to staging.
   Owner: Senior platform engineer
   Due: Friday 5pm
   Done when: staging environment enforces the cap under simulated load matching Monday's projection
   Depends on: none

2. Run load test against staging with Monday's projected volume.
   Owner: QA lead
   Due: Friday 5pm (parallel with action 1 -- test begins when action 1 completes)
   Done when: latency P99 in staging stays below 500ms under projected load
   Depends on: action 1

3. Get sign-off from engineering manager before production deployment.
   Owner: Engineering manager
   Due: Friday 6pm
   Done when: written approval recorded in the deployment ticket
   Depends on: action 2

4. Deploy to production during the Saturday low-traffic window.
   Owner: On-call engineer
   Due: Saturday 2am-4am
   Done when: production error rate and latency return to baseline within 10 minutes of deployment
   Depends on: action 3

5. Monitor production for 24 hours post-deployment, escalate if latency exceeds 500ms P99.
   Owner: On-call engineer (primary), engineering manager (escalation)
   Due: through Sunday 2am
   Done when: 24 hours elapsed with no latency exceedance, incident closed
   Depends on: action 4

**Parallel tracks:**
- Track A: actions 1 and any partner notification (can begin simultaneously)
- Track B: actions 2 through 5 gate sequentially

**OODA loop (post-deployment monitoring posture):**
- Observe: P99 latency metric, polled every 5 minutes via monitoring dashboard
- Orient: if P99 exceeds 500ms for two consecutive checks, the cap is not functioning as expected
- Decide: if the 500ms threshold is breached twice, initiate rollback
- Act: rollback to previous rate-limit configuration, page engineering manager
- Loop cadence: 5-minute polling window, 24-hour duration

**Blocking dependencies:** None. All actions can begin on current information.

**Open questions that could invalidate this plan:** If Monday's actual traffic volume exceeds the projected volume by more than 30%, the load test results may not represent real conditions. The on-call engineer should monitor early Monday morning and be prepared to adjust the cap threshold.

---

## Anti-patterns

### Anti-pattern: Bridging on an unresolved decision

**Symptom.** The decision statement is written as "we should probably X" or "it seems like X is the right direction." The action plan is built on a tentative position.

**Fix.** The decision statement must be past tense and declarative: "We have decided to X." If it cannot be written that way, the decision is still open. Return to `consequence-simulation` or `detached-judgment`. An action plan built on "we should probably" produces a list of tasks that half the team will not prioritize because they did not feel the decision was final.

### Anti-pattern: Team ownership

**Symptom.** Action items are assigned to "the platform team," "the product organization," or "the working group." No individual is named.

**Fix.** Every action must have one named owner. "Platform team" is a group, not an owner. Groups diffuse accountability until no one acts. If the right owner is ambiguous, that ambiguity is a blocking dependency -- name it as such and resolve it before the action can be sequenced.

### Anti-pattern: "Done when" is activity-based, not outcome-based

**Symptom.** Actions are marked done when: "the team has reviewed the issue," "a meeting has been held," "the document has been updated."

**Fix.** Done conditions must describe a state of the world, not an activity performed. "Latency P99 stays below 500ms under load test" is an outcome. "The team has reviewed the load test results" is an activity. Activity-based done conditions cannot be verified and do not force the outcome the plan requires.

### Anti-pattern: OODA applied to one-time executions

**Symptom.** A simple, finite action plan (deploy a fix, send a communication, close a contract) includes an OODA loop structure that adds no value because the loop has no meaningful observe step after the action completes.

**Fix.** OODA structure applies to ongoing operational postures where the loop must run faster than an adversary or faster than a degrading situation. One-time executions do not benefit from OODA framing. Adding it to a finite plan adds length without adding information.

### Anti-pattern: Open questions treated as footnotes

**Symptom.** The "open questions" section at the bottom lists items that actually threaten the plan's validity, but they are written as low-priority afterthoughts. The plan proceeds as if they do not exist.

**Fix.** An open question that, if resolved adversely, would invalidate a core action is a blocking dependency, not a footnote. Classify it as such. Only questions with low impact on the plan's core logic belong in the open questions section.

---

## When to skip this skill

- The decision is trivial and the action is obvious. A single owner, a single action, and a clear deadline do not need a formal OODA bridge.
- The action plan is already fully specified in a prior artifact (a runbook, a deployment ticket, a project plan). Translating it into this format adds length without adding clarity.
- The situation is still being analyzed. This skill applies after the decision is made; running it on an open question produces a plan for a decision that has not been made.
- The action requires a creative or exploratory phase before it can be sequenced. If the first action is "figure out how to do this," the plan is not ready to bridge -- more analysis is needed first.

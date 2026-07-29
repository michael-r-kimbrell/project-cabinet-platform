# Skill: simulation-to-action-bridge
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Closes the loop from "what would happen" to "what should we do now." Converts
scenario outputs, consequence simulations, and analytical findings into
sequenced, ownable decisions with clear initiative assignment. Analysis that
does not route to action is overhead.

## Triggers
"what should we do about this", "turn this into a plan", "next steps",
"who does what", "OODA this", "make this actionable",
"I have the analysis -- now what", "convert findings to actions",
"action items", "decision forcing"

## How to apply

1. **Confirm the decision has been made.**
   This skill converts decisions into actions. If the underlying decision is
   still open, use `consequence-simulation` or `detached-judgment` first.
   Do not bridge to action on an unresolved question.

2. **Identify the decision owner.**
   Every action requires a single named owner. Teams do not own actions;
   people do. If no owner exists, the action will not happen.

3. **Sequence actions by dependency.**
   List what must happen before what. Parallel actions are fine; circular
   dependencies are not. Flag any action that cannot start until another
   completes.

4. **Apply the OODA structure where useful.**
   For ongoing situations: Observe (what information is needed), Orient
   (what does it mean), Decide (what is the call), Act (what happens next).
   OODA is most useful for fast-moving or adversarial situations where the
   loop needs to run faster than the opposing force.

5. **Set forcing functions.**
   Every action should have a date and a definition of done. "Work on X" is
   not an action. "Deliver X by [date], success = [measurable outcome]" is.

## Techniques
- Action-oriented recommendation framing
- OODA loop implementation
- Decision forcing
- Initiative and owner assignment

## Output format
```
SIMULATION-TO-ACTION BRIDGE
Decision confirmed: [statement]
Decision owner: [name / role]

Action sequence:
  1. [action] -- owner: [name], due: [date], done when: [measurable outcome]
  2. [action] -- owner: [name], due: [date], done when: [measurable outcome]
     depends on: [action N]
  ...

OODA loop (if applicable):
  Observe: [what information triggers the next decision point]
  Orient:  [how to interpret that information]
  Decide:  [the standing decision rule]
  Act:     [default action if rule fires]

Blocking dependencies: [list or "none"]
Open questions that could invalidate this plan: [list or "none"]
```

## Source references
- Field Guide Chapter 5: Decision Framework Evaluation
- Field Guide Chapter 20: Execution and Orchestration
- `templates/model-routing.md` -- routing table for action dispatch
- `AGENT.md` -- model routing table (implementation-tier sufficient for output)

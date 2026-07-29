# Course Shell

Part of the Compound AI Operating Standards v3.0.10 kit.

## What this produces

A single-file, self-contained learning module with sequential lessons, prerequisite gating, inline knowledge checks, per-lesson progress, an overall course progress bar, and resume-where-you-left-off behavior backed by localStorage. Drop in your lesson content and you have a working micro-course that runs offline in any modern browser.

## Capabilities

- **Sequential lesson flow:** four lessons by default, navigable via the flow bar, keyboard, or in-lesson buttons.
- **Prerequisite chaining:** each lesson is locked until the prior lesson is marked complete. Locked steps in the flow bar are visually dimmed and reject clicks.
- **Per-lesson progress tracking:** each lesson has its own progress bar reflecting visit + quiz answers + completion. Stored in localStorage so reloads preserve state.
- **Knowledge check quizzes:** multi-choice inline quizzes with instant feedback. Correct answers persist; wrong answers are recoverable.
- **Overall course progress bar:** 3px gradient strip directly under the top nav showing percent of lessons completed.
- **"Mark complete" button:** per lesson; clicking it unlocks the next lesson and locks the button into a "Completed" state.
- **Resume where you left off:** on page load, the shell jumps to the most recent unlocked lesson the learner was on.
- **Theme toggle:** light/dark via `data-theme` on `<html>`.
- **Reset button:** clears all stored progress, with a confirm prompt, and reloads.
- **Keyboard nav:** `ArrowRight` (if unlocked), `ArrowLeft`, `T` for theme.

## How to use it

1. Open `index.html` in any modern browser.
2. Each `<article class="lesson" data-lesson="N">` is one lesson. The order in the DOM is the order learners encounter.
3. Set the `data-title` attribute to control the label in the flow bar.
4. Quizzes: copy the `.kcheck` block, give it a unique `data-quiz="id"`, and mark the correct option with `data-correct="true"`. State is keyed by the quiz id.
5. Need more lessons? Add another `<article class="lesson" data-lesson="N">`. The JS reads them dynamically; nothing else to change. (You may want to bump the storage version key if you ship a major content change so old learners get a clean reset.)
6. Deploy as static HTML. localStorage scopes to origin, so each deployment URL has independent progress.

## Tier 2 skills that pair well

- **`shape`** to plan the lesson arc and acceptance criteria before drafting content.
- **`build`** to populate this shell with generated lesson text.
- **`cross-domain-translation`** for explaining technical concepts in lay terms inside lesson bodies.
- **`critique`** to evaluate quiz quality (good distractors, no give-away language).
- **`clarify`** to tighten quiz prompts and feedback strings.

## What this is NOT

- Not an LMS. No user accounts, no grading, no SCORM, no certificate generation, no analytics. Progress is local to the browser only.
- Not Articulate, Captivate, or Storyline. No drag-and-drop authoring, no SCORM/xAPI export, no branched scenarios.
- Not Khan Academy or Udemy. No video player, no transcripts, no community.
- Not multi-user. Two learners on the same machine share the same localStorage.
- Not a quiz engine. Knowledge checks are intentionally simple; for high-stakes assessment, plug in a real tool.

---
name: resolve-bug
description: Triage a WizShop storefront bug from a Jira ticket. Classifies it as an implementation bug (Elementor setup), an FE code bug (storefront-wp) or a BE bug (Ultron), proposes the smallest fix, can apply and browser-test the fix itself (reverting it if it fails), and after the fix is confirmed offers to post a short RCA + solution comment on Jira. Use when the user gives a Jira key or URL, or says "resolve/triage/debug this bug".
argument-hint: <JIRA-KEY or Jira URL>
---

# Resolve bug: $ARGUMENTS

Work through the phases in order. Each phase has an **exit gate**. Don't move on until it's met. Load a reference file only when a phase points to it. `references/…` paths are inside `.claude/skills/resolve-bug/`. `tools/` and `knowledge/` are at the workspace root.

Be economical with tokens. Prefer the tool scripts, `grep`, `jq` and subagents over reading whole files. Never read a `manifest.json` directly, because the root one is 4 MB.

Keep a short **Attempts list** for the whole run: one line per fix tried and why it failed. Never suggest an attempt that's already on it.

**Auto mode:** if `$ARGUMENTS` contains `--auto`, read the **Auto mode** section at the end of this file before Phase 0. Its rules override every gate below. `/resolve-batch` uses it.

## Phase 0: Known bug?
`grep -i` `knowledge/bug-log.md` for the widget name, the symptom keywords and the tenant. If something matches, use that entry as your first hypothesis and skip any fix its `tried` field says failed. Verify the match. Don't apply it blindly.

## Phase 1: Read the ticket
Fetch the issue with the Atlassian MCP `getJiraIssue` tool. Get the `cloudId` from `getAccessibleAtlassianResources` once and reuse it. Pass `fields: ["summary","description","environment","attachment","comment","labels","components","priority","status"]` and `responseContentFormat: "markdown"`. Ticket comments often contain the repro URL.

Pull out the following and write it as a 5-line **Bug card**:
- **Tenant / URL**, **page**, **environment** (prod/staging)
- **Expected vs actual**
- **Repro steps**, **device/viewport**, **logged-in state / user role**
- Attachments: screenshots and videos. Read the image attachments, because they often show the exact element.

**Gate:** If the URL, the expected behaviour or the repro is missing, ask the user. Use `AskUserQuestion` and put up to 3 questions in one call.

## Phase 2: Reproduce in the browser
Follow `references/browser-checks.md`. Use Claude in Chrome, the user's browser where they're signed in to storefronts. Collect:
1. Whether it reproduces (yes/no) and what you see
2. The affected element's **widget_type**, element id, and `doc` + `chain` (container ids). Keep these for the Jira click path.
3. Console errors and failed or odd network calls (API path, status, the relevant part of the payload)

**Gate:** You have either reproduced it or asked the user for what blocks reproduction (credentials, data state, a URL). Never enter passwords yourself. Ask the user to sign in.

## Phase 3: Classify
Read `references/classify.md` and pick exactly one: **IMPLEMENTATION**, **FE-CODE** or **BE**, with one line of evidence. If two are equally likely, run the cheapest test that separates them. Don't ask the user to pick.

## Phase 4: Find the fix (only the branch you chose)
- **IMPLEMENTATION**: follow `references/implementation-fix.md`. Work down the ladder: widget control, then Site/Kit settings, then the widget's Custom CSS, then site Custom CSS, then custom JS. Stop at the first rung that fixes it.
- **FE-CODE**: follow `references/fe-code-fix.md`. Give the `fe-code-investigator` subagent the Bug card + browser evidence + the Attempts list. Check that its root cause matches the browser evidence before accepting it.
- **BE**: follow `references/be-identify.md`. Write its output block (evidence, API, payload, code excerpt, suggested fix), then **go straight to Phase 7**, because BE fixes are never applied or tested here.

**Gate:** You can state the root cause in one sentence, with evidence.

## Phase 5: Suggest the solution, then ask who applies it
**First** write this block as normal reply text. Never put it only inside the question dialog, and never skip it.

```
**Type:** IMPLEMENTATION | FE-CODE

**Root cause:** <2–4 sentences: where (site, page/doc id, element id or file:line), what's wrong, why it causes the symptom, and the evidence (e.g. rule source, or same widget fine on another tenant)>

**Fix:**
1. <where to go>
2. <exact change: control/setting › old → new value, or the minimal diff. Say exactly where the setting lives (a widget, or the page/template/popup's own Settings); the Jira comment copies it>
3. <publish / cache step, if needed>

**Verify:** <page + device>:
- <expected result 1>
- <expected result 2>

<1–2 sentences: how you pre-tested it (e.g. injected live at 450px), and any ticket symptom you couldn't reproduce that the user should check>
```

Then call `AskUserQuestion` with these options:
- **"Apply it for me"**: you apply exactly this fix and test it (Phase 6A).
- **"I'll apply it"**: the user applies it and reports back (Phase 6B).

Choosing "Apply it for me" approves **only the change shown above**, including publishing it. Anything beyond that needs a new yes.

## Phase 6A: Agent applies and tests
Follow `references/apply-fix.md`. The steps are:
1. Open the editor (Elementor) or the file (code). If you can't open the Elementor editor yourself, ask the user for the editor URL and to sign in if needed.
2. **Record the original value** of everything you'll change (the revert snapshot).
3. Make **only** the suggested change. Publish, or save the file.
4. Wait 5 s, then load the page with a cache-busting param and re-run the Phase 2 checks on the ticket's device(s).
5. Decide:
   - **Pass**: tell the user what changed and where, and ask them to confirm on their side. Go to Phase 7.
   - **Fail**: **stop.** Tell the user the fix failed and why, in one line with evidence. Revert to the snapshot and publish. If you can't revert, give the user the exact original values and ask them to revert. Confirm the page is back to its pre-fix state. Add the attempt to the Attempts list and go back to **Phase 3** with the new evidence.

## Phase 6B: User applies
Ask the user to try the fix and report back with `AskUserQuestion`: "Worked", "Didn't work", "Partly". If it didn't fully work, get what they saw, ask them to revert, add the attempt to the Attempts list, and go back to Phase 3.

**Loop limit:** after **3 failed attempts**, stop looking for more fixes. Summarise the Attempts list and what's still unexplained, and ask the user how to proceed (more info, escalate, or reclassify).

## Phase 7: Close the loop
Run this when the fix is confirmed working, or when a BE bug has been identified.
1. **Jira:** follow `references/jira-comment.md`. Show the comment and ask "Post this comment to <KEY>? (yes/no)" as plain text. No dialog. Open the browser only if an id for the click path is missing.
2. **Log:** add a line to `knowledge/bug-log.md` **only if the bug was critical** (the rules are at the top of that file). Routine implementation fixes are not logged.

## Auto mode (`--auto`)
Arguments: `<KEY> --auto --out <result file path>`. This is a ticket in a `/resolve-batch` run, and nobody is watching. **Never ask anything**: no `AskUserQuestion`, no questions in plain text, and never stop to wait for a reply. Running the batch approves one thing in advance: **applying and publishing IMPLEMENTATION fixes in Elementor.** Nothing else.

These rules override the phases above:
- **Any doubt means skip.** If a gate would make you ask the user, stop and write the result with status `SKIPPED`, including the exact question you would have asked. Examples: the URL, expected behaviour or repro is missing; it won't reproduce; a sign-in or credentials are needed; the Elementor editor won't open; two types are equally likely and the cheap test doesn't separate them; you're not sure which element or value to change; the fix needs something outside the ladder. Never type credentials.
- **Phase 3 → FE-CODE or BE:** don't run Phase 4 and don't spawn investigators. Write status `CODE-BUG` with the classification evidence (console error, API path + status + key fields, selector or file if obvious). Never touch `storefront-wp/` or `temp/`.
- **Phase 5: announce before you apply.** Before changing anything, post this block in chat and copy it into the result file. Then skip the question and go straight to Phase 6A **section A (Elementor) only**. Never run section B (code).
  ```
  ### <KEY>: about to apply a fix
  **Bug:** <what the user sees, 1 sentence: page, device, symptom>
  **RCA:** <why it happens, 1–3 sentences: site, doc id, element id, the setting or rule at fault, and the evidence>
  **Fix plan (step by step):**
  1. Open <editor URL / document title #id>
  2. Select <widget panel title (element id)> → <tab> → <section>
  3. Change <control/key>: <old value> → <new value>  (one step per change, CSS shown in full)
  4. Publish, then reload <page> with ?nocache=… on <devices>
  5. Check: <what must look/behave right to call it fixed>
  **Revert plan:** <the original values to restore if the check fails>
  ```
  If a later attempt (after a failed one) uses a different fix, post the block again for that attempt.
- **Phase 6A:** if the blast radius check fires (template, popup or Global widget), go ahead, but put it under **Flags** in the result. **Pass** → status `FIXED`. Don't ask anyone to confirm. **Fail** → revert as usual and go back to Phase 3. After 3 failed attempts → status `FAILED`. If you couldn't confirm a revert, the first line of the result body must be `**REVERT NEEDED**`, followed by the snapshot.
- **Phase 7:** write the Jira comment (format: `references/jira-comment.md`) into the result file and into chat. **Never post it** and leave out the "Post this comment?" line. Never comment on, transition or edit any Jira issue. The bug-log rule still applies.
- **Finish:** write the result file to the `--out` path (template below). End the turn with this final status block, always, whatever the outcome:
  ```
  ### <KEY>: <✅ FIXED | ⏭️ SKIPPED | 🧩 CODE-BUG | ❌ FAILED>
  **Bug:** <1 sentence>
  **RCA:** <1–2 sentences, or "not reached" if skipped early>
  **What was done:** <the changes applied and verified, or "nothing changed">
  **Why it stopped:** <only for SKIPPED / CODE-BUG / FAILED: the reason, the blocking question, or the attempts tried>
  **Verified on:** <page + devices, or "-">
  **Flags:** <anything to check, or "-">
  ```
  For FIXED or CODE-BUG, put the Jira comment after the block in a ````markdown block (four backticks).

Result file template (keep the four header lines exactly, because `/resolve-batch` parses them):
````markdown
key: <KEY>
status: FIXED | SKIPPED | CODE-BUG | FAILED
type: IMPLEMENTATION | FE-CODE | BE | -
summary: <one line: what was done, or why it stopped>

## Bug card
<the 5-line bug card>

## Root cause
<1–3 sentences with evidence, or "-">

## Fix plan
<the step-by-step plan posted before applying (every attempt, numbered), or "-">

## Changes made
<document › element › key: old → new (the revert snapshot), or "none">

## Verified
<page + devices + what you checked, or "-">

## Flags
<blast radius, symptoms you couldn't reproduce, anything the user should look at, or "-">

## Question for the user
<only for SKIPPED: the exact question that blocks it>

## Jira comment
<only for FIXED or CODE-BUG: the comment text, ready to paste>
````

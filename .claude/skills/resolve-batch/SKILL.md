---
name: resolve-batch
description: Batch-resolve the "To Do" subtasks of a Jira parent ticket that are assigned to a given person. Runs /resolve-bug in auto mode on each subtask, one at a time, each in its own fresh session. IMPLEMENTATION bugs get fixed, tested and verified without asking. Code bugs and anything unclear are noted and skipped. Jira comments are printed in chat and never posted. Ends with a summary table in this parent chat. Use when the user says "/resolve-batch <parent key> <assignee name>" or asks to run resolve-bug over all subtasks of a ticket.
argument-hint: <parent JIRA key or URL> <assignee full name>
---

# Resolve batch: $ARGUMENTS

You are the **parent chat**. You never investigate a bug yourself. You list the subtasks, start one fresh session per subtask, collect the result files and report.

## Step 1: Parse the input
- The first token is the parent: a Jira key (`WZS-4400`) or a URL. Take the key from the URL.
- Everything after it is the **assignee name** (e.g. `Rohan Maiti`). The Claude account running this is *not* that person, so never use `currentUser()`.
- If either is missing, ask once with `AskUserQuestion`. This is the only point in the run where you may ask anything.

## Step 2: Find the subtasks
1. Get the `cloudId` with `getAccessibleAtlassianResources`.
2. Get the assignee's accountId with `lookupJiraAccountId` (search by the name). If there are 0 matches, or more than one plausible match, ask the user which one (show name + email). Don't guess.
3. Run `searchJiraIssuesUsingJql`:
   `parent = <KEY> AND assignee = "<accountId>" AND status = "To Do" ORDER BY priority DESC, key ASC`
   If it returns nothing, retry once with `"Epic Link" = <KEY>` instead of `parent = <KEY>` (older-style epics). Ask for `fields: ["summary","status","priority"]`.
4. If there are still none, say so and stop.

## Step 3: Set up the run
- Run folder: `knowledge/batch-runs/<PARENT>_<YYYY-MM-DD>/`. Create it with `mkdir -p`.
- **Resume:** if the folder already has `<KEY>.md` files, those subtasks are done. Skip them.
- Create the lock file `knowledge/batch-runs/.batch-active` (`touch`). A hook (`tools/batch-guard.sh`) blocks every Jira write while it exists.
- Print the queue as a table: `# | Key | Summary | Priority`, plus "N to do, M already done". Don't wait for confirmation. Start straight away.

## Step 4: One session per subtask, one at a time
The subtasks share one Chrome browser and the same Elementor logins, so **never run two at once**.

For the next subtask without a result file, call `mcp__ccd_session__start_session` with:
- `initiation: "user_asked"` (the user asked for one session per subtask by running this skill), `context: "fresh"`, `use_worktree: false`, `wake_when_done: true`
- `title`: `<KEY>: <summary>` (cut to 60 chars), `name`: the key in lowercase (e.g. `wzs-4501`)
- `prompt`: `Run the resolve-bug skill with args: <KEY> --auto --out knowledge/batch-runs/<PARENT>_<date>/<KEY>.md`. Then: `Follow its Auto mode section exactly. Before applying any fix, post the bug, the RCA and the step-by-step fix plan in chat. End with the final status block (FIXED / SKIPPED / CODE-BUG / FAILED). Never ask the user anything. When in doubt, write the result as SKIPPED and end. Never post or change anything in Jira. Use a new Chrome tab for this ticket and close it when you're done.`
- `background`: `Part of a /resolve-batch run over the To Do subtasks of <PARENT> assigned to <name>. Subtasks run one at a time in separate sessions, and the parent chat builds the summary from the result files. Implementation fixes are pre-approved to apply and publish. Code bugs are only noted.`

Write one bold line with the title and "(n/N)" right before the call, link the session as `[<title>](#<local id>)` once it has started, and **end your turn**. Don't poll. The app wakes you when the session ends its turn.

## Step 5: When you're woken (side-session event or the user says "continue")
1. Check `mcp__ccd_session_mgmt__list_sessions` with `{"linked": true}`. If a subtask session is still working, end the turn and wait.
2. Read the finished subtask's result file. Use only its four header lines plus `## Root cause` and `## Flags` here, to keep this chat small.
   - **No result file:** the session stopped early (it asked a question, failed, or the user stopped it). Write `<KEY>.md` yourself with `status: SKIPPED`, `summary: session ended without a result; open it to see why`.
   - A body starting with `**REVERT NEEDED**`: tell the user at once, in bold, then carry on.
3. Print a short status for the ticket:
   ```
   **<KEY> → <✅ FIXED | ⏭️ SKIPPED | 🧩 CODE-BUG | ❌ FAILED>** (n/N)
   RCA: <the root cause in 1 sentence, or "not reached">
   Result: <summary line>
   ```
4. Start the next subtask (Step 4). When none are left, go to Step 6.

If the app refuses to start a session, or you stop being woken (after many automatic wake-ups in a row, the app waits for the user), print `Paused after <KEY>. Type "continue" to resume.` On "continue", start again at Step 5. The result files show what is already done.

## Step 6: Summary
1. Delete the lock file `knowledge/batch-runs/.batch-active`.
2. Write `knowledge/batch-runs/<PARENT>_<date>/summary.md` and print the same thing in chat:

**Summary table**: `Key | Summary | Status | Type | RCA (1 line) | What was done / why it stopped | Session`. Each subtask chat has the full RCA and its step-by-step fix plan. Order the rows FIXED, CODE-BUG, SKIPPED, FAILED. The Session column is the session link.

Then counts: `FIXED x · CODE-BUG y · SKIPPED z · FAILED w`.

**REVERT NEEDED** (if any): key + the snapshot to restore.

**Jira comments to post by hand**: for each FIXED (then CODE-BUG) ticket, a heading with the key and its `## Jira comment` section inside a ````markdown block (four backticks). Remind the user to verify each fix on their side before posting.

**Needs your input**: for each SKIPPED ticket, the key and its `## Question for the user`. Answering these and running `/resolve-bug <KEY>` handles them one by one.

**Flags**: any non-empty `## Flags` (e.g. a fix changed a header template that every page uses).

Never post to Jira and never transition tickets from this skill, even if asked partway through. The user does that by hand after checking.

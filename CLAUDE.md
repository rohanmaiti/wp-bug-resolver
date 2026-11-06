# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose of this workspace

This is a **bug-resolver workspace** for WizCommerce's B2B storefront platform (WizShop). It takes a Jira ticket, works out why the bug happens, and suggests the smallest fix. Start the workflow with:

```
/resolve-bug <JIRA-KEY or URL>
```

To work through every "To Do" subtask of a parent ticket for one assignee (one fresh session per subtask, summary table at the end), run `/resolve-batch <parent KEY or URL> <assignee name>`. See `.claude/skills/resolve-batch/SKILL.md`.

The workflow is in `.claude/skills/resolve-bug/SKILL.md`. Its reference files load only for the step that needs them, so don't read them ahead of time.

## The two repos (separate git repos, not one monorepo)

| Dir | What | Prod branch |
|---|---|---|
| `storefront-wp/` | WordPress + Elementor storefront. Our own Elementor widgets live in `wp-content/mu-plugins/widgets/` (v1) and `widgets/v2/` (v2, built from shared atoms in `atoms/`). WordPress only renders pages. Auth, data and business logic come from the backend API. It has its own `CLAUDE.md` with the full rules. | `master` |
| `temp/` | "Ultron" backend: a FastAPI monolith (`api/<feature>/vN/`). Storefront pages call it directly from the browser with `WizApi.call()` (paths in `storefront-wp/wp-content/mu-plugins/helpers/wiz-api-endpoints.js`) or through PHP via `/wiz-ajax`. | `main` |

The same storefront code serves many tenant sites. Each tenant's pages are built in Elementor by the implementation team. So a bug on one tenant's site is usually how that site was **built** (an implementation bug), not a bug in the code.

## Hard rules for the agent

- **Never edit code in either repo during triage.** Propose a minimal diff. Apply it only if the user asks.
- **Never post to Jira without explicit user approval** of the exact comment text, and only after the user confirms the fix worked.
- **Ask instead of guessing.** Questions might be: which tenant or URL, logged in or not, which device or viewport, or whether it reproduces on another tenant.
- Investigate code at the **prod branch** (use `git -C <repo> show <branch>:<path>` and don't check out branches) unless the ticket names another environment.
- For backend bugs, give the evidence (API, payload, response), the faulty code and a **suggested** fix. Never apply or test it; it goes to the backend team.
- When the code needs a deep search, hand it to the `fe-code-investigator` / `be-code-investigator` subagents so only their conclusion comes back.
- **Batch mode exception** (`/resolve-batch`, which runs `/resolve-bug <KEY> --auto`): starting the batch pre-approves applying and publishing **IMPLEMENTATION (Elementor) fixes only**. In batch mode, don't ask: skip the ticket and record the question. Code is never edited and Jira is never written to. A hook (`tools/batch-guard.sh`) blocks Jira writes while `knowledge/batch-runs/.batch-active` exists.

## Tools in this workspace

- `tools/widget-controls.sh <widget_type> [keyword]` lists a widget's Elementor controls (key, label, CSS selector) from the manifests, or from the PHP source for v2 widgets. Use it to answer "can a widget control fix this?" without reading a 4 MB manifest.
- `tools/widget-locate.sh <widget_type|css-class|text>` finds the source file of a widget.
- `knowledge/bug-log.md` holds past resolved bugs. Grep it first, because a repeat bug is the cheapest kind to solve.

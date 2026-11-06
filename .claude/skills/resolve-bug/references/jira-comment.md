# Jira comment

## Format
Three sections with **one blank line between them**. Use simple English: short sentences, everyday words, no jargon. Don't add a Type line.

```
**RCA:** <what was wrong and why, 1 sentence>

**Fix applied:** <location> → <change>.
This brings the UI to <how it looks/behaves now>.

**Verified:** <where it was checked: page, devices>
```

- **Fix applied** is the click path to the change, with one `→` per step. Write one line per change.
- **Copy the location from the Phase 5 Fix steps** (or the snapshot Click path). That's where the change was actually made. Never rebuild it from the probe chain, and never add a widget the change wasn't made on. A widget that the CSS only *targets* is not the location.
- Pick the location shape that matches where the setting lives:

| Change made on | Location |
|---|---|
| A widget or container | `<Doc title> #<id> → Container (<id>) → … → <widget panel title> (<id>) → <tab> → <setting>` |
| The page/template/popup itself (gear icon settings, including its Custom CSS) | `<Doc type>: <Doc title> #<id> → Settings → <tab> → <setting>`, e.g. `Popup: Hamburger Sidebar #1661 → Settings → Advanced → Custom CSS` |
| Site Settings / Kit | `Site Settings → <section> → <setting>` |
| Custom Code (Elementor Pro) | `Elementor → Custom Code → <snippet title>` |

- **Change:** `old → new value`. For code that was edited, use `` changed `<old line>` → `<new line>` `` (only the changed line). For added code, end the line with "added at the end:" and put the **exact code added** (including the `by Claude` tags) in a ```css / ```js block right below it.
- Names: use exact editor names with ids. A widget's panel title comes from `get_title()` in its PHP (`tools/widget-locate.sh <widget_type>`), and the ids come from the Phase 2 probe (`doc`, `chain`, `element_id`). Open the browser only if a name or id the location needs is still missing. Never paraphrase a name (e.g. "Search Modal widget").
- End with the "This brings the UI to …" line.
- **Verified** says only where and how it was checked. Don't credit anyone (no "confirmed by the reporter's team").

## BE variant
Same spacing. Replace "Fix applied" and "Verified" with these:
```
**API:** `<METHOD> <path>` → <status>. Payload: `<trimmed key fields>`. Returns `<field>` = <actual>, expected <expected>.

**Suggested fix:** `temp/<file>:<line>`: <1 sentence on the change>. Handed to the backend team.
```

## Example
```
**RCA:** The order header container was fixed at 637px wide on mobile, so it overflowed the screen.

**Fix applied:** Order End Status #8196 → Container (3c143470) → Layout → Width (mobile) → 637px → 100%.
Order End Status #8196 → Container (3c143470) → WIZ: Order Header (a1b2c3d) → Advanced → Custom CSS → added at the end:
~~~css
/* by Claude WZS-4498 2026-11-04 */
@media (max-width: 767px) { selector .order-header__status { display: flex; flex-wrap: nowrap; } }
/* end by Claude WZS-4498 */
~~~
This brings the UI to a header that fits the screen with all buttons fully visible.

**Verified:** Order page on mobile (375px) and desktop.
```

## Posting
1. Show the full comment in your reply, inside a ````markdown block (four backticks, so the inner code block doesn't break it).
2. End the reply with exactly one line: `Post this comment to <KEY>? (yes/no)`. Then stop and wait. **Don't use `AskUserQuestion`** for this, because the dialog hides the comment.
3. **Yes:** post with `addCommentToJiraIssue` (`cloudId`, `contentFormat: "markdown"`) and reply `Posted.`
   **No** (or anything else): don't post. The user will copy it themselves.

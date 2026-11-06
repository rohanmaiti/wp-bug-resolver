# Apply and test a fix

Apply **only** the change the user approved in Phase 5. If you find you need anything more, stop and ask.

---

## A. Elementor (IMPLEMENTATION)

### 1. Open the editor
- Find the document that contains the widget. It's the nearest wrapper, which may be a header or footer template rather than the page itself:
  ```js
  (() => { const w = document.querySelector('[data-id="ELEMENT_ID"]');
    const d = w?.closest('[data-elementor-id]');
    return { doc_id: d?.dataset.elementorId, doc_type: d?.dataset.elementorType }; })()
  ```
- Editor URL: `https://<site>/wp-admin/post.php?post=<doc_id>&action=elementor`
- **Blast radius check:** if `doc_type` is `header`, `footer`, `popup` or `section` (a template), or the widget is a **Global widget**, the change affects every page that uses it. Tell the user in one line before going on.
- If the editor doesn't open (login page, no permission, wrong id), **ask the user for the editor URL** and to sign in in that tab. Never type credentials.

### 2. Snapshot, change, publish
Prefer the Elementor editor API over clicking, because it's exact and cheaper. Run it in the editor tab:

```js
// snapshot (save the output in your reply as "Revert snapshot")
(() => { const c = elementor.getContainer('ELEMENT_ID');
  return Object.fromEntries(['KEY1','KEY2'].map(k => [k, c.settings.get(k)])); })()
```
```js
// click path with exact editor names (save it as "Click path" for the Jira comment)
(() => { const p = []; let c = elementor.getContainer('ELEMENT_ID');
  while (c && c.type !== 'document') { p.unshift(`${c.settings.get('_title') || c.label} (${c.id})`); c = c.parent; }
  const d = elementor.documents.getCurrent();
  p.unshift(`${d.container.settings.get('post_title') || document.title.split(' ‹')[0]} #${d.id}`);
  return p.join(' → '); })()
```
```js
// apply exactly the approved settings
$e.run('document/elements/settings', { container: elementor.getContainer('ELEMENT_ID'),
  settings: { KEY1: 'value' } });
```
```js
await $e.run('document/save/publish'); 'published'
```

Setting keys:
- **Control keys** come from `tools/widget-controls.sh`.
- **Responsive variants:** `<key>_tablet`, `<key>_mobile`.
- **Widget Custom CSS:** `custom_css`.
- **Responsive visibility:** `hide_desktop`, `hide_tablet`, `hide_mobile` (value `hidden-<device>` or `''`).
- **Page Custom CSS:** use `container: elementor.documents.getCurrent().container` with `custom_css`.

For CSS or JS, snapshot the existing value, then append the tagged block from `implementation-fix.md` (`/* by Claude <KEY> <date> */`) at the end. Never overwrite the existing code. To revert, remove the tagged block.

**Site Settings (Kit) and Custom Code** live in other documents or screens. Make those changes through the UI, using `find` + `computer` clicks. Still take a snapshot by reading the current value before you change it.

If the `$e` API isn't available or throws, fall back to the UI: Navigator → select the widget → tab › section › control.

### 3. Test
1. Wait **5 s** after publishing.
2. Open the live page with a cache-busting param, `?nocache=<timestamp>`, on each device from the ticket (`resize_window`).
3. Re-run the same checks from Phase 2 that showed the bug: the widget probe, the computed style and the console.
4. If nothing changed at all, check before calling it a failure. Reload once more at about 15 s. Then confirm in the editor that the value was saved, to rule out caching or a save that didn't happen.

### 4. Pass / fail
- **Pass:** report: `Applied: <doc> › <widget> › <control> = <value>. Verified on <devices>.` Ask the user to confirm on their side.
- **Fail:** stop. Then:
  1. Tell the user, with one line of evidence: `Fix failed: <what you still see>`.
  2. Revert by applying the snapshot values with the same API call, then publish.
  3. Reload the live page and confirm it matches the pre-fix state.
  4. If you can't revert, give the user the exact snapshot (document, element, key = original value) and ask them to revert. Wait for them to confirm.
  5. Add the attempt to the Attempts list and go back to Phase 3.

---

## B. Code (FE-CODE)

1. Run `git -C storefront-wp status --porcelain`. If there are uncommitted changes, ask before touching anything.
2. `git -C storefront-wp switch -c fix/<JIRA-KEY> master`. Then apply **only** the diff from Phase 5 with Edit.
3. Test locally, always at **`http://localhost:8001`**. Check that it's up first with `curl -s -o /dev/null -w '%{http_code}' http://localhost:8001`.
   - If it's down, stop and tell the user to start Docker (`cd storefront-wp && make up`). Continue when they say it's running.
   - `mu-plugins` is live-mounted, so no rebuild is needed.
   - If the bug needs tenant data that only exists on prod or staging, say so and hand the test to the user. Don't deploy.
4. **Fail:** restore only the files you changed with `git -C storefront-wp checkout -- <files>`, tell the user, add the attempt to the Attempts list, and go back to Phase 3.
5. **Pass:** show `git diff --stat`. Ask before committing, pushing or opening a PR. These are separate approvals.

# FE code fix (storefront-wp)

## Delegate the search
Spawn the `fe-code-investigator` subagent with this brief, filled in:

```
Bug card: <5 lines>
Browser evidence: widget_type=<>, element classes=<>, console error=<file:line msg>, API call=<method path status + relevant response fields>
Hypothesis (if any): <>
Return: root cause (file:line + 1 sentence) and a minimal unified diff.
```

The subagent reads code at `master` and returns only its conclusion. Check that conclusion against the browser evidence. If it doesn't explain the symptom, send it back with the gap.

## What makes a fix acceptable (check before suggesting it)
- **Minimal:** change only the lines that cause the bug. No refactors, renames or formatting changes.
- Follows `storefront-wp/.cursor/rules/coding-conventions.mdc` and `pr-review-learnings.mdc`. Grep those files for the area you're touching. Don't read them in full.
- **v1 widgets:** bug fixes are allowed. `ProductListingModernWidget` is frozen, so only critical fixes go there.
- **v2 widgets / atoms:** fix the atom (`atoms/<Atom>/`) when the bug is in the atom, because every widget that uses it gets the fix. Say which widgets are affected.
- JSON-only API calls use `WizApi.call()` (endpoints in `helpers/wiz-api-endpoints.js`), not new `/wiz-ajax` handlers.
- Never remove `wp_ajax_nopriv_` hooks. They're intentional, because auth is enforced by the API.
- Shared state goes through WizState and events through `wizWidgetEvents` (`wiz:{component}:{action}`). Don't add new `window.*` globals.
- Don't touch `cors-security.php` or `csp-security.php`. Flag it if the fix needs them.
- Assets are versioned automatically (`wiz_get_asset_version()`), so no version-string changes are needed.

## Also say
- **Blast radius:** which widgets or tenants the change affects.
- Whether a cache purge is needed after deploy (page cache / CDN).

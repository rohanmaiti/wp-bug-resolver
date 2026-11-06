# BE bug (Ultron, `temp/`)

Suggest the fix only. BE fixes are never applied or tested here; they go to the backend team.

## 1. Collect evidence (browser network log)
- `METHOD /path`, status, timestamp, trace ID header if present
- Request payload: trim it to the fields that matter. **Strip tokens, emails and phone numbers.**
- The wrong part of the response: expected vs actual

## 2. Find the code
1. `WizApi.call('<key>')`: look up the key in `storefront-wp/wp-content/mu-plugins/helpers/wiz-api-endpoints.js` to get the path.
2. `/<feature>/vN/...` maps to `temp/api/<feature>/vN/router.py`. The logic is in `api/<feature>/services/`.
3. Spawn `be-code-investigator` with the endpoint, the trimmed payload and the wrong field. It returns file:line, a short code excerpt and a minimal diff.
4. If the value is **stale** rather than wrongly computed, suspect async or Elasticsearch indexing lag.

## 3. Output (normal reply text)
```
**Type:** BE

**Evidence:**
- API: `<METHOD> <path>` → <status> (trace: <id or ->)
- Payload: ```json <trimmed request> ```
- Response: `<field>` = <actual>, expected <expected>

**Root cause:** <1–2 sentences> (`temp/<file>:<line>`)
```python
<≤10-line excerpt of the faulty code>
```
<FE excerpt (≤6 lines) only if it shows how the UI builds the request>

**Suggested fix:**
```diff
<minimal unified diff>
```

**Hand-off:** backend team. Workaround on FE: <one line, or "none">.
```

Leave out any section that adds nothing (e.g. the FE excerpt). Then go to Phase 7, which posts the same evidence and fix on Jira.

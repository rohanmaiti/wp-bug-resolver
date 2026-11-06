# Browser checks

Use **Claude in Chrome**. Load all its tools in one `ToolSearch` call:
`select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__read_page,mcp__claude-in-chrome__get_page_text,mcp__claude-in-chrome__javascript_tool,mcp__claude-in-chrome__read_console_messages,mcp__claude-in-chrome__read_network_requests,mcp__claude-in-chrome__computer,mcp__claude-in-chrome__resize_window`

Prefer `javascript_tool`, `read_page` and `get_page_text` over screenshots. Take a screenshot only to confirm a visual symptom, and use `scale: 0.5`.

If you need a login, ask the user to sign in in that tab. Never type a password.

## 1. Find which widget renders the broken element

Every Elementor widget is wrapped in `.elementor-widget[data-widget_type="<widget_type>.default"][data-id="<id>"]`. Run this, replacing `SEL` with a CSS selector or `TEXT` with visible text:

```js
(() => {
  const SEL = null, TEXT = 'Add to cart';
  let el = SEL ? document.querySelector(SEL)
    : [...document.querySelectorAll('body *')].find(n => n.children.length === 0 && n.textContent.trim().includes(TEXT));
  if (!el) return 'not found';
  const w = el.closest('[data-widget_type]');
  const cs = getComputedStyle(el);
  return {
    widget_type: w?.dataset.widget_type?.replace('.default',''),
    element_id: w?.dataset.id,
    el_classes: el.className,
    parents: [...(function*(n){while(n&&n!==w){yield n.className;n=n.parentElement}})(el)].slice(0,4),
    // for the Jira click path: document → containers → widget
    doc: (d => d && `${d.dataset.elementorType} #${d.dataset.elementorId}`)(w?.closest('[data-elementor-id]')),
    chain: [...(function*(n){while(n){if(n.dataset?.id)yield `${n.dataset.element_type} (${n.dataset.id})`;n=n.parentElement?.closest('[data-id]')}})(w?.parentElement?.closest('[data-id]'))].reverse(),
    style: { display: cs.display, color: cs.color, bg: cs.backgroundColor, font: cs.font, w: cs.width, h: cs.height, overflow: cs.overflow, z: cs.zIndex, vis: cs.visibility },
  };
})()
```

Hand `widget_type` to `tools/widget-controls.sh` and `tools/widget-locate.sh`.

## 2. Find which CSS rule wins (styling bugs)

```js
(() => { const el = document.querySelector('SEL'); const out = [];
  for (const s of document.styleSheets) { let r; try { r = s.cssRules } catch { continue }
    for (const rule of r) if (rule.selectorText && el.matches(rule.selectorText))
      out.push([(s.href||'inline').split('/').pop(), rule.selectorText, rule.style.cssText.slice(0,160)]); }
  return out.slice(-15); })()
```

What the source of the winning rule tells you:
- `post-<id>.css`: Elementor page or widget settings. This points to **implementation**.
- `custom-frontend*.css`, `global.css` or the kit's `post-<kitId>.css`: site or kit settings.
- A `mu-plugins/...` file: widget or atom CSS in the **code**.

## 3. Console and network
- `read_console_messages` with `onlyErrors: true`. Note the source file of each error: `mu-plugins/...` points to FE code, a third-party file points elsewhere.
- `read_network_requests` with `urlPattern` set to the API host (e.g. `ultronapi`) or `wiz-ajax`. For each suspicious call, record method, path, status and the response fields the UI depends on. Fetch the body by `requestId` only when you need it.

## 4. Viewport and state
- Reproduce on the device from the ticket with `resize_window`: mobile is 375×812, tablet 768×1024. Elementor breakpoints are mobile ≤767 and tablet ≤1024 unless the site changed them.
- Logged-in state: `localStorage.getItem('buyer_data')` and the auth token keys in `localStorage`. WordPress login is not used.
- To rule out a stale CDN cache, add `?nocache=<random>`. Note that tracking params don't change the cache key (see storefront-wp CLAUDE.md, CDN cache-key whitelist).

## 5. Compare with another tenant (quick classifier)
If the same widget works correctly on a second tenant's site, the bug is most likely **implementation**. If it's broken everywhere, it's code.

# Implementation fix ladder

Stop at the first rung that fully fixes the bug. Lower rungs are easier for the implementation team to maintain.

**Tag every CSS or JS you add, wherever it goes** (widget, page or site Custom CSS, Custom Code, HTML widget, any CSS/JS plugin). Wrap the block in a comment and add it **at the end** of the existing code. Never replace the existing code:
```css
/* by Claude WZS-1234 2026-11-05 */
…rules…
/* end by Claude WZS-1234 */
```
For JS, use `// by Claude WZS-1234 2026-11-05` … `// end by Claude WZS-1234`. The tags make the change easy to find and to revert.

## Rung 1: An existing widget control
```bash
tools/widget-controls.sh <widget_type> <keyword>      # e.g. color, margin, hide, columns, typography
```
The output lists `tab › section › label  [key]  → selector: css`. Match the **CSS property and selector** you found in the browser to a control.
- If a control exists, the answer is: *Edit page in Elementor → select widget → <Tab> › <Section> › <Label> → set <value>* (say which device in the responsive switcher if relevant).
- Check the control's `condition`. A control can be hidden until another control is set (e.g. Background Type = Classic).
- If the widget uses **atoms** (v2), the atom controls also cascade from **Site Settings → WizShop/atom defaults** (`WizV2SiteSettings.php`). Use Rung 2 if every widget on the site should change.

## Rung 2: Site Settings / Kit (site-wide)
Use this for global colours (`--primary`, `--primary-text`), fonts, button styles, breakpoints and atom defaults. The path is *Elementor → Site Settings → Global Colors / Global Fonts / WizShop settings*. Only choose this rung when the bug is "wrong everywhere on this site".

## Rung 3: The widget's own Custom CSS (Elementor Pro)
*Widget → Advanced → Custom CSS*. Start the rule with `selector` so it only affects this one widget instance:
```css
selector .wiz-atc__button { padding: 10px 16px; }
@media (max-width: 767px) { selector .some-class { display: none; } }
```
Use the real classes you found in the browser. Avoid `!important` unless a code rule with `!important` must be overridden, and say so if you use it.

## Rung 4: Page or site Custom CSS
Use *Page Settings → Advanced → Custom CSS* (one page) or *Site Settings → Custom CSS* (whole site) when several widgets need the same change. Scope it with a body or page class so other pages aren't affected.

## Rung 5: Custom JS (last resort)
Use this only for behaviour CSS can't do. Prefer *Elementor Pro → Custom Code* (site-wide, choose the location) or an **HTML widget** on the page.
- Wait for the widget to render: use `document.addEventListener('DOMContentLoaded', …)`, or a `MutationObserver` if the widget renders on the client from an API call.
- Listen for platform events (`wiz:{component}:{action}` through `wizWidgetEvents`) rather than polling.
- Don't touch auth tokens or `localStorage` state.
- Flag it: **"workaround, consider a code fix"**. A JS patch per tenant is tech debt, so suggest an FE-CODE follow-up when other tenants would hit the same issue.

## If no rung fits
No control exists and CSS/JS would be fragile. Reclassify as **FE-CODE (missing control/feature)** and propose the control to add (key `{component}_{property}`, following the storefront-wp conventions).

# Classify: IMPLEMENTATION vs FE-CODE vs BE

Start by assuming **IMPLEMENTATION**. That's the most common case. Move to a code bug only when the evidence pushes you there.

| Evidence | Points to |
|---|---|
| Only one tenant/site is affected, and the same widget works on another tenant | IMPLEMENTATION |
| Wrong spacing, colour, font, alignment, size, or something hidden or showing on one device | IMPLEMENTATION (unless the winning CSS rule comes from a `mu-plugins` file and is wrong everywhere) |
| Wrong or missing content, link, image or label that was set in the Elementor editor | IMPLEMENTATION |
| Widget missing from a page, wrong widget used, wrong display condition or responsive visibility | IMPLEMENTATION |
| A widget feature "doesn't work" but a control for it exists and is off or misconfigured | IMPLEMENTATION |
| JS error in the console from a `mu-plugins/...` file | FE-CODE |
| The API response is correct but the UI shows it wrong (wrong field, bad formatting, broken state after an action) | FE-CODE |
| Broken on every tenant, or broken right after a storefront deploy | FE-CODE |
| An interaction (ATC, filter, pagination, modal, drawer) fails without any API error | FE-CODE |
| The design can't be achieved because no control exists and CSS can't reach it reliably | FE-CODE (missing control) or IMPLEMENTATION with custom CSS/JS. Prefer CSS when the fix is small. |
| The API returns a 5xx, a 4xx with a correct request, or a wrong or missing value in the **response** | BE |
| Data is wrong in the API response itself (price, stock, totals, permissions) | BE |

## Tie-breakers (cheapest first)
1. **Response vs render:** compare the API response field with what's on screen. If the response is wrong, it's BE. If the response is right and the screen is wrong, it's FE-CODE or IMPLEMENTATION.
2. **Other tenant:** open the same widget type on another tenant's site. If it works there, it's IMPLEMENTATION.
3. **Winning CSS rule source** (browser-checks.md §2): `post-<id>.css` points to IMPLEMENTATION, a `mu-plugins` file points to code.
4. **Cached?** Retry with `?nocache=…`. If the bug disappears, it's a cache issue: suggest a purge and treat it as IMPLEMENTATION/ops, not code.

## Write the result as
`Type: X, because <one piece of evidence>`

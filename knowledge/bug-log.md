# Bug log

The agent greps this file in Phase 0. Log **critical bugs only**, one line per ticket, newest first.

**Critical** means at least one of these:
- FE-CODE or BE
- Breaks cart, checkout, orders, pricing, auth or search
- Affects several tenants, or the whole site
- The root cause was not obvious, or it took 2 or more attempts

Don't log routine implementation fixes, such as a single control or CSS tweak on one page.

`YYYY-MM-DD | JIRA-KEY | IMPL/FE/BE | widget_type | symptom keywords | root cause → fix | tried: <failed attempts or ->`

---
2026-11-05 | no-key | FE | invoices_listing, invoice_header (AddCardAddAchCtaCommon) | pay drawer Add card iframe modal won't close, X dead, screen frozen after drawer reopen, invoices listing + invoice detail, kalalou | drawer AJAX re-render emits a new modal with the same fixed id while the old copy stays portaled in <body>; iframe close postMessage listener does getElementById(modalId) → gets the stale closed copy → returns early → AddCardAddAchCtaCommon.php click handler: remove other elements with same modalId / -overlay before opening (applied in ~/Developer/storefront-wp, live-injected test passed on 2nd+3rd reopen) | tried: -
2026-11-05 | no-key | IMPL | wiz_v2_search_modal | search no results modal too short, empty state box full-width, desktop, twos | header #11995 widget e6f16b4 Custom CSS overrode v2 defaults (.wiz-search-content__empty min-height:unset, .wiz-search-empty__box max-width:unset) → restore defaults in that CSS: content__empty min-height:500px, empty__box max-width:350px (matches v1 search_modern_widget look, e.g. sagebrook) | tried: box min-height:160px + content__empty padding-bottom:32px (box still full-width, area short; user wanted default centred look)
2026-11-05 | WZS-4504 | IMPL | form.default, wiz_v2_search_modal, wiz_v2_variant_drawer | iOS Safari auto-zoom on input/select focus, mobile forms site-wide, twos | fields <16px on mobile (form typography 14px in post-<page>.css, v2 inputs 14px) → Site Settings (kit) Custom CSS: @media(max-width:767px){input:not([type=checkbox]...),select,textarea{font-size:16px !important}} | tried: -
2026-11-05 | WZS-4499 | IMPL | wiz_v2_search_modal | search overlay opens behind hamburger sidebar popup, mobile, z-index, twos | header .elementor-location-header is sticky z-index:150 (site custom-css-js) = stacking context, so modal's 9940 is capped below Elementor popup (.dialog-type-lightbox 9939) → popup Custom CSS: header.elementor-location-header:has(.wiz-search-modal.open){z-index:9945} | tried: same rule on header .e-con:has(...) (inside header stacking context, no effect)
2026-11-05 | WZS-4497 | BE | order_listing | orders grid filter returns 0 / No Order Found, Requested Ship Date (custom date attribute) filter, SSRM, range matches wrong dates | POST /document/v2/ssrm/search: date-typed attribute filter goes to bare ES field attributes.<id>, which is dynamically mapped as text (value stored as 'MM/DD/YYYY'), so the ms range compares text tokens ('10','29','2026'); created_at works via created_at_milliseconds → BE to index a numeric/date companion for date attributes + route filter to it, reindex | tried: - (rejected: adding types to the .keyword-bypass list in ssrm.py:796, the filter already bypasses it)
2026-11-04 | WZS-4498 | IMPL | account_order_header | mobile order end status overflow, CTA truncated DUPLIC..., header chip/icons layout | page 8196 container 3c143470 mobile width 637px → 100%; custom CSS on widget to put status chip + icons on one row
2026-11-06 | WZS-4546 | FE | order_listing, AgGrid | All Orders grid shows wrong sort / mixed pages / blank cells + spinner over Order # after clicking sorts while loading, high volume (2300+), twos | old OrderListing.php sort + scroll-end handlers fired unguarded $.ajax, last reply won via .html()/.append(), aggrid-sortloading (hides cells, spinner on col 1) not cleared on throw → already fixed by storefront-wp #2175 (006a224fe, aggrid-virtualizer.js generation token drops stale fetches); verified live on twos 2026-11-06. Check workspace storefront-wp is current before diffing | tried: - (sortSeq guard diff for old OrderListing.php, obsolete)

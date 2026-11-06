# Batch summary: WZS-4476 (Rohan Maiti), 2026-11-05

| Key | Summary | Status | Type | RCA (1 line) | What was done / why it stopped | Session |
|---|---|---|---|---|---|---|
| WZS-4504 | Mobile forms: Safari auto-zoom on input focus | ✅ FIXED | IMPLEMENTATION | Mobile fields were under 16px, and iOS Safari zooms in on those | Kit #6 Custom CSS: mobile input/select/textarea set to 16px !important | [wzs-4504](#local_e65a7342-3032-4527-bb58-d4a8618f62f5) |
| WZS-4501 | Contact/claims page: iOS auto-zoom | ✅ FIXED | IMPLEMENTATION | Same cause as WZS-4504 (14–15px fields) | Already covered by the WZS-4504 rule; checked at 375px | [wzs-4501](#local_8ed27c6e-967a-4fdb-a30c-6e9c244562a9) |
| WZS-4486 | Safari: blue focus ring on hamburger close X | ✅ FIXED | IMPLEMENTATION | Accessible navigation moves focus to an X button that has no focus style | Popup #1661 Custom CSS: outline none on `.dialog-close-button:focus` | [wzs-4486](#local_ea41cef9-4234-4c94-808f-8d73df783cd6) |
| WZS-4512 | Resubmit quote: Cc email not received | 🧩 CODE-BUG | BE | FE sends `cc_emails`, and the backend drops the Cc or the email fails to send | Handed to the backend team (not reproduced, because that sends real emails) | [wzs-4512](#local_c9ad8a3a-c53e-46bb-95e3-8ec05dfbbbb1) |
| WZS-4535 | Forgot password: intermittent "User not found" | 🧩 CODE-BUG | BE | `get_user_tenant_map` raises a 404 that nothing catches in `reset_password` | Handed to the backend team; the 404 also lets someone find out which accounts exist | [wzs-4535](#local_9d31eb5f-5a52-4a8e-b34f-4845b8c7a4ac) |
| WZS-4517 | Cart qty modal: Suggested Quantity -1 | 🧩 CODE-BUG | FE-CODE | The -1 "no suggestion" value counts as true in `if (suggest)` | Diff suggested: `suggest > 0` in both quantity modals | [wzs-4517](#local_bcc9ba8a-3f0b-4953-b500-31e0b53d2f41) |
| WZS-4519 | Header shows wrong user vs dashboard | 🧩 CODE-BUG | FE-CODE | Session sync skips the case where both halves are logged in as different users | Direction suggested for `wiz-session-sync.js` | [wzs-4519](#local_268f52cd-4cbd-4ea8-8396-9deffc368a6a) |
| WZS-4491 | Mobile search: keyboard hides dropdown | 🧩 CODE-BUG | FE-CODE | SearchModalV2 uses 100dvh and never reads `visualViewport` | Code fix suggested; the doc 11995 header CSS also needs review | [wzs-4491](#local_ec4251e7-c06b-4366-9720-7b8dfb142b44) |
| WZS-4511 | Resubmit quote: two loaders at once | 🧩 CODE-BUG | FE-CODE | Button spinner plus full-page overlay shown together; the extra padding squeezes the label | Code fix suggested in WizQuoteResubmit | [wzs-4511](#local_dd6a410a-b025-46d3-acc5-1cc43e97c515) |
| WZS-4530 | Empty cart: ADD PRODUCTS still shown | 🧩 CODE-BUG | FE-CODE | Empty-cart toggle hides Save Cart but never hides `.add-products-btn` | Code fix suggested (a CSS stopgap is possible once signed in) | [wzs-4530](#local_8adc7473-1b31-484e-bd6f-3a251f9b02f0) |
| WZS-4532 | Catalogs: page scrolls behind qty modal | 🧩 CODE-BUG | FE-CODE | The modal locks only its own iframe; inline flipbooks never lock the outer page | Code fix suggested (switching to Dialog mode is a product decision); ticket already Invalid | [wzs-4532](#local_44d9b02b-d981-438a-90f1-3d857646a6ac) |
| WZS-4533 | Territory manager link flickers | 🧩 CODE-BUG | FE-CODE | PHP prints the logged-out label; JS swaps it and flips back during state reload | Code fix suggested; ticket already IN QA | [wzs-4533](#local_6ea5f34e-3512-4b13-9d79-504030896235) |
| WZS-4536 | Visual search: no way to clear | 🧩 CODE-BUG | FE-CODE | The Searched Value widget has no clear control | A PR reportedly exists already, so merge it | [wzs-4536](#local_cc45f352-e384-41eb-9548-67e4ac49ec0d) |
| WZS-4509 | WizOrder: quote PDF card clipped | 🧩 CODE-BUG | FE-CODE | The UI is in the WizOrder admin app (outside both repos) | Route to the WizOrder FE team | [wzs-4509](#local_5685cd80-4d58-4a01-aede-d45ed9505f1f) |
| WZS-4514 | Collection pages 404 (day-dreamer) | ⏭️ SKIPPED | IMPLEMENTATION | Mega-menu links have typo slugs (day-dreamer, the-charm-shop) | Fix found but not applied, because WP admin login expired | [wzs-4514](#local_6ce7781f-4f64-4d72-ae33-07bd2c2385b0) |
| WZS-4531 | Catalogs PDP: two accessiBe buttons | ⏭️ SKIPPED | IMPLEMENTATION | The embedded PDP loads accessiBe a second time | Kit CSS `::part(acsb-trigger)` tested live but not applied, because WP admin login expired | [wzs-4531](#local_4fcc22bf-491c-4c66-a82e-672dc9926b5c) |
| WZS-4506 | Order confirm layout on iPad Pro | ⏭️ SKIPPED | - | not reached | No order URL; repro means placing a real order; ticket disputed | [wzs-4506](#local_6bc505dd-1ce2-4b6c-a48a-f2bfe39fcc46) |
| WZS-4508 | Raise Claim → 403 | ⏭️ SKIPPED | - | not reached (if real: FE/BE permission bug) | Already Invalid and no longer reproducible | [wzs-4508](#local_3eef88fe-1053-4937-8d1b-08f4150963dd) |
| WZS-4513 | Accessibility: focus states / menu overlap | ⏭️ SKIPPED | - | not reached (likely an accessiBe adjustment) | Unknown accessiBe profile; the asked-for fix is code or third-party | [wzs-4513](#local_61bea1b5-d9ce-4f34-b5e5-35df701721ae) |
| WZS-4502 | Header/footer highlighted after menu close | ⏭️ SKIPPED | - | No defect; it's the outline CTA plus Safari's toolbar | Not reproduced | [wzs-4502](#local_28adea88-74b7-4c5d-9185-e3666127295b) |
| WZS-4507 | Order confirm: two download icons | ⏭️ SKIPPED | - | Two different features (Tearsheet and Download Media) without labels | Product decision | [wzs-4507](#local_5a4193dc-161d-4a01-91ee-1a924b0d20f7) |
| WZS-4510 | Quote end status: Quantity wraps | ⏭️ SKIPPED | - | not reached | No quote URL; buyer has 0 quotes; buyer login expired | [wzs-4510](#local_793caf72-6511-4c63-8b7c-91cc990e9235) |
| WZS-4516 | Recent Searches chips missing | ⏭️ SKIPPED | - | not confirmed (empty labels from the history API?) | Works for guests; buyer login expired | [wzs-4516](#local_ad0d0bc8-c11b-4849-845b-b9425a5e3ebb) |
| WZS-4521 | PDP accordion outline over header | ⏭️ SKIPPED | - | not reproduced | Header covers the outline; ticket on Hold | [wzs-4521](#local_5038daf7-3cd2-481a-a05c-ef21baadf98c) |
| WZS-4527 | Android header row breaks | ⏭️ SKIPPED | - | not reproduced (row is nowrap; CSS regenerated after the report) | One row from 320 to 412px | [wzs-4527](#local_f779269e-4907-4d47-8261-55e0a449b339) |
| WZS-4528 | Mobile PLP: filter bar overlaps cards | ⏭️ SKIPPED | - | The widget's fixed floating bar over infinite scroll, as designed | Product/code decision; ticket on Hold | [wzs-4528](#local_4f5cdd17-5139-47e6-9395-a2c526d4c04c) |
| WZS-4529 | Mobile cart availability text distorted | ⏭️ SKIPPED | - | not reached | Buyer login expired; ticket already IN QA | [wzs-4529](#local_e0358f3c-b43a-495d-9f03-737ef7d28edf) |
| WZS-4534 | Desktop mega menu: page scrolls | ⏭️ SKIPPED | - | Not a defect (hover dropdowns don't lock scroll) | Already Invalid; a scroll lock would be a product decision | [wzs-4534](#local_668dfa3c-6bcc-4715-806a-14f67d775497) |

**FIXED 3 · CODE-BUG 11 · SKIPPED 14 · FAILED 0**

**REVERT NEEDED:** none.

## Jira comments to post by hand
Verify each fix on your side (on a real iPhone for the iOS ones) before you post anything.

### WZS-4504
````markdown
**RCA:** iOS Safari zooms in when you tap a form field whose text is smaller than 16px. On mobile the site's fields were 14px (13px for the header search).

**Fix applied:** Site Settings → Custom CSS → added at the end:
~~~css
/* by Claude WZS-4504 2026-11-05 */
/* iOS Safari zooms on focus when a field's font-size is below 16px */
@media (max-width: 767px) {
  input:not([type="checkbox"]):not([type="radio"]):not([type="submit"]):not([type="button"]):not([type="file"]):not([type="range"]),
  select,
  textarea {
    font-size: 16px !important;
  }
}
/* end by Claude WZS-4504 */
~~~
This brings the UI to all form fields staying at 100% scale when tapped on mobile, with no zoom or cut-off fields.

**Verified:** Contact Us page at mobile (375px): all inputs, selects and text areas are 16px with no horizontal overflow. Desktop is unchanged (14px).
````

### WZS-4501
````markdown
**RCA:** iOS Safari zooms in when you tap a form field whose text is smaller than 16px. On mobile the Contact form fields were 14px and the claim product search was 15px.

**Fix applied:** Covered by the fix for WZS-4504. Site Settings → Custom CSS has a mobile-only rule (max-width 767px) that sets every input, select and textarea to 16px (`/* by Claude WZS-4504 2026-11-05 */`). No extra change was needed.

**Verify:** On an iPhone in Safari, open Contact Us and tap Department / email / phone / Message, then open a claim (Raise Claim) and tap the product search. The page should not zoom in.
````

### WZS-4486
````markdown
**RCA:** The hamburger drawer popup has "Accessible navigation" on, so it puts keyboard focus on the close (X) button when it opens. Nothing styled that focus, so Safari drew its default blue focus ring around the X.

**Fix applied:** Popup: sidebar #1661 → Settings → Advanced → Custom CSS → added at the end:
~~~css
/* by Claude WZS-4486 2026-11-05 */
/* Accessible navigation focuses the close (X) on open; hide the browser's default blue focus ring */
#elementor-popup-modal-1661 .dialog-close-button:focus { outline: none; box-shadow: none; }
/* end by Claude WZS-4486 */
~~~
This brings the UI to a close (X) button with no blue outline when the menu opens, and the X still closes the menu.

**Verified:** Home page with the hamburger menu open, on mobile (375px) and desktop.
````

### WZS-4512
````markdown
**RCA:** The resubmit worked in the UI, but the Cc person got no email. The storefront sends the Cc list (`cc_emails`) with the resubmit request, so the email is lost on the backend side.

**API:** `POST /wizshop/v1/document/quote/{document_id}/resubmit` → success (the UI moved on to the Submitted quote page). Payload: `{cart_id, subject, body, cc_emails: ["rythem.b@wizcommerce.com"]}` (built in `WizQuoteResubmit/resubmit.js`; not captured live). The Cc address should get the resubmit email, but nothing arrived.

**Suggested fix:** Backend resubmit handler for `/wizshop/v1/document/quote/{id}/resubmit`: make sure `cc_emails` from the request is passed to the email notification and check the send logs for WC_0000850 (2026-11-04, ~20:43 IST). Handed to the backend team.
````

### WZS-4535
````markdown
**RCA:** The forgot-password API sometimes throws a "user not found" error from its user-to-company lookup instead of returning its normal generic reply, and the storefront just shows that error. That is why the same email sometimes gets "User not found" and sometimes gets the reset email.

**API:** `POST /users/v1/password_reset` → 404 (intermittent; 200 otherwise). Payload: `{ "email": "rythem.b+02@wizcommerce.com" }`. Returns `message` = "user not found", expected a generic 200 (and the reset email for a valid user).

**Suggested fix:** `temp/api/user/services/user.py:1063`: in `reset_password`, catch `UserNotFoundException` from `get_user_tenant_map` and return `None`, so the endpoint always gives its generic reply. For WizShop, also look up the mapping by the request `tenant_id` instead of picking an unordered `[0]` (line 1081), so a valid user gets the email every time. Handed to the backend team.
````

### WZS-4517
````markdown
**RCA:** The cart's "Enter quantity" modal shows "Suggested Quantity: -1" for out-of-stock items. The storefront's cart validation (`helpers/cart-validation.js`) uses -1 internally to mean "no valid quantity to suggest" (it's returned when the item has a cart/stock error or when no quantity fits between min and available stock). The quantity modal (`widgets/cart-summary/js/quantity-modal.js`, and the same check in v2 `WizQuantityModal`) only checks whether a suggestion exists, not whether it's positive, so it shows the -1. This is a code bug, not an Elementor setup issue.

**Solution:** Show the suggestion only when it's a positive number: change `if (validationResult.suggest)` to `if (validationResult.suggest > 0)` in `widgets/cart-summary/js/quantity-modal.js` (~line 242), and `if (result.suggest)` to `if (result.suggest > 0)` in `widgets/v2/WizQuantityModal/quantity-modal.js` (~line 201). DONE stays disabled for out-of-stock items, which is expected.
````

### WZS-4519
````markdown
**RCA:** The storefront keeps a login in two places: the browser's localStorage (read by the header/profile menu) and a server cookie (used to render the Account Dashboard). Our session-sync script repairs the case where one is logged in and the other is logged out, but it intentionally skips the case where **both are logged in as different users**. In Safari the localStorage still held John (john@primejewellery.com) while the cookie was for Zzzz Test Customer, so the header and the dashboard showed different people.

**Solution (FE code, storefront-wp):** In `helpers/js/wiz-session-sync.js` › `describeMismatch()`, also compare the user id in the cookie with the one in localStorage `UserDetails`. If they still differ after the existing recheck and no customer switch is in progress, clear both halves (`/session-logout`) and reload so the user signs in cleanly. Then verify on twos.wizcommerce.com: log in as two users in Chrome and Safari, and check that the header email, Welcome Back name and territory manager always match.
````

### WZS-4491
````markdown
**RCA:** On mobile, the v2 search modal (`SearchModalV2/style.css:909`) is sized with `height: 100dvh`, and its results area uses dvh max-heights. iOS Safari doesn't shrink `dvh` when the keyboard opens, because the keyboard overlays the page. So the bottom part of the search panel (recent searches, recent products, top results) sits behind the keyboard and Safari's address bar. The widget's JS doesn't use `window.visualViewport` to adjust for the keyboard, and no Elementor setting can do it.

**Solution (FE code, storefront-wp):**
- In `SearchModalV2/search-modal.js`, while the modal is open on mobile, listen to `visualViewport` resize/scroll and set a CSS variable with the visible height on `.wiz-search-modal`.
- In the mobile CSS, size the modal with `height: var(--wiz-vvh, 100dvh)` and let the content area flex/scroll inside it (`flex:1; min-height:0; overflow-y:auto`) instead of fixed dvh heights.
- After that, review the twos header (doc 11995) search CSS overrides that also use `100dvh`.
- Verify on iPhone Safari: open search, focus the input, scroll to the last recent item or result. It should stay above the keyboard.
````

### WZS-4511
````markdown
**RCA:** On mobile resubmit, the "Resubmit quote to your rep" drawer (WizQuoteResubmit widget) shows two loaders by design. Tapping RESUBMIT QUOTE puts the button in a `.loading` state: an inline spinner plus 40px of extra right padding (`widgets/v2/WizQuoteResubmit/style.css` `.wqr__btn--submit.loading`). On success, `resubmit.js` `finishResubmitSuccess()` also opens the full-page "Resubmitting Quote..." overlay while the drawer is still closing. On a narrow screen the extra padding squeezes the button label, so it wraps or overlaps the spinner. This is a storefront code issue, not an Elementor/implementation setting.

**Solution (FE code):** In `resubmit.js`, clear the button loading state (or skip it) before calling `WizPreparingOverlay.navigate`, so only one loader shows. In `style.css`, change `.wqr__btn--submit.loading` so the label can't reflow: hide the icon and label text, centre the spinner, and remove the extra `padding-right`. Verify on a test quote at 375px: tap RESUBMIT QUOTE and check that only one loader appears and the button text doesn't overlap.
````

### WZS-4530
````markdown
**RCA:** On Cart Summary, the cart header widget hides the product count and the Save Cart button when the cart has 0 products, but it has no matching rule for the "Add products" button. So the button stays visible on empty carts, on desktop and mobile. This is in the shared cart-summary widget code (CartSummaryHeaderJs.js, empty-cart toggle), not in the tenant's Elementor setup.

**Solution:** FE code change in the cart-summary header widget: when product_count is 0, hide `.add-products-btn` the same way Save Cart is hidden (and show it again when products are added). Verify on twos.wizcommerce.com/cart-summary/ with an empty Draft Cart on desktop and Android Chrome: only the empty-state message and Browse Products should show.
````

### WZS-4532
````markdown
**RCA:** On /catalogs/ the Flipbooks widget opens catalogs **inline**, so the product page (and its Enter quantity popup) runs inside an embedded frame. The popup locks scrolling only inside that frame, not on the outer Catalogs page, so the outer page can still scroll to the footer behind the overlay.

**Solution:** Code fix needed (storefront): when the product page runs embedded in the catalog viewer, the quantity popup should also lock and unlock the outer page's scroll. In inline mode, the Flipbooks widget should do the same. Interim option (product decision): switch the Catalogs page › Flipbooks widget › Open mode from Inline to Dialog. Dialog opens full-screen and already locks the page scroll.
````

### WZS-4533
````markdown
**RCA:** The header's territory manager link is the WIZ v2 Sales Rep Assigned Trigger widget. Its PHP always prints the logged-out text ("Find your territory manager"). The JS replaces it with the logged-in text ("Contact your territory manager") only after the page loads, and runs again on every state change. While user state rehydrates, the WizState userDetails can be briefly empty, which the widget reads as logged out, so the label goes back to "Find" and then to "Contact" again.

**Solution (code, storefront-wp):** In `widgets/v2/WizSalesRepAssignedTrigger/`, keep the label hidden until the first JS sync (or pick the text server-side from the auth cookie), and in `isStorefrontUserLoggedIn()` fall back to the localStorage token instead of returning logged-out for an empty userDetails object. No Elementor change can fix this.
````

### WZS-4536
````markdown
**RCA:** The "Search results for" chip on the PLP comes from the WIZ: Searched Value widget (`widgets/SearchModern/SearchedValueWidget.php`). Its markup shows only the title and the searched image/text. It has no clear/remove control, and no Elementor setting adds one, so visual (`type=ai-image`) and text searches can't be dismissed from the results header.
**Solution:** Code change in the widget: add an X / "Clear search" control to `.searched-value-container` that links to the current page URL without the `search` and `type` params (restoring the default listing). A PR for this already exists and needs to be reviewed and merged. Nothing can be fixed from Elementor.
````

### WZS-4509
````markdown
**RCA:** This is in the WizOrder admin app, not the WizShop storefront. The "Attached Quote Document" file card in the "Publish to Website Users" drawer doesn't take the drawer's full width (likely a fixed width or clipping on the card container), so its border stops short of the Subject and Recipients fields above it. There's no Elementor setting for this screen.

**Solution (FE code, WizOrder admin app):**
- In the Publish to Website Users drawer component, set the attachment card container to `width: 100%` with the same horizontal padding as the Subject/Recipients fields, and remove any fixed width or `overflow: hidden` that cuts the border.
- Let long file names truncate inside the card (`min-width: 0; text-overflow: ellipsis`) instead of widening or clipping it.
- Verify on a submitted quote (e.g. WC_0000850): open the Publish drawer. The PDF card should line up edge to edge with the fields above, with its full border visible.
````

## Needs your input
Answer these, then run `/resolve-bug <KEY>` for each one.

- **WZS-4514:** The Elementor editor for twos.wizcommerce.com redirects to wp-login. Can you sign in to WP admin in Chrome (or apply the 4 link changes in the fix plan yourself) so the menu links to day-dreamer and the-charm-shop can be corrected?
- **WZS-4531:** Please sign in to twos.wizcommerce.com/wp-admin in Chrome (the Elementor editor redirects to wp-login). Then apply the kit #6 Custom CSS rule above, or re-run WZS-4531.
- **WZS-4506:** Can you share an order confirmation URL on twos.wizcommerce.com (an existing order the buyer account can open) and confirm whether the issue still reproduces at 1032px after Rythem's walkthrough? Or should this stay closed as invalid?
- **WZS-4508:** This is already closed as Invalid (Bhagya: no longer reproducible, possibly cache). Do you want it investigated further? If so, please give an order confirmation URL and the buyer account/role that got the 403 on return-order/v1. Otherwise, leave it closed.
- **WZS-4513:** Which accessiBe profile or adjustment was switched on in the recording (e.g. Keyboard Navigation, Highlight Links, ADHD Friendly), and is the expectation to change how accessiBe highlights links (accessiBe config), or to fix the ElementsKit mega menu so it layers correctly and traps focus (code)? Please also share a frame that shows the overlapping mega-menu panel.
- **WZS-4502:** On an iPhone, after closing the hamburger drawer, is anything on the page itself still highlighted (not Safari's bottom address/toolbar bar and not the hero's outline "SHOP …" button, which look the same before the menu is opened)? If so, which element, and at what timestamp in the recording?
- **WZS-4507:** On the twos order confirmation page, the two icons are different features: Tearsheet Download (order PDF) and Download Media (product images). Should we (a) hide one of them, and if so which, or (b) keep both and add text labels (Tearsheet via its Text control, Download Media via CSS or a small code change)? Also, please share the order-confirm page/template URL or editor link.
- **WZS-4510:** Can you share a twos quote end-status URL (/review/quote/{document_id}/) that has products and shows the wrap on mobile? The signed-in customer has 0 quotes. Please also make sure Chrome is still signed in to twos.wizcommerce.com.
- **WZS-4516:** Was the reporter logged in as a buyer (and on which device)? If logged in, can you sign in to the twos buyer session in Chrome so the `/wizshop/v1/history/search` response can be checked? Recent searches render fine for guests.
- **WZS-4521:** On twos.wizcommerce.com/product-details/catania-5x7-bone-photo-frame/ (desktop Chrome), the accordion focus outline stays under the sticky header with accessiBe "Highlight Focus" both on and off. Which exact accessiBe option(s) were on in the recording (Highlight Focus, Keyboard Navigation, ADHD Friendly profile?), and at what browser width or zoom? Or can you share the frame where the outline overlaps the nav?
- **WZS-4527:** I can't reproduce this. The twos header stays on one row at 320–412px, and the header CSS was regenerated at 15:13 IST today, after the 09:07 screenshot. Does it still happen on the Android phone after a hard refresh while logged in? If yes, what are the device model, the Chrome display/font-size settings and the exact URL?
- **WZS-4528:** The Filters/Sort pill is a fixed floating bar by the widget's design, and the PLP scrolls infinitely, so some card text is always under it while scrolling (the content scrolls clear). Do you want a design change, such as: (a) a full-width docked bottom bar plus matching body padding-bottom (possible as Custom CSS on page 12642 / Global widget 30878), (b) hide the pill on scroll-down and show it on scroll-up (JS/code change in mobileViewFilterWidget), or (c) close as working as designed?
- **WZS-4529:** Please sign in as a twos buyer in Chrome and add SKU 54972 (qty 2) to the cart so the Cart Summary can be inspected at 375px. Should this ticket be re-run once you've done that?
- **WZS-4534:** WZS-4534 is marked Invalid, and hover mega menus normally let the page scroll. Do you want a scroll lock while the mega menu is open? That would mean custom JS on the header (toggle `overflow:hidden` on body while `.elementskit-megamenu-panel` is hovered or open), and it's a UX change that product would need to approve. If not, close this subtask.

## Flags
- **Site-wide kit change (WZS-4504):** kit #6 Custom CSS forces mobile form fields to 16px `!important` on every page. The WZS-4501 fix depends on this rule.
- **WZS-4486:** the X in popup #1661 now has no focus indicator for keyboard users. Consider a custom `:focus-visible` style.
- **Not checked on real devices:** the iOS and Android fixes were checked in Chrome only.
- **Logins expired partway through:** the twos buyer session and WP admin in Chrome expired. WZS-4514 and WZS-4531 have ready fixes that need WP admin. WZS-4510, 4516 and 4529 need a buyer login.
- **FE follow-up:** the v2 atoms and claims CSS use 14–15px inputs on mobile, so other tenants will still see iOS zoom (WZS-4504, WZS-4501).
- **Already closed or in progress in Jira:** Invalid: 4506, 4508, 4532, 4534. IN QA: 4529, 4533. On Hold: 4521, 4528. PR pending: 4536.
- **WZS-4514:** the Jira thread calls it a data issue, but it's a link typo. Tell the CSM before anyone changes catalog data.

---
sprint: 4
project: RKB
focus: Vietnamese Buyer End-to-End Playbook (Priority B)
started: 2026-04-21
status: IN PROGRESS
---

# RKB Sprint 4 — Vietnamese Buyer End-to-End Playbook

## Scope
Chain 13+ existing buyer-side pages (Sprint 1-3) thành 1 guided playbook end-to-end + 1-page cheatsheet.

## Worktree
| Worktree | Branch | Agent | Scope |
|---|---|---|---|
| `RKB-buyer-playbook` | `sprint-4-buyer-playbook` | agent-playbook | New page + cheatsheet + nav update |

## Files to create
- `09-buyer-journey/vietnamese-buyer-end-to-end-playbook.mdx` (400-600 lines) — full journey Pre-approval → Keys, chia 10 stages, each stage link to existing detailed page
- `09-buyer-journey/40-days-cheatsheet.mdx` (100-200 lines) — 1-page quick reference "40 Days from First Call to Keys", printable

## Existing pages to link (from 09-buyer-journey/)
- vietnamese-buyer-guide.mdx
- buyer-consultation-sop.mdx
- buyer-financing-guide.mdx
- home-search-strategy.mdx
- feng-shui-property-selection.mdx
- showing-property-sop.mdx
- offer-strategy.mdx
- due-diligence-checklist.mdx
- blue-tape-walkthrough.mdx
- builder-promo-analysis.mdx
- mortgage-calculator-tool.mdx
- deal-comparison-calculator.mdx
- mortgage-payment-strategy.mdx

## Structure (playbook page)
1. **Overview** — 40-day timeline visual (ASCII timeline), 10 stages summary
2. **Stage 1: Pre-Approval (Day 1-3)** — link buyer-financing-guide, calculators
3. **Stage 2: Buyer Consultation (Day 3-5)** — link buyer-consultation-sop, vietnamese-buyer-guide
4. **Stage 3: Needs Analysis + Feng Shui (Day 5-7)** — link feng-shui-property-selection, home-search-strategy
5. **Stage 4: Home Search (Day 7-14)** — link home-search-strategy
6. **Stage 5: Showing + Shortlist (Day 14-21)** — link showing-property-sop
7. **Stage 6: Offer Strategy (Day 21-23)** — link offer-strategy, builder-promo-analysis
8. **Stage 7: Option Period + Inspection (Day 23-32)** — link due-diligence-checklist
9. **Stage 8: Financing Finalize (Day 25-35)** — link mortgage-payment-strategy, mortgage-calculator-tool
10. **Stage 9: Final Walkthrough + Blue Tape (Day 38-39)** — link blue-tape-walkthrough
11. **Stage 10: Closing + Keys (Day 40)** — checklist, after-closing tips

Each stage includes: What happens / Vietnamese cultural notes / Phong tip / Link to detail page.

## Nav updates
- `09-buyer-journey/index.mdx` — add 2 new pages to nav list
- `documentation.json` or equivalent — add new pages

## Frontmatter (both files)
```yaml
---
title: ...
description: ... (50-200 chars)
last_reviewed: 2026-04-21
data_freshness: "2026-04 (Sprint 4)"
keywords: [vietnamese buyer, texas real estate, sherman, dfw, home buying journey]
---
```

## Validation
- Run `scripts/check-links.sh` — must be 0 broken links
- Run `scripts/check-frontmatter.sh` — must pass
- Run `scripts/pre-commit-check.sh` — must pass

## Commit + push
- Commit format: `feat(S4-RKB-playbook): Vietnamese buyer end-to-end playbook + 40-day cheatsheet`
- Push to `sprint-4-buyer-playbook` branch
- Do NOT merge to main (Brain merges)

## Definition of Done
- Playbook page 400-600 lines, 10 stages, all links work
- Cheatsheet 1-page printable
- Nav updated
- Validation scripts all pass
- Pushed to `sprint-4-buyer-playbook`

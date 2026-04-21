# RKB Sprint 1 — Deal Intelligence

**Opened:** 2026-04-21 CDT
**Theme:** Deal Intelligence — tập trung 4 pain points Realtor Phong
**Brain:** Opus 4.7 (em, Claude Code CLI chính)
**Executors:** 3 Sonnet agents via Task tool

---

## 🎯 Pain points cover

1. Quy trình + chiến lược đàm phán (PRE vs POST deposit)
2. Calculator so sánh deal (rate/promo/bonus với builder/seller)
3. Chương trình hỗ trợ mortgage cho khách Vietnamese-American
4. Chiến lược thanh toán mortgage sau khi sở hữu nhà

---

## 📋 TASK POOL (8 tasks)

### 🧭 Brain (Win 1)
- [ ] **S1-W1-00** Bootstrap: copy 4 validation scripts from wiki + CI workflow + task-board (done this commit)
- [ ] **S1-W1-01** Final merge 3 worker branches + nav update + changelog + Sprint 1 close

### 🤝 Agent 1 — Negotiation (Win 2)
Worktree: `/Users/phongto/Workspace/Claude/RKB-negotiation` branch `sprint-1-negotiation`
- [ ] **S1-W2-01** Expand `01-sales-crm/chien-luoc-offer.mdx` 181 → 350+ lines — **PRE-deposit** framework (BATNA/ZOPA, leverage points, walk-away conditions, competitive offer tactics, Vietnamese cultural context, Chris Voss tactical empathy)
- [ ] **S1-W2-02** Create `04-transaction-management/post-deposit-negotiation.mdx` — **POST-deposit** tactics (option period TREC 40-10, inspection repair negotiation, appraisal gap clause, repair credits vs repair work, terminate vs renegotiate)

### 🧮 Agent 2 — Calculators (Win 3)
Worktree: `/Users/phongto/Workspace/Claude/RKB-calculators` branch `sprint-1-calculators`
- [ ] **S1-W3-01** Create `09-buyer-journey/deal-comparison-calculator.mdx` — formulas + examples compare: rate buydown vs cash incentive vs closing cost credit vs price discount. Include Google Sheets/Excel template references, real DFW examples
- [ ] **S1-W3-02** Create `09-buyer-journey/builder-promo-analysis.mdx` — decode builder promotions (2-1 temporary buydown, permanent rate buydown, closing cost coverage, free upgrades, appliance packages, design credit) với real $ value math. Target big DFW builders: Pulte, Lennar, D.R. Horton, KB Home, Beazer

### 💰 Agent 3 — Mortgage (Win 4)
Worktree: `/Users/phongto/Workspace/Claude/RKB-mortgage` branch `sprint-1-mortgage`
- [ ] **S1-W4-01** Expand `09-buyer-journey/buyer-financing-guide.mdx` 327 → 500+ với Texas-specific mortgage assistance (TSAHC Home Sweet Texas Home Loan, TDHCA My First Texas Home, Mortgage Credit Certificate MCC, HOME program, VA cho vets, FHA cho Vietnamese immigrants, USDA cho rural TX counties, builder-backed assistance programs)
- [ ] **S1-W4-02** Create `09-buyer-journey/mortgage-payment-strategy.mdx` — post-purchase payment strategy (biweekly payment acceleration, extra principal payments, recast vs refinance, PMI removal 20% equity, tax/insurance escrow optimization, lump sum payoff strategies). Include payoff calculator templates

---

## 📨 Cross-Scope Requests → `plans/cross-scope-sprint-1.md`

---

## Protocol

- Worker commits với task ID tag: `feat(S1-WN-NN): <title>`
- Worker pushes branch, Brain merges to main
- Cross-scope (documentation.json) → append `plans/cross-scope-sprint-1.md`
- Validation: pre-commit + check-links must pass before commit (check-frontmatter defer — baseline cần audit full)

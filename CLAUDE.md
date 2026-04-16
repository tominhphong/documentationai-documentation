# CLAUDE.md — Realtor Knowledge Base (RKB)

> Hướng dẫn cho Claude Code khi làm việc với repo này.
> Documentation site: https://phong-to.documentationai.com

---

## MCP Server

```bash
# Thêm MCP server vào Claude Code:
claude mcp add --transport http documentation-ai https://phong-to.documentationai.com/_mcp
```

**Tool khả dụng:** `searchDocumentation`

**Cách dùng:** Trước khi tạo hoặc sửa file `.mdx`, hãy search MCP để:
- Kiểm tra nội dung đã có (tránh duplicate)
- Đảm bảo format nhất quán với các file cùng phòng ban
- Tìm ví dụ về component đang dùng trong site

**Ví dụ query:**
```
searchDocumentation("follow-up scripts buyer")
searchDocumentation("open house checklist Vietnamese")
searchDocumentation("commission calculator eXp")
```

---

## Cấu trúc File — 10 Phòng ban RKB

```
documentationai-documentation/
├── CLAUDE.md                          ← file này
├── 01-sales-crm/                      # Pipeline, scripts, CRM
│   ├── pipeline-giai-doan.mdx
│   ├── follow-up-system.mdx
│   ├── scripts-tu-van.mdx
│   ├── xu-ly-phan-doi.mdx
│   ├── chien-luoc-offer.mdx
│   ├── checklist-closing.mdx
│   ├── ho-so-khach-hang.mdx
│   └── referral-tracking.mdx
├── 02-marketing-content/              # Social, video, email, community
│   ├── brand-voice-guide.mdx
│   ├── social-media-hooks.mdx
│   ├── video-scripts.mdx
│   ├── email-templates.mdx
│   ├── open-house-promo.mdx
│   ├── vietnamese-community-outreach.mdx
│   └── content-calendar.mdx
├── 03-market-intelligence/            # DFW market data, CMA, trends
│   ├── sherman-tx-market-data.mdx
│   ├── median-price-trends.mdx
│   ├── inventory-dom.mdx
│   ├── neighborhood-profiles.mdx
│   └── cma-comparable-sales.mdx
├── 04-transaction-management/         # Option period, earnest money, closing
├── 05-finance-accounting/             # eXp commission, tax, accounting
├── 06-legal-compliance/               # TREC, Fair Housing, Texas disclosure
├── 07-client-communication/           # Follow-up scripts, drip sequences
├── 08-listing-marketing/              # Photography SOP, MLS, open house
├── 09-buyer-journey/                  # Buyer consultation, loan types, closing
└── 10-quality-reviews/                # Post-closing survey, Google reviews, KPIs
```

---

## Components Được Hỗ Trợ (Đã Kiểm Tra)

### ✅ DÙNG ĐƯỢC

**Callout** — thông báo quan trọng:
```mdx
<Callout kind="warning">Nội dung cảnh báo</Callout>
<Callout kind="info">Thông tin bổ sung</Callout>
<Callout kind="success">Xác nhận thành công</Callout>
```

**Steps** — quy trình có thứ tự:
```mdx
<Steps>
  <Step title="Bước 1">Mô tả bước 1</Step>
  <Step title="Bước 2">Mô tả bước 2</Step>
</Steps>
```

**Tabs** — nội dung tab:
```mdx
<Tabs>
  <Tab title="Tab 1">Nội dung tab 1</Tab>
  <Tab title="Tab 2">Nội dung tab 2</Tab>
</Tabs>
```

**Image** — ảnh với caption:
```mdx
<Image
  src="https://example.com/image.jpg"
  alt="Mô tả ảnh"
  width="800"
  height="450"
/>
```

**Code blocks** — với syntax highlighting:
````mdx
```python
# Python code
```

```bash
# Shell commands
```
````

**Markdown tables** — cho dữ liệu dạng bảng:
```mdx
| Cột 1 | Cột 2 | Cột 3 |
|-------|-------|-------|
| Giá   | $xxx  | Notes |
```

### ❌ TRÁNH DÙNG

| Component | Lý do | Thay thế |
|-----------|-------|----------|
| `<CardGroup>` | Gây lỗi deploy | Dùng Markdown table hoặc Steps |
| `<Column>` | Gây lỗi deploy | Dùng Markdown table |
| `<Columns>` | Chưa kiểm tra | Dùng Markdown table |
| Mermaid diagrams | Không hỗ trợ | Dùng text outline |

> **Lưu ý quan trọng:** Nếu cần thêm component mới chưa trong danh sách, hãy test trên một file phụ trước khi thêm vào file chính thức.

---

## Quy Chuẩn Viết Nội Dung

### Ngôn ngữ
- **Tiếng Việt là ngôn ngữ chính** — tất cả tiêu đề, hướng dẫn, và nội dung chính
- Thuật ngữ chuyên ngành có thể giữ tiếng Anh (ví dụ: "earnest money", "option period", "MLS")
- Phục vụ Realtor người Việt tại DFW, Texas

### Frontmatter bắt buộc
```mdx
---
title: "Tên trang bằng tiếng Việt"
description: "Mô tả ngắn — xuất hiện trên Google và site search"
---
```

### Cấu trúc trang chuẩn
```
# Tiêu đề chính (H1 — dùng 1 lần duy nhất)

[Intro paragraph — 2-3 câu]

<Callout kind="warning">Cảnh báo quan trọng nếu có</Callout>

## Mục 1

[Nội dung]

## Mục 2

[Nội dung]

---

## Checklist / Tóm tắt
```

### Tone và phong cách
- Thực tế, súc tích — không lý thuyết
- Dùng số liệu cụ thể khi có (ví dụ: "3 ngày", "$500", "72 giờ")
- Checklist dạng `- [ ]` cho workflow
- Ví dụ thực tế từ thị trường DFW

---

## Context Thị Trường (Phong To — Realtor)

| | |
|--|--|
| **Realtor** | Phong To |
| **Brokerage** | eXp Realty, LLC |
| **TREC License** | #843757 |
| **Thị trường chính** | DFW (Dallas-Fort Worth), Texas |
| **Cộng đồng phục vụ** | Vietnamese-American tại DFW |
| **Commission split** | 80/20 (eXp standard) |

**Submarket trọng tâm:** Sherman, TX / Grayson County (emerging market)

**Đặc điểm khách hàng:**
- Vietnamese-American first/second-gen
- Đọc hiểu tiếng Việt tốt hơn tiếng Anh
- Quan tâm đến: giá trị dài hạn, cộng đồng, trường học
- Kênh tiếp cận: Facebook groups tiếng Việt, iMessage, WhatsApp

---

## Kết Quả Test MCP — Tất Cả 10 Phòng Ban (2026-04-16)

| # | Phòng ban | Status | Nội dung mẫu trả về |
|---|-----------|--------|---------------------|
| 01 | Sales & CRM | ✅ PASS | HubSpot 7-stage pipeline, follow-up templates, offer strategy |
| 02 | Marketing & Content | ✅ PASS | FB Vietnamese community, 40 hooks, video scripts |
| 03 | Market Intelligence | ✅ PASS | Sherman TX data, CMA guide, Grayson County comparisons |
| 04 | Transaction Management | ✅ PASS | Option period, earnest money rules, closing checklists |
| 05 | Finance & Accounting | ✅ PASS | eXp 80/20 split, commission tracker, tax deductions |
| 06 | Legal & Compliance | ✅ PASS | TREC license, Fair Housing 7 classes, Texas disclosures |
| 07 | Client Communication | ✅ PASS | Cold re-engagement scripts, breakup messages, drip system |
| 08 | Listing Marketing | ✅ PASS | Photography SOP với Image component, MLS, open house |
| 09 | Buyer Journey | ✅ PASS | Conventional vs FHA table, BMA-1, buyer consultation SOP |
| 10 | Quality & Reviews | ✅ PASS | Post-closing survey 6-step, Google Review timing, KPIs |

**Kết luận:** MCP server hoạt động ổn định, trả về nội dung chính xác, URL đúng domain `phong-to.documentationai.com`.

---

## Workflow Claude Code + MCP

```
1. Claude đọc CLAUDE.md này để nắm context
2. Dùng searchDocumentation() để tìm hiểu nội dung hiện có
3. Tạo/sửa file .mdx theo quy chuẩn trong file này
4. Chỉ dùng components trong danh sách ✅
5. Commit và push → Documentation.AI tự động deploy
```

**Không cần build thủ công** — GitHub push là đủ.

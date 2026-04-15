# Build Lessons — Realtor Knowledge Base on Documentation.ai

> File này ghi lại mọi bài học, lỗi, và quyết định quan trọng trong quá trình xây dựng.  
> **Đọc file này trước khi bắt đầu bất kỳ session build mới nào.**  
> Cập nhật sau mỗi lần gặp vấn đề mới.

---

## L01 — Không upload hết tất cả file một lúc

**Vấn đề:** Khi tạo hết tất cả 50+ file MDX cùng lúc, cấu trúc MDX bị lỗi khi deploy lên documentation.ai.

**Giải pháp:** Xây từng phòng ban một. Build xong → push → verify → mới qua phòng tiếp theo.

**Quy trình đúng:**
1. Tạo tất cả file `.mdx` cho 1 phòng ban
2. Cập nhật `documentation.json`
3. Commit + push
4. Kiểm tra site live
5. Mới bắt đầu phòng tiếp theo

---

## L02 — Ký tự checkbox Unicode ☐ không render được

**Vấn đề:** Ký tự `☐` (U+2610) và `□` (U+25A1) hiển thị thành hình vuông rỗng trên documentation.ai — không phải checkbox đẹp như mong muốn.

**Giải pháp theo từng tình huống:**

| Tình huống | SAI ❌ | ĐÚNG ✅ |
|-----------|--------|---------|
| Nhiều lựa chọn trong table | `☐ Có  ☐ Không  ☐ Tùy` | `Có / Không / Tùy` |
| Danh sách checklist ngoài table | `☐ First-time buyer` | `- [ ] First-time buyer` |
| Tags/labels inline | `☐ Hot 🔥  ☐ Warm 🟡` | `Hot 🔥 / Warm 🟡 / Cold ❄️` |

**Lưu ý:** Emoji (🔥🟡❄️⏳🏡) render tốt — không phải lỗi emoji.

---

## L03 — Git push từ sandbox cần token từ Mac1

**Vấn đề:** Sandbox không có GitHub credentials. Lệnh `git push origin main` báo lỗi:  
`fatal: could not read Username for 'https://github.com': No such device or address`

**Giải pháp:**
1. Dùng Desktop Commander MCP để chạy lệnh trên Mac1: `gh auth token`
2. Lấy token trả về (dạng `gho_xxxx...`)
3. Set remote URL trong sandbox:
   ```bash
   git remote set-url origin https://TOKEN@github.com/tominhphong/documentationai-documentation.git
   git push origin main
   ```
4. **Sau khi push xong, xoá token khỏi URL ngay:**
   ```bash
   git remote set-url origin https://github.com/tominhphong/documentationai-documentation.git
   ```

**Tài khoản GitHub:** `tominhphong` (active account trên Mac1)  
**Repo:** `tominhphong/documentationai-documentation`

---

## L04 — Cấu trúc documentation.json — Giữ nguyên tabs cũ

**Vấn đề:** documentation.json có sẵn tabs "Documentation" và "Changelog" từ starter kit. Nếu xoá đi sẽ mất cấu trúc gốc.

**Giải pháp:** Khi thêm tab mới "Realtor Knowledge Base", đặt nó làm tab đầu tiên và **giữ nguyên** các tabs cũ ở phía sau.

**Cấu trúc đúng:**
```json
{
  "navigation": {
    "tabs": [
      { "tab": "Realtor Knowledge Base", ... },  ← Tab mới, đặt trước
      { "tab": "Documentation", ... },            ← Giữ nguyên
      { "tab": "Changelog", ... }                 ← Giữ nguyên
    ]
  }
}
```

---

## L05 — Mỗi file MDX phải có frontmatter đúng chuẩn

**Bắt buộc ở đầu mỗi file `.mdx`:**
```yaml
---
title: "Tên trang"
description: "Mô tả ngắn hiển thị dưới title trên site."
---
```

**Lưu ý:** `description` quan trọng cho SEO và preview card. Không bỏ qua.

---

## L06 — Components MDX được hỗ trợ trên documentation.ai

**Đã test và hoạt động:**
```mdx
<Callout kind="info">Nội dung thông tin</Callout>
<Callout kind="warning">Cảnh báo quan trọng</Callout>
```

**Chưa test:** `<Tabs>`, `<Steps>`, `<AccordionGroup>` — cần verify trước khi dùng.

**Markdown chuẩn:** Bảng, heading (#/##/###), bold/italic, code block, list — đều hoạt động tốt.

---

## L07 — Quy tắc đặt tên file và path

**Format:** `ten-file-viet-thuong-co-dau-gach.mdx`

**Ví dụ đúng:**
- `ho-so-khach-hang.mdx`
- `pipeline-giai-doan.mdx`
- `scripts-tu-van.mdx`

**Trong `documentation.json`**, path viết không có extension:
```json
{ "title": "Hồ Sơ Khách Hàng", "path": "01-sales-crm/ho-so-khach-hang" }
```

---

## L08 — Chiến lược xây dựng: Cá nhân trước, thương mại hóa sau

**Quyết định đã thống nhất (2026-04-15):**

Xây bản cá nhân của Phong trước, sau đó mới generalize thành sản phẩm thương mại.

**Lý do:**
- Tránh "premature generalization" — xây cho ai cũng không thực sự phù hợp với ai
- Bản cá nhân = case study thực tế khi pitch cho realtors khác
- 80% cấu trúc sẽ giữ nguyên khi generalize — không mất công làm lại
- Dùng thực tế 2-3 tháng → biết cái gì thực sự có giá trị

**Lộ trình:**
1. Xây xong 10 phòng ban cho Phong (bản cá nhân)
2. Dùng thực tế → note bài học
3. Generalize → template thương mại
4. Pricing: Vietnamese realtors → Texas → National

---

## L09 — Thứ tự ưu tiên khi gặp lỗi render

Khi thấy nội dung hiển thị sai trên site:

1. **Kiểm tra ký tự Unicode** — Tìm `☐`, `□`, `→`, `←`, `✓` và các ký tự đặc biệt
2. **Kiểm tra MDX syntax** — JSX components phải đóng tag đúng
3. **Kiểm tra frontmatter** — `title` và `description` phải có
4. **Kiểm tra `documentation.json`** — path phải match tên file thực tế

---

## Template Kiểm Tra Trước Khi Push

Chạy lệnh này trước mỗi commit để catch lỗi sớm:

```bash
# Tìm ký tự checkbox Unicode còn sót
grep -rn "☐\|□" ./01-sales-crm/

# Verify frontmatter có đủ title + description
grep -rL "^title:" ./**/*.mdx

# Xem những file sẽ được commit
git diff --name-only --cached
```

---

---

## L10 — Lưu file vào đúng thư mục ngay khi tạo

**Vấn đề:** File tạo ra trong scratchpad (repo clone tạm thời) không tự xuất hiện trong thư mục workspace của anh trên NAS. Phải copy thủ công mới anh thấy được.

**Quy tắc:**
- File tài liệu, notes, lessons → `phong-docs/du-an/` (cùng chỗ với `CLAUDE_DESKTOP_MISSION.md`)
- File MDX từng phòng ban → `phong-docs/du-an/01-sales-crm/`, `02-marketing/`...
- Sau khi tạo file trong scratchpad → **copy sang workspace ngay, không để sau**

**Cấu trúc chuẩn:**
```
phong-docs/du-an/
├── BUILD_LESSONS.md              ← notes, bài học (file này)
├── CLAUDE_DESKTOP_MISSION.md     ← blueprint gốc
├── Documentation_knowledge_base.md
├── documentation.json            ← config site
├── 01-sales-crm/                 ← MDX files từng phòng
├── 02-marketing/
└── ...
```

---

*Cập nhật lần cuối: 2026-04-15 — Phong To / Claude*  
*Phòng ban đã hoàn thành: 01 — Sales & CRM ✅*

---
name: brunson-magic
description: Brunson Protocol funnel builder. Research -> Copy -> Build -> Deploy.
activation: [/brunson-magic, brunson magic]
---

# /brunson-magic

When user runs `/brunson-magic`, execute this workflow.

## 🛡️ AI RULES (PREVENTS 90% OF FAILURES)

### RULE 1: ATOMIC EDITS

- Max 10 lines per edit, max 3 replacements per multi_replace
- Verify each edit worked before making next edit

### RULE 2: PLACEHOLDER SYNTAX

- ✅ `{{VARIABLE}}` (no spaces)
- ❌ `{{ VARIABLE }}` (breaks build)
- After ANY edit: `grep '{{ ' sections/*.html`

### RULE 3: PRODUCT.CONFIG ONLY

- All copy goes in product.config, never in HTML
- Templates contain only `{{VARIABLES}}`
- build.sh does all substitution

### RULE 4: BACKUP FRAGILE FILES

```bash
cp sections/05-main-product.html sections/05-main-product.html.bak
```

### PROTECTED ZONES (DO NOT EDIT)

- `COLOR_IMAGE_MAP` data attribute
- `<!-- CRITICAL SECTION: ORDER BUMP`
- `const CONFIG =`

## CORE PRINCIPLES

1. **ZERO SKIMMING** - Read files completely (chunk if >500 lines)
2. **ZERO HALLUCINATION** - Every claim traces to research
3. **ENGAGE Headlines** - Pattern interrupts required
4. **FIBS Features** - Fear → Intrigue → Believability → Stakes

## PRE-FLIGHT

**Read `IMAGE-REQUIREMENTS.md` - SINGLE SOURCE OF TRUTH for image counts.**

```bash
bash tests/validate-images.sh
bash tests/validate-hardcoded-paths.sh
```

| Images                       | Count                             |
| ---------------------------- | --------------------------------- |
| Product                      | 6                                 |
| Testimonial                  | 18 (6 feature/secret + 12 review) |
| Founder/Comparison/OrderBump | 1 each                            |

**TOTAL: 27 images. Use existing images first. ASK before generating.**

## THE 12 PHASES

### Phase 1: Initialize

INPUT: Competitor URL + Product Name → OUTPUT: mission.json

### Phase 2A-2G: Research

| Phase | Skill                                               | Output                     |
| ----- | --------------------------------------------------- | -------------------------- |
| 2A    | `.agent/skills/brunson-scout/SKILL.md`              | market_trends.json         |
| 2B    | `.agent/skills/brunson-spy/SKILL.md`                | competitor_funnels.json    |
| 2C    | `.agent/skills/brunson-profiler/SKILL.md`           | customer_profile.json      |
| 2D    | `.agent/skills/brunson-avatar/SKILL.md`             | avatar_profile.json        |
| 2E    | `.agent/skills/brunson-mechanic/SKILL.md`           | mechanical_components.json |
| 2F    | `.agent/skills/brunson-strategist/SKILL.md`         | strategy_brief.json        |
| 2G    | `.agent/skills/antigravity-neuro-research/SKILL.md` | neuro_triggers.json        |

### Phase 3: Linguistic Mapping

SKILL: `.agent/skills/antigravity-linguist/SKILL.md`
INPUT: avatar_profile.json, strategy_brief.json
OUTPUT: linguistic_seed_map.json

### Phase 4: Copywriting

SKILL: `.agent/skills/engage-fibs-writer/SKILL.md`
INPUT: All research JSONs + linguistic_seed_map.json
OUTPUT: copy_draft.json

```bash
bash tests/validate-framework.sh  # MUST PASS
```

### Phase 5: Optimization

SKILL: `.agent/skills/brunson-perry-brain/SKILL.md`
INPUT: copy_draft.json
OUTPUT: copy_final.json

### Phase 6: Hallucination Check

SKILL 6A: `.agent/skills/antigravity-traceability/SKILL.md`
SKILL 6B: `.agent/skills/antigravity-hallucination-killer/SKILL.md`
OUTPUT: copy_provenance_report.md
**CRITICAL:** Must contain `HALLUCINATION_CHECK: PASSED`

### Phase 7: Build

SKILL: `.agent/skills/brunson-builder/SKILL.md`
ACTION: Inject copy into product.config, run ./build.sh
OUTPUT: index.html

**Step 7.1: Pre-Build Cleanup**

```bash
for f in sections/*.html product.config; do
    sed -i '' 's/{{ /{{/g; s/ }}/}}/g' "$f" 2>/dev/null
done
```

**Step 7.2: Validate**

```bash
bash tests/validate-hardcoded-paths.sh || exit 1
bash tests/validate-pre-build.sh || exit 1
```

**Step 7.3: Build**

```bash
./build.sh
```

**Step 7.4: Verify**

```bash
[ $(grep -c '{{' index.html) -eq 0 ] || exit 1
bash tests/validate-engage.sh index.html 3 || exit 1
bash tests/validate-epiphany-bridge.sh || exit 1
bash tests/validate-interactive.sh index.html || exit 1
```

**If ANY fails: Fix issue, do NOT proceed to Phase 8.**

### Phase 8: Audit

SKILL: `.agent/skills/brunson-auditor/SKILL.md`
ACTION: Loop correction until all checks pass (max 5 iterations)
TEST: `bash tests/validate-build.sh`

**Auto-Fix (ONE AT A TIME, verify after each):**
| Error | Fix |
|-------|-----|
| Spaced placeholders | `sed -i '' 's/{{ /{{/g; s/ }}/}}/g' <file>` |
| Hardcoded paths | Replace ONE path, verify, then next |
| FAQ accordion broken | `grep 'pointer-events' stylesheets/*.css` |

### Phase 9: Visual QA (🔒 HARD EXIT)

SKILL: `.agent/skills/antigravity-browser-qa/SKILL.md`
ACTION: Open index.html, capture screenshots, validate all sections
OUTPUT: local_qa_report.md

**ALL MUST PASS:**

- All images load (no 404s)
- All sections visible
- FAQ accordions work (click each, content expands)
- Color swatches work (click swatch, image changes)
- Carousel works (click arrows, images slide)
- No raw `{{VARIABLE}}` (Ctrl+F returns 0)

**If ANY fails:**

1. STOP - Do NOT proceed to Phase 10
2. Return to Phase 7, fix specific issue
3. Rebuild with ./build.sh
4. Re-run Phase 9
5. Max 5 iterations, then EXIT and ask user

### Phase 10: Deploy

SKILL: `.agent/skills/brunson-deployer/SKILL.md`
OUTPUT: Live URL
TEST: HTTP 200 response

### Phase 11: Live QA

SKILL: `.agent/skills/antigravity-live-qa/SKILL.md`
ACTION: Verify HTTPS, images load, mobile responsive
OUTPUT: live_qa_report.md

### Phase 12: Complete

OUTPUT:

- Live URL
- All artifacts committed
- Session log updated

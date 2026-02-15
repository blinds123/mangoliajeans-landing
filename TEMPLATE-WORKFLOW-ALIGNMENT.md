# Template-Workflow Alignment Summary

> **Alignment Strategy**: Option A - Template adapts to Workflow
> **Workflow Source**: `~/.gemini/antigravity/global_workflows/bulletproof-research-balanced.md`
> **Date**: 2025-01-26

---

## Changes Made

### 1. Context Files Aligned

| File                                    | Action          | Purpose                                                 |
| --------------------------------------- | --------------- | ------------------------------------------------------- |
| `context/tiktok_trending_research.json` | Created         | Template schema for TikTok research output (28% weight) |
| `context/linguistic_seed_map.json`      | Created         | Template for language pattern mapping (18% weight)      |
| `context/BUYER-RESEARCH.md`             | Created         | Template for Codex buyer research (18% weight)          |
| `context/CODEX-GESTALT.md`              | Created         | Single source of truth for all copy generation          |
| `context/competitor_analysis.json`      | Renamed         | From `competitor_funnels.json` to match workflow output |
| `context/copy_final.json`               | Renamed + Fixed | From `copy_draft.json`, fixed variable naming           |

### 2. Variable Naming Standardized

**Pattern**: `SECRET_X_HEADLINE` (number in middle position)

| Old Pattern         | New Pattern         |
| ------------------- | ------------------- |
| `SECRET_HEADLINE_1` | `SECRET_1_HEADLINE` |
| `SECRET_HEADLINE_2` | `SECRET_2_HEADLINE` |
| `SECRET_HEADLINE_3` | `SECRET_3_HEADLINE` |

### 3. UI Layout Restructured

**New Conversion Flow Order** (in `sections/05-main-product.html`):

```
1. Order Bump Section (line ~952)
   ↓ 24px margin
2. Shipping Timeline Section (line ~973)
   - Delivery urgency text
   - Day 1/2/4 dynamic dates
   ↓ 35px margin
3. Add to Cart Container (line ~1227)
   - Product form
   - Main ATC button
   ↓ 24px margin
4. Feature Icons Section (line ~1302)
   - Hero features 1-4
```

### 4. UI Standards Hardcoded

| Element                   | Value             | Notes                       |
| ------------------------- | ----------------- | --------------------------- |
| Star Color                | `#FFD700`         | Gold standard (was #ffcc00) |
| Star Rating               | `4.9`             | Default display rating      |
| ATC Margins               | `35px top/bottom` | Clear visual separation     |
| Shipping Timeline Margins | `24px top/bottom` | Consistent padding          |

---

## Critical Sync Step

**IMPORTANT**: The workflow outputs to `copy_final.json` but `build.sh` reads from `product.config`.

Run this sync script AFTER workflow completes, BEFORE build:

```bash
bash scripts/sync-copy-to-config.sh
```

This bridges the gap between:

- Workflow output: `context/copy_final.json`
- Build input: `product.config`

---

## Validation

Run the UI standards validator to confirm alignment:

```bash
bash tests/validate-ui-standards.sh
```

**Checks performed**:

1. Star rating color (#FFD700)
2. Layout order (Order Bump → Shipping → ATC → Features)
3. ATC container margins (35px)
4. Shipping timeline padding (24px)
5. No orphaned HTML tags
6. Variable naming convention (SECRET_X_HEADLINE)

---

## Research Distribution (from Workflow)

| Source                   | Weight | Output File                     |
| ------------------------ | ------ | ------------------------------- |
| TikTok Trending Research | 28%    | `tiktok_trending_research.json` |
| Competitor Analysis      | 18%    | `competitor_analysis.json`      |
| Codex Buyer Research     | 18%    | `BUYER-RESEARCH.md`             |
| Avatar Profile           | 18%    | `avatar_profile.json`           |
| Linguistic Seed Map      | 18%    | `linguistic_seed_map.json`      |

---

## Copy Frameworks Enforced

- **ENGAGE Framework** (Hero Section): Exploit → Narrate → Give → Attach → Guarantee → Execute
- **FIBS Pattern** (Features): Feature → Imagined Pain → Benefit → Specific
- **V-I-E Framework** (3 Secrets): Vehicle → Internal → External
- **Epiphany Bridge** (Founder Story): Backstory → Wall → Epiphany → Plan → Transformation

---

## Rank-Based Phrase Usage

| Rank  | Tier       | Where to Use                                                    |
| ----- | ---------- | --------------------------------------------------------------- |
| #1-3  | TOP_3      | Throughout: headline, body, features, secrets, CTA, testimonial |
| #4-7  | MID_TIER   | 3-4 sections: body, features, secrets, testimonial              |
| #8-12 | LOWER_TIER | 2 sections: most relevant fit                                   |
| #13+  | SINGLE_USE | 1 section: where it fits best                                   |

**Rule**: TOP 3 phrases MUST appear in headline + body + 2 other sections

---

## Master Template Notes

This is a **master template** designed for duplication. When duplicating:

1. Run `tests/validate-ui-standards.sh` after any modifications
2. Ensure context files are populated by workflow skills
3. Do not modify hardcoded UI standards (star color, margins)
4. Follow variable naming convention strictly

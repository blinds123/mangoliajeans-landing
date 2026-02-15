# Template Update - 2026-01-17

## Update: Atomic ENGAGE Protocol for Feature Cards

### What Changed

**New Files Added:**

1. `resources/ATOMIC-ENGAGE-PROMPT.md` (191 lines) - Complete execution protocol for feature cards
2. `tests/validate-features.sh` (159 lines) - Validation script enforcing ENGAGE 5-element framework

**Updated Files:**

1. `phases/copy-sections/section-09-features.json` - Updated from MINI_ENGAGE to ENGAGE_5_ELEMENT_FORMULA
2. `BRUNSON-PROTOCOL-V2.md` - Added Feature Cards section with protocol documentation

---

## Why This Update

**Problem:** LLMs were using condensed "Mini-ENGAGE" (2-3 sentences) instead of full 5-element ENGAGE framework for feature cards.

**Solution:** Explicit Atomic ENGAGE Protocol that enforces ALL 5 elements in EACH of the 4 feature cards:

1. **EXPLOIT** - Challenge cognitive belief
2. **NARRATE** - Touch on old way struggle
3. **GIVE** - State controversial truth
4. **ATTACH** - Highlight emotional cost
5. **GUARANTEE** - Present effortless payoff

---

## How To Use

### When Writing Feature Cards:

**Step 1: Read Required Files**

```bash
# MANDATORY - Do not skip
cat resources/ATOMIC-ENGAGE-PROMPT.md
cat context/research-summary.md  # Voice & Tone section
cat phases/copy-sections/section-09-features.json  # Objection mapping
```

**Step 2: Write 4 Feature Paragraphs**
Each paragraph must be 3-5 sentences with ALL 5 ENGAGE steps.

**Step 3: Validate**

```bash
bash tests/validate-features.sh
```

This checks:

- ✅ All 4 cards exist (MULTIROW_HEADLINE_1..4, MULTIROW_PARAGRAPH_1..4)
- ✅ No empty cards
- ✅ Word count ~40 words per card (min 20, max warn at 80)
- ✅ ALL 5 ENGAGE elements detected per card using regex
- ✅ Research context used from research-summary.md

**Exit codes:**

- `0` = PASS (proceed to build)
- `1` = FAIL (regenerate features)

---

## Variable Mapping

**CRITICAL:** Feature cards use `MULTIROW_*` variables:

```bash
# Correct ✅
MULTIROW_HEADLINE_1="THE CHEAP ZIPPER"
MULTIROW_PARAGRAPH_1="[5-step ENGAGE copy]"
MULTIROW_IMAGE_1="images/testimonials/testimonial-06.webp"

# Wrong ❌
FEATURE_IMAGE_1=...  # Deprecated
SECRET_IMAGE_1=...   # Different section (Macro Secrets)
```

---

## Validation Details

The `validate-features.sh` script uses regex patterns to detect each ENGAGE element:

### Element Detection Patterns

1. **Cognitive Disruption** - Headline patterns:
   - `THE [A-Z]` (e.g., "THE CHEAP ZIPPER")
   - `ISN'T`, `AREN'T`, `LIE`, `MYTH`, `TRUTH`, `SECRET`

2. **Unfinished Story** - "You" moments:
   - `\bYou('ve| |\b)`, `Your`

3. **Controversial Truth** - Uncomfortable facts:
   - `isn't`, `aren't`, `actually`, `really`, `truth`, `fact`, `secret`

4. **High-Stakes Conflict** - Emotional/identity language:
   - `feel`, `look`, `want`, `need`, `cheap`, `frumpy`, `basic`, `confidence`, `identity`, `frustrat`

5. **Unconventional Payoff** - Solution language:
   - `\bOur `, `This `, `finally`, `without`

**Minimum:** 4 out of 5 elements detected per card (script warns if less)

---

## Files Reference

**New Files:**

- `resources/ATOMIC-ENGAGE-PROMPT.md` - Protocol document
- `tests/validate-features.sh` - Validation script

**Updated Files:**

- `phases/copy-sections/section-09-features.json` - Configuration
- `BRUNSON-PROTOCOL-V2.md` - Documentation

**Synced To:**

- `~/.claude/ralph-templates/brunson-protocol/`
- `~/.gemini/antigravity/skills/brunson-protocol/`

Both Claude and Antigravity skills have identical implementations.

---

## Anti-Skipping Enforcement

**File Safety:**

- `ATOMIC-ENGAGE-PROMPT.md`: 191 lines (under 2000 limit, safe for single read)
- `validate-features.sh`: 159 lines (under 2000 limit, safe for single read)
- NO chunking required, NO skipping allowed

**Enforcement:**

- Script physically blocks build if validation fails
- Each card must independently have all 5 ENGAGE elements
- Research context must be referenced

---

## Example Output Format

```bash
# Feature Card 1: Hardware Quality (Vehicle Objection)
MULTIROW_HEADLINE_1="THE CHEAP ZIPPER"
MULTIROW_PARAGRAPH_1="You bought that $60 jacket thinking it was quality. Within three wears, the zipper catches and sticks. Hardware quality is where fast fashion cuts corners first. You don't want to look cheap - but cheap zippers give you away. Our YKK hardware glides for years - no catches, no cheap feel."
MULTIROW_IMAGE_1="images/testimonials/testimonial-06.webp"

# Feature Card 2: Cut/Structure (Internal Objection)
MULTIROW_HEADLINE_2="THE 'DIAPER EFFECT'"
MULTIROW_PARAGRAPH_2="[5-step ENGAGE copy with all elements]"
MULTIROW_IMAGE_2="images/testimonials/testimonial-07.webp"

# Feature Card 3: Practicality (External Objection)
MULTIROW_HEADLINE_3="THE FAKE POCKET LIE"
MULTIROW_PARAGRAPH_3="[5-step ENGAGE copy with all elements]"
MULTIROW_IMAGE_3="images/testimonials/testimonial-08.webp"

# Feature Card 4: Details (Vehicle Objection)
MULTIROW_HEADLINE_4="THE ARM SQUEEZE"
MULTIROW_PARAGRAPH_4="[5-step ENGAGE copy with all elements]"
MULTIROW_IMAGE_4="images/testimonials/testimonial-09.webp"
```

---

## Compatibility

**Template Version:** v2.0
**Skill Version:** Both Claude and Antigravity synchronized
**Date:** 2026-01-17
**Status:** ✅ Production Ready

---

**END OF UPDATE DOCUMENT**

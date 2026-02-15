---
name: brunson-protocol
description: Universal landing page generator using Russell Brunson frameworks (Big Domino, 3 Secrets, Epiphany Bridge), ENGAGE copywriting. Generates fully deployed landing pages from competitor analysis.
version: 2.0
---

# Brunson-Protocol Landing Page Generator v2.0

## When This Skill Activates

This skill activates when the user requests:

- "Build a landing page from [competitor URL]"
- "Create a brunson-protocol page"
- "Generate a sales page using Russell Brunson frameworks"

## CRITICAL: First Action (Self-Healing Injection)

**IMMEDIATELY after cloning/creating project, inject the corrected files:**

```bash
cp resources/sections/*.html sections/
cp resources/scripts/*.sh tests/
mkdir -p tests context
```

This ensures:

- Correct section structure (11, 12, 13, 13b)
- Validation scripts available in `tests/`
- Workspace folders ready

## Required Inputs

Before starting, verify the user has:

1. **Competitor URL** - Product page to analyze
2. **34 required images** organized in folders:
   - `images/product/` (6 images) - Hero carousel
   - `images/testimonials/` (25 images) - Features, Secrets, Testimonials
   - `images/order-bump/` (1 image) - Order bump product image
   - `images/founder/` (1 image) - Founder story section (can duplicate awards-1)
   - `images/comparison/` (1 image) - Combined before/after
   - `images/awards/` (5 images) - Trust badges (static)
   - `images/universal/` (2 images) - Logo + size chart (static)

## File Architecture (v2.0)

**CRITICAL: Section 17 no longer exists. Secret 3 is now 13b.**

| HTML File                   | Content Goal          | Variable Prefix         |
| :-------------------------- | :-------------------- | :---------------------- |
| `06-bridge-comparison.html` | Bridge Comparison | `COMPARISON_` |
| `07-bridge-headline.html`   | Bridge Headline   | `BRIDGE_` |
| `08-features-3-fibs.html`   | Micro Features (Grid) | `FEATURE_`, `MULTIROW_` |
| `09-founder-story.html`     | Founder Story         | `FOUNDER_`              |
| `10-secret-1.html`          | Secret 1 (Vehicle)    | `SECRET_..._1`          |
| `11-secret-2.html`          | Secret 2 (Internal)   | `SECRET_..._2`          |
| `12-secret-3.html`          | Secret 3 (External)   | `SECRET_..._3`          |
| `13-awards-carousel.html`   | Trust/Awards          | N/A                     |
| `14-faq.html`               | FAQ (Logistics)       | `FAQ_`                  |

**Psychological Flow:**

```
Founder Story (11) → Earns Trust
Secret 1 (12) → "It won't work" objection
Secret 2 (13) → "I can't do it" objection
Secret 3 (13b) → "Too expensive" objection
FAQ (14) → Cleanup remaining objections
```

## Execution Phases

Execute in order. Do NOT skip phases.

### Phase 0: Pre-Check

- **Inject resources:**
  ```bash
  cp resources/sections/*.html sections/
  cp resources/scripts/*.sh tests/
  chmod +x tests/*.sh
  ```
- Create workspace folders: `sections/`, `context/`, `tests/`
- Verify images directory exists
- Test competitor URL is accessible
- **Comparison Check:** If `images/comparison/` empty, note for config

**Validation Scripts Now Available:**

- `tests/validate-avatar.sh` - Blocks Phase 2 until avatar-profile.json complete
- `tests/validate-reading-checklist.sh` - Blocks drafting until mandatory reads confirmed
- `tests/lint-manuscript.sh` - Blocks config until manuscript has all frameworks
- `tests/validate-config.sh` - Blocks build until config rules verified
- `tests/validate-engage.sh` - Blocks deploy until pattern interrupts verified

### Phase 1: Research (CRITICAL)

- Navigate to competitor URL using browser
- Scroll entire page slowly, take screenshots
- Extract and document in `context/research-summary.md`:
  - 5+ Pain Points (exact customer language)
  - 4+ Desires (transformation outcomes)
  - 6+ Objections with answers
  - Big Domino (ONE belief shift)
  - 3 Secrets (Vehicle/Internal/External)
  - Epiphany Bridge (5 story elements)
  - Voice & Tone patterns
  - Dream Customer profile

**STOP and ask user to review research before proceeding.**

### Phase 1B: Deep Dive Avatar Research (THE PSYCHOLOGICAL LOCK)

**MANDATORY:** You must perform the deep psychological audit before writing copy.

1. **READ (Required):** `~/.claude/ralph-templates/brunson-protocol/resources/DEEP-DIVE-AVATAR.md`
   - This is NOT optional. Open and read the entire file.
   - Do NOT skip or skim sections.

2. **Execute the research prompt** from that file mentally on your competitor research.

3. **Generate Artifact:** Create `context/avatar-profile.json` with the full 7-section analysis:
   - fears_and_frustrations
   - biases_and_false_beliefs
   - jargon_and_language
   - aspirations_and_identity
   - objection_matrix
   - social_proof_triggers
   - decision_factors

4. **VALIDATION (Blocks Phase 2):**

   ```bash
   bash tests/validate-avatar.sh
   ```

   - ❌ FAIL = You CANNOT proceed to Phase 2
   - ✅ PASS = Proceed to Phase 2

### Phase 2: Copy Drafting (THE INTERMEDIATE ARTIFACT)

**CRITICAL RULE:** You are **FORBIDDEN** from writing copy directly into `product.config`.
**REASON:** Configuration files kill creativity. You must write a manuscript first.

**STEP 0: MANDATORY READS (Enforced)**

1. **READ (Required):** `context/COPY-REQUIREMENTS.md`
   - This is NOT optional. Open and read the entire file.
   - Do NOT skip the BANNED PHRASES section.
   - Do NOT skip the AI PLACEHOLDER BUGS section.

2. **IF Fashion Product - READ (Required):**
   - `~/.claude/ralph-templates/brunson-protocol/resources/ENGAGE-FASHION-GENZ.md`
   - Read ALL 60 examples across 6 ENGAGE sections.
   - Generic patterns are BANNED for fashion.

3. **Create Reading Checklist:**

   ```bash
   cat > context/reading-checklist.txt <<EOF
   [X] Read COPY-REQUIREMENTS.md
   [X] Read ENGAGE-FASHION-GENZ.md (if fashion)
   [ ] Skipped ENGAGE (not fashion product)
   EOF
   ```

4. **VALIDATION (Blocks Drafting):**

   ```bash
   bash tests/validate-reading-checklist.sh
   ```

   - ❌ FAIL = You CANNOT write manuscript
   - ✅ PASS = Proceed to drafting

**STEP 1: Create Manuscript**

- Copy template: `cp ~/.claude/ralph-templates/brunson-protocol/resources/copy-manuscript.template.md context/copy-manuscript.md`
- Fill it out completely using `context/research-summary.md` as source.

2. **Self-Correction (The Ralph Loop):**
   - Review your `copy-manuscript.md`.
   - **Check Headlines:** Does every headline use an ENGAGE pattern? (Question, Contradiction, Confession, etc.)
   - **Check Story:** Does the Epiphany Bridge follow the 5-step narrative arc?
   - **Check Secrets:** Do they address Objections (Vehicle/Internal/External)?

3. **Validation:**
   - Only proceed if the manuscript is "Editor Approved" by your own internal critique.

### Phase 3: Configuration (Mapping)

1. **Map Manuscript to Config:**
   - NOW you may open `product.config`.
   - Copy/Paste your polished text from `context/copy-manuscript.md` into the variables.
   - **DO NOT** rewrite or "summarize" while pasting. Move the exact text.

2. **CRITICAL: Place these at TOP of product.config:**
   - All `FOUNDER_` variables
   - All `SLIDESHOW_` variables
   - All `CTA_` variables
3. **HARDCODED VALUES (DO NOT CHANGE):**
   - `SINGLE_PRICE=19`
   - `ORDER_BUMP_PRICE=10`
   - `ORDER_BUMP_PRECHECKED=true`

4. **BANNED MAPPINGS (Nano Banana Protocol):**
   - **NEVER** map `images/testimonials/*` to `SLIDESHOW_IMAGE_1` (Sec 15a) or `SLIDESHOW_IMAGE_2` (Sec 16).
   - These variables must remain **BLANK** or mapped to a temporary placeholder (e.g., `images/placeholder.png`) until the Visual Architect generates the specific Copy-Dependent Nano Image.

### Phase 4: multi-Stage Validation (The Defense-in-Depth)

**Layer 1: The Manuscript Linter (Pre-Config)**

- **Action:** Run `bash tests/lint-manuscript.sh context/copy-manuscript.md`
- **Check:** Verifies all 3 Secrets are filled, Epiphany Bridge has 5 steps, and Big Domino exists.
- **Enforcement:** You CANNOT open `product.config` until this passes.

**Layer 2: The Config Validator (Pre-Build)**

- **Action:** Run `bash tests/validate-config.sh`
- **Check:** Verifies critical variables (PRICE, GUARANTEE) match hardcoded values.
- **Enforcement:** `build.sh` will auto-abort if variables are suspect.

**Layer 3: The Image Source Validator (Pre-Build)**

- **Action:** Run `bash tests/validate-images-source.sh`
- **Check:** Enforces "UGC/Testimonial" images for feature cards (MULTIROW*IMAGE*\*). Secrets are allowed to use product images.
- **Enforcement:** `build.sh` will auto-abort if feature cards use product images instead of testimonials.

### Phase 5: Build & Deploy

- Run: `bash build.sh`
- **Layer 3: The HTML Validator (Post-Build)**
  - **Action:** `bash tests/validate-engage.sh index.html 3`
  - **Check:** Greps the final HTML for specific Hook patterns.
- Verify zero unfilled placeholders
- Deploy to Netlify

### Phase 6: Browser Testing

Test in **mobile viewport 375x667**:

- Page loads without errors
- All images load (zero 404s)
- Zero console errors
- Mobile responsive (no horizontal scroll)
- Add to Cart functional
- Order bump is pre-checked

## Russell Brunson Frameworks

### Big Domino

The ONE belief that makes everything else fall into place.

- Format: "The problem isn't X, it's Y"
- If they believe THIS, they buy

### 3 Secrets

1. **Vehicle (Secret 1)** - Why other products failed them
2. **Internal (Secret 2)** - Why it's not their fault
3. **External (Secret 3)** - What external factors held them back

### Epiphany Bridge

Founder story with 5 elements. **DO NOT label these explicitly in copy:**

1. Backstory - Same problem as customer
2. Wall - What they tried that failed
3. Epiphany - The "aha" moment
4. Plan - How product was born
5. Transformation - Result achieved

**CRITICAL:** The framework guides your THINKING, not your WRITING. Never write "The Backstory:" or "THE EPIPHANY:" - let the narrative flow naturally.

## BANNED - AI Placeholder Bugs

**NEVER write these:**

- `$00` or `00 designer` → Use REAL prices like `$600`
- `XX months` or `XX%` → Use REAL numbers from research
- `[amount]` or `[number]` → Fill in with actual data
- `The Backstory:` or `THE EPIPHANY:` → NO framework labels
- `The Result:` or `The Plan:` → Framework is INVISIBLE

## Variable Collision Prevention

**STRICTLY ENFORCE:**

- **Micro Grid (08)** uses `MULTIROW_IMAGE_1..4` (File: `sections/08-features-3-fibs.html`)
- **Macro Secrets (10, 11, 12)** use `SECRET_IMAGE_1..3` (Files: `10-secret-1`, `11-secret-2`, `12-secret-3`)
- **DO NOT** use generic `FEATURE_IMAGE` for secrets

## ENGAGE Framework (Perry Belcher)

**CRITICAL FOR FASHION/APPAREL:**
If the product is fashion (clothing, shoes, accessories), you are **MANDATED** to use the specialized training manual:
`~/.claude/ralph-templates/brunson-protocol/resources/ENGAGE-FASHION-GENZ.md`

**You must READ and APPLY the 6-step Fashion Formula from that file:**

1. **E** - Exploit Cognitive Disruption
2. **N** - Narrate an Unfinished Story
3. **G** - Give a Controversial Truth
4. **A** - Attach High-Stakes Personal Conflict
5. **G** - Guarantee Unconventional Payoff
6. **E** - Embed Time-Locked Curiosity

**CRITICAL FOR FEATURE CARDS (Micro-Hooks):**
You MUST use the **ENGAG (5-Step) Framework** for all feature body copy.

- **Structure:** Exploit -> Narrate -> Give Truth -> Attach -> Guarantee.
- **Length:** Single paragraph, 3-5 sentences.
- **Reference:** `~/.gemini/antigravity/skills/brunson-protocol/resources/ENGAG-FEATURE-FRAMEWORK.md`

**For General Products (Default 8 Pattern Interrupts):**

| Type             | Example                                       |
| :--------------- | :-------------------------------------------- |
| Question         | "What if everything you knew was wrong?"      |
| Contradiction    | "Everyone says X. They're wrong."             |
| Shocking Stat    | "97% of women saw results in 30 days"         |
| Unexpected Claim | "You don't need [expected solution]"          |
| Reader Callout   | "If you're reading this, you already know..." |
| Confession       | "Here's what nobody talks about..."           |
| Time Travel      | "Imagine 30 days from now..."                 |
| Permission       | "It's okay to want this for yourself"         |

### Strict ENGAGE Feature Loop (E-N-G-A)
**CRITICAL:** In the `product.config` and build system, "Feature Cards" correspond to the `MULTIROW_` variables.

**REQUIREMENT 1: The Headline Hook (Pattern Check)**
The `FEATURE_HEADLINE_X` MUST be a **Pattern Interrupt Hook** (3-5 words) derived from the **Exploit** phase.
The system will **mechanically FAIL** any headline that does not contain one of these Cognitive Disruption Markers:
- **THE [X]**: "The Comfort Lie", "The Fast Fashion Scam"
- **WHY [X]**: "Why Beauty Isn't Pain", "Why You're Tired"
- **STOP [X]**: "Stop The Slouch", "Stop Buying Trash"
- **MYTH / LIE / SECRET / TRUTH**: "The Zero Itch Myth"
- **ISN'T / AREN'T / DON'T**: "This Isn't What You Think"
- **VS / AGAINST**: "Silk vs. Synthetics"

*Forbidden:* Single labels like "Comfort", "Durability", "Fit".

**REQUIREMENT 2: The E-N-G-A Body Loop**
**EACH MULTIROW FEATURE CARD must independently cycle through the 4 steps of ENGAGE (E-N-G-A) within its own paragraph.**

**The 4-Step Loop (Must exist in every `MULTIROW_X_PARAGRAPH`):**
1. **Exploit** (Attack a specific belief/enemy. MUST be the first sentence.)
2. **Narrate** ( vivid sensory details of the 'old way' struggle/pain.)
3. **Give** (The specific mechanism/solution. "We use X...")
4. **Attach** (The Identity Upgrade. Who they become. Replacing the Guarantee.)

*Constraint: Do NOT include a generic money-back guarantee sentence. Use the Identity Attachment as the close.*

## Reference Files

- `resources/sections/` - Self-healing HTML sections (11, 12, 13, 13b)
- `references/COPY-REQUIREMENTS.md` - Mandatory copy rules
- `references/research-summary.template.md` - Phase 1 template

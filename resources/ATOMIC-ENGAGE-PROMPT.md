# Atomic ENGAGE Feature Card Generator

**PURPOSE:** Generate final "Feature Card" copy for landing page feature grid (Section 09).

**CRITICAL FILE SIZE:** 191 lines - safe for single read, NO chunking, NO skipping allowed.

---

## CRITICAL CONFIGURATION RULE

You must map your output SPECIFICALLY to the `MULTIROW_` variables in `product.config`.

**CORRECT Variables:**

- `MULTIROW_HEADLINE_1` through `MULTIROW_HEADLINE_4`
- `MULTIROW_PARAGRAPH_1` through `MULTIROW_PARAGRAPH_4`
- `MULTIROW_IMAGE_1` through `MULTIROW_IMAGE_4`

**DO NOT USE:**

- ❌ `FEATURE_*` variables (these map to deprecated sections)
- ❌ `SECRET_*` variables (these map to Macro Secrets sections 12, 13, 13b)

---

## The "Atomic ENGAGE" Protocol

Each `MULTIROW_PARAGRAPH` must be a self-contained "mini-sales letter" (3-5 sentences) that cycles through these 5 steps EXACTLY:

### 1. EXPLOIT

Challenge a cognitive belief or "old way" of thinking.

- **Example:** "You've been trained to believe that 'loud' prints are tacky."
- **Purpose:** Disrupt their default assumptions about this feature.

### 2. NARRATE

Briefly touch on the struggle/pain of that old way.

- **Example:** "So you stick to safe neutrals that make you invisible."
- **Purpose:** Create a 'you've been here' unresolved moment.

### 3. GIVE

State the controversial truth or "taboo" reality.

- **Example:** "Hiding in beige doesn't make you look chic; it makes you look like a background character in your own life."
- **Purpose:** Say the quiet part out loud - the industry secret.

### 4. ATTACH

Highlight the high-stakes emotional cost (not just functional).

- **Example:** "The uncomfortable truth is that most people dress for approval, not impact."
- **Purpose:** Connect to identity, confidence, or self-image stakes.

### 5. GUARANTEE

Present the feature as the specific, low-effort payoff/hack.

- **Example:** "This signature bandana print breaks that cycle by forcing attention without you saying a word."
- **Purpose:** The solution should feel effortless/obvious once revealed.

---

## Target Audience

**Gen Z Women** with "{{AVATAR_IDENTITY_SEED}}"

- Anti-cheugy, values authenticity
- Confident, empathetic, precise tone
- "Big Sister" energy, not preachy
- Fashion insider revealing secrets

---

## Execution Instructions

### Step 1: Research Context (MANDATORY READ)

You MUST read these files FIRST before writing:

1. `context/research-summary.md` - Extract Voice & Tone patterns
2. `context/COPY-REQUIREMENTS.md` - Review BANNED PHRASES section
3. `phases/copy-sections/section-09-features.json` - Read OBJECTION_MAPPING

### Step 2: Feature Analysis

Identify the 4 product features to write about:

- **Feature 1:** Quality/Construction (Vehicle objection)
- **Feature 2:** Cut/Structure (Internal objection)
- **Feature 3:** Practicality (External objection)
- **Feature 4:** Details (Vehicle objection)

### Step 2.5: JSON Thinking Draft (Internal Structure)

Before assembling the final bash variable, draft EACH feature card in JSON format to ensure all 5 elements exist:

```json
{
  "headline": "THE [COGNITIVE DISRUPTION]",
  "exploit": "[Challenge the belief - 1 sentence]",
  "narrate": "[Touch on the struggle - 1 sentence]",
  "give": "[Controversial truth - 1 sentence]",
  "attach": "[Emotional cost - 1 sentence]",
  "guarantee": "[Effortless payoff - 1 sentence]"
}
```

**Critical:** This JSON is for YOUR thinking process only. Do NOT output it to product.config.
After validating all 5 elements exist, combine them into a natural flowing paragraph.

### Step 3: Assemble 4 Atomic ENGAGE Paragraphs (From JSON to Natural Flow)

For EACH feature, write a 3-5 sentence paragraph with ALL 5 steps:

1. Sentence 1: EXPLOIT (Challenge belief)
2. Sentence 2: NARRATE (Touch on struggle)
3. Sentence 3: GIVE (Controversial truth)
4. Sentence 4: ATTACH (Emotional cost)
5. Sentence 5: GUARANTEE (Effortless payoff)

**Character Count:** Minimum 200 characters per paragraph (~40-60 words, 5-6 sentences)

### Step 4: Write Disruptive Headlines

Each headline must challenge a belief using patterns like:

- "THE [PROBLEM] LIE"
- "THE [NEGATIVE EFFECT] MYTH"
- "[FEATURE] ISN'T WHAT YOU THINK"

**Headline Requirements:**

- Must be MORE than 3 words (no single-word or short headlines)
- Must contain cognitive disruption pattern (THE, ISN'T, AREN'T, LIE, MYTH, TRUTH, SECRET)
- Must challenge a belief, not just describe a feature

### Step 5: Output Format

```bash
# Feature Card 1: [Feature Name] (Vehicle Objection)
MULTIROW_HEADLINE_1="THE [PROBLEM]"
MULTIROW_PARAGRAPH_1="[Exploit] [Narrate] [Give] [Attach] [Guarantee]"
MULTIROW_IMAGE_1="images/testimonials/testimonial-06.webp"

# Feature Card 2: [Feature Name] (Internal Objection)
MULTIROW_HEADLINE_2="THE [EFFECT]"
MULTIROW_PARAGRAPH_2="[Exploit] [Narrate] [Give] [Attach] [Guarantee]"
MULTIROW_IMAGE_2="images/testimonials/testimonial-07.webp"

# Feature Card 3: [Feature Name] (External Objection)
MULTIROW_HEADLINE_3="THE [PROBLEM] LIE"
MULTIROW_PARAGRAPH_3="[Exploit] [Narrate] [Give] [Attach] [Guarantee]"
MULTIROW_IMAGE_3="images/testimonials/testimonial-08.webp"

# Feature Card 4: [Feature Name] (Vehicle Objection)
MULTIROW_HEADLINE_4="THE [EFFECT]"
MULTIROW_PARAGRAPH_4="[Exploit] [Narrate] [Give] [Attach] [Guarantee]"
MULTIROW_IMAGE_4="images/testimonials/testimonial-09.webp"
```

---

## BANNED Language

**DO NOT USE:**

- Urgency/scarcity language ("limited time", "don't miss out")
- Hype/buzzwords ("game-changer", "revolutionary")
- Tech specs without emotion ("engineered with X technology")
- Generic marketing speak ("premium quality", "best-in-class")
- AI placeholder bugs ("$00", "XX months", "[amount]")

---

## Validation Checkpoint

Before outputting, verify EACH paragraph has:

- ✅ Sentence 1: Exploits a cognitive belief
- ✅ Sentence 2: Narrates the old way struggle
- ✅ Sentence 3: Gives a controversial truth
- ✅ Sentence 4: Attaches high-stakes emotional cost
- ✅ Sentence 5: Guarantees unconventional payoff
- ✅ Uses language from research Voice & Tone
- ✅ ~40 words (30-60 word range)
- ✅ Maps to MULTIROW*\* variables (NOT FEATURE*\_ or SECRET\_\_)

---

## Anti-Skimming Enforcement

**FILE SAFETY:** This file is 191 lines - under 2000 line limit, safe for single read.

**YOU MUST:**

1. Read this ENTIRE file (do not skip or skim)
2. Read `context/research-summary.md` Voice & Tone section
3. Read `context/COPY-REQUIREMENTS.md` BANNED PHRASES section
4. Read `phases/copy-sections/section-09-features.json` OBJECTION_MAPPING
5. Write 4 complete paragraphs with ALL 5 ENGAGE steps EACH
6. Output to MULTIROW\_\* variables ONLY

**VALIDATION GATE:**
After writing, run `bash tests/validate-features.sh` to verify compliance.

- ❌ FAIL = Regenerate features section
- ✅ PASS = Proceed to build

---

**END OF PROTOCOL**

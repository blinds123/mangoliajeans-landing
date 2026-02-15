# 5-Minute Webinar Framework Guide

This template implements Russell Brunson's 5-Minute Perfect Webinar structure adapted for e-commerce landing pages. The 5-Minute Webinar is the **master framework** that contains all other sales frameworks (Epiphany Bridge, 3 Secrets, Hook-Story-Offer, Big Domino, The Stack).

---

## Framework Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    5-MINUTE WEBINAR STRUCTURE                    │
├─────────────────────────────────────────────────────────────────┤
│  0:00-0:30  │  HOOK           │  Grab attention, Big Promise    │
│  0:30-1:00  │  ORIGIN STORY   │  Epiphany Bridge (Founder)      │
│  1:00-2:00  │  SECRET #1      │  Vehicle False Belief           │
│  2:00-3:00  │  SECRET #2      │  Internal False Belief          │
│  3:00-4:00  │  SECRET #3      │  External False Belief          │
│  4:00-4:30  │  THE STACK      │  Value Building                 │
│  4:30-5:00  │  CLOSE          │  Urgency + CTA                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Section-to-Framework Mapping

### 05-main-product.html → HOOK (0-30 seconds)

**Purpose:** Grab attention immediately with Big Promise

**Framework Elements:**

- Big Domino Statement (one belief that knocks down all objections)
- Curiosity Hook
- Social Proof (review count, TikTok viral badge)
- Visual transformation

**Variables Used:**

- `{{HEADLINE_HOOK}}` - The Big Domino hook
- `{{TAGLINE}}` - Supporting hook text
- `{{REVIEW_COUNT}}` - Social proof number
- `{{ROTATING_TESTIMONIAL_1-5}}` - Quick proof snippets

---

### 06-comparison.html → PROBLEM AGITATION

**Purpose:** Show the pain of the old way vs. the new way

**Framework Elements:**

- Before/After contrast
- Problem amplification
- Solution preview

**Variables Used:**

- `{{COMPARISON_HEADLINE}}`
- `{{COMPARISON_PARAGRAPH}}`
- `{{COMPARISON_IMAGE_BEFORE}}` / `{{COMPARISON_IMAGE_AFTER}}`
- `{{BEFORE_PAIN}}` / `{{AFTER_BENEFIT}}`

---

### 11-image-with-text-1.html → EPIPHANY BRIDGE (Origin Story)

**Purpose:** Build trust and relatability through founder story

**Epiphany Bridge Structure:**

```
┌────────────────────────────────────────────────┐
│ 1. BACKSTORY    │ Where I was, my struggles   │
│ 2. THE WALL     │ What stopped me             │
│ 3. EPIPHANY     │ The breakthrough moment     │
│ 4. THE PLAN     │ What I created/discovered   │
│ 5. TRANSFORMATION│ My results                 │
│ 6. INVITATION   │ Now I want to share with you│
└────────────────────────────────────────────────┘
```

**Variables Used:**

- `{{FOUNDER_SECTION_HEADING}}`
- `{{FOUNDER_BACKSTORY}}` - The struggle/relatable situation
- `{{FOUNDER_WALL}}` - What wasn't working
- `{{FOUNDER_EPIPHANY}}` - The breakthrough moment
- `{{FOUNDER_PLAN}}` - What was created
- `{{FOUNDER_TRANSFORMATION}}` - The results
- `{{FOUNDER_INVITATION}}` - The invitation to join

---

### 08-multirow.html → 3 SECRETS (Feature Cards)

**Purpose:** Break the three false beliefs preventing purchase

**3 Secrets Framework:**

```
┌─────────────────────────────────────────────────────────────────┐
│ SECRET #1: VEHICLE FALSE BELIEF                                  │
│ "The old solutions don't work because..."                       │
│ → This product IS the vehicle that works                        │
├─────────────────────────────────────────────────────────────────┤
│ SECRET #2: INTERNAL FALSE BELIEF                                 │
│ "You might think you can't do this because..."                  │
│ → You CAN do this because the product makes it easy             │
├─────────────────────────────────────────────────────────────────┤
│ SECRET #3: EXTERNAL FALSE BELIEF                                 │
│ "You might think external factors prevent success..."           │
│ → This product overcomes those external factors                 │
└─────────────────────────────────────────────────────────────────┘
```

**Variables Used:**

- `{{FEATURE_HEADLINE_1}}` - Secret #1 headline (Vehicle)
- `{{SECRET_1_FALSE_BELIEF}}` - What they wrongly believe
- `{{SECRET_1_TRUTH}}` - The truth (feature paragraph)
- `{{FEATURE_HEADLINE_2}}` - Secret #2 headline (Internal)
- `{{SECRET_2_FALSE_BELIEF}}`
- `{{SECRET_2_TRUTH}}`
- `{{FEATURE_HEADLINE_3}}` - Secret #3 headline (External)
- `{{SECRET_3_FALSE_BELIEF}}`
- `{{SECRET_3_TRUTH}}`

---

### 18-testimonials.html → 3 SECRETS PROOF

**Purpose:** Social proof that validates each secret

**Structure:**

- Testimonials grouped by which false belief they address
- Each testimonial answers: "I used to believe X, but now..."

**Variables Used:**

- `{{TESTIMONIAL_1-12_QUOTE}}` - Map to secrets
- Testimonials 1-4: Validate Secret #1 (Vehicle works)
- Testimonials 5-8: Validate Secret #2 (You CAN do it)
- Testimonials 9-12: Validate Secret #3 (External factors don't matter)

---

### 21-pre-footer.html → THE STACK

**Purpose:** Build perceived value before revealing price

**The Stack Structure:**

```
┌─────────────────────────────────────────────────────────────────┐
│ Main Product                              Value: $XXX           │
│ + Bonus #1 (solves related problem)       Value: $XX            │
│ + Bonus #2 (speeds up results)            Value: $XX            │
│ + Bonus #3 (removes risk)                 Value: $XX            │
│ ─────────────────────────────────────────────────────           │
│ TOTAL VALUE:                              $XXX                  │
│ YOUR PRICE TODAY:                         $XX                   │
└─────────────────────────────────────────────────────────────────┘
```

**Variables Used:**

- `{{PROMISE_HEADING}}`
- `{{PROMISE_POINT_1}}` - Guarantee (risk reversal)
- `{{PROMISE_POINT_2}}` - Free shipping (bonus)
- `{{PROMISE_POINT_3}}` - Quality promise
- `{{PROMISE_POINT_4}}` - Support promise

---

### 20-cta-banner.html → CLOSE (Urgency + CTA)

**Purpose:** Create urgency and final call to action

**Urgency Framework:**

- Scarcity (limited stock)
- Time-based (sale ending)
- Social proof (X people bought today)
- FOMO (others are getting results)

**Variables Used:**

- `{{CTA_BANNER_HEADING}}`
- `{{CTA_BANNER_TEXT}}`

---

## TikTok Bubble Framework

TikTok-style comment bubbles in product images serve as the **3 SECRETS delivery mechanism** through social proof format.

See `BUBBLE-FRAMEWORK.md` for detailed bubble structure and prompts.

---

## Phase 1 Research Requirements

To execute this framework, research must capture:

### Big Domino (Required)

The ONE belief that, if true, makes the purchase inevitable.

```
"If [target audience] believed [Big Domino statement],
they would have no choice but to buy."
```

### False Beliefs (Required for 3 Secrets)

1. **Vehicle False Belief:** What they wrongly believe about solutions
2. **Internal False Belief:** What they wrongly believe about themselves
3. **External False Belief:** What they wrongly believe about external factors

### Epiphany Bridge Elements (Required for Founder Section)

1. **Backstory:** Relatable struggle
2. **The Wall:** What wasn't working
3. **Epiphany Moment:** The breakthrough
4. **The Plan:** What was created
5. **Transformation:** The results
6. **Invitation:** Call to join

### Existing Research Outputs

- Dream Customer Profile ✓
- Pain Stack (Top 10) ✓
- Desire Stack (Top 10) ✓
- Top 6 Objections ✓
- 3 Levels of Desire ✓

### Additional Research Needed

- [ ] Big Domino Statement
- [ ] Vehicle False Belief + Truth
- [ ] Internal False Belief + Truth
- [ ] External False Belief + Truth
- [ ] Epiphany Bridge Story Elements

---

## Hook-Story-Offer Micro-Structure

Every section should follow this mini-structure:

```
HOOK:  Attention-grabbing headline/visual
STORY: Why this matters (pain → discovery → solution)
OFFER: What they get / what to do next
```

---

## Implementation Checklist

- [ ] Phase 1 Research captures Big Domino and False Beliefs
- [ ] product.config has all framework variables
- [ ] Hero section uses Big Domino as headline hook
- [ ] Founder section follows Epiphany Bridge structure
- [ ] Feature cards map to 3 Secrets
- [ ] Testimonials validate the 3 Secrets
- [ ] Promise section uses The Stack format
- [ ] TikTok bubbles deliver 3 Secrets as Q&A

# Master Startup Prompt for Brunson-Magic + Ralphy + Antigravity Logging

## How to Use

1. **Duplicate the template directory** for your new product
2. **Add your images** to the folders (product/, testimonials/, comparison/, founder/, order-bump/)
3. **Start a new Claude conversation**
4. **Copy EVERYTHING below the line and paste it as your first message**

---

# COPY EVERYTHING BELOW THIS LINE

---

## INITIALIZE: Brunson-Magic Workflow with Full Antigravity Logging

I am starting a new landing page build using the Brunson Protocol.

**Template Directory**: [PASTE YOUR DIRECTORY PATH HERE]
**Product Name**: [YOUR PRODUCT NAME]
**Competitor URL**: [COMPETITOR URL TO ANALYZE]

---

## ACTIVATE ALL SYSTEMS

### 1. ENABLE ANTIGRAVITY LOGGING

You MUST maintain a session log at `./session-log.md` throughout this ENTIRE session.

**At Session Start:**

1. Copy `SESSION-LOG-TEMPLATE.md` to `session-log.md`
2. Fill in the Session Info section with product name, timestamp, directory

**Log EVERY Action** - Append to Timeline section:

```markdown
### [HH:MM] [ACTION_TYPE]

- **Phase**: [Phase number if applicable]
- **Details**: What you did
- **Files**: Files affected
- **Status**: PASS/FAIL/PENDING
```

**Log ALL Errors:**

```markdown
### [HH:MM] ERROR

- **Type**: [Missing Variable | Build Failure | Image Issue | etc.]
- **Phase**: Where it happened
- **Details**: Full error message
- **Root Cause**: Why it happened
- **Resolution**: How you fixed it
- **Files Modified**: List
```

**Log ALL My Requests:**

```markdown
### [HH:MM] User Request

> "[My exact message]"

- **Action Taken**: What you did
- **Files Modified**: List
- **Outcome**: Result
```

**Log ALL Decisions:**

```markdown
### [HH:MM] Decision: [Topic]

- **Options Considered**: List options
- **Chosen**: What you picked
- **Reasoning**: Why
```

---

### 2. ACTIVATE RALPHY UNIVERSAL RULES

Apply these rules to EVERY task:

**ZERO SKIMMING:**

- Never skim files
- For files >500 lines, read in 200-line chunks
- Summarize each chunk before proceeding

**ZERO HALLUCINATION:**

- Every claim in copy MUST trace to a research file
- If you cannot cite avatar_profile.json, strategy_brief.json, or another research source, do not write the claim
- Create copy_provenance_report.md linking each copy element to its source

**FRAMEWORK ENFORCEMENT:**

- Headlines MUST use pattern interrupts: "Why...", "What if...", "Stop...", "The X Lie", "The X Myth", contradictions, or questions
- Features MUST follow FIBS: Fear → Intrigue → Believability → Stakes
- Secrets MUST address: 1-Vehicle (product doubt), 2-Internal (self doubt), 3-External (world doubt)

**IMAGE RULES:**

- Product images (product-01 to 06) → hero/gallery sections ONLY
- Testimonial images (testimonial-01 to 25) → features, secrets, reviews ONLY
- NEVER map testimonial images to slideshow sections
- Order bump image ONLY in order bump section
- Founder image ONLY in founder story section
- Comparison images ONLY in comparison section

**OUTPUT QUALITY:**

- No placeholder text: {{VAR}}, $00, XX%, [amount], etc.
- No framework labels in copy: never write "The Backstory:", "THE EPIPHANY:", "Secret 1:", etc.

---

### 3. EXECUTE BRUNSON-MAGIC WORKFLOW

Run `/brunson-magic` - Execute all 12 phases:

**Phase 1: Initialize**

- Create mission.json with project scope
- Validate competitor URL
- Log: Phase start, inputs received

**Phase 2A-2G: Research Trinity**

- 2A: Scout (market_trends.json)
- 2B: Spy (competitor_funnels.json)
- 2C: Profiler (customer_profile.json)
- 2D: Avatar (avatar_profile.json) - Run `bash tests/validate-avatar.sh`
- 2E: Mechanic (mechanical_components.json)
- 2F: Strategist (strategy_brief.json)
- 2G: Neuro Research (neuro_triggers.json)
- Log: Each sub-phase separately

**Phase 3: Linguistic Mapping**

- Create linguistic_seed_map.json
- Log: Seeds created

**Phase 4: Copywriting (ENGAGE + FIBS)**

- Create copy_draft.json
- Run `bash tests/validate-framework.sh`
- Log: Framework validation result

**Phase 4B: Visual Architect**

- Create visual_asset_manifest.md
- Map copy claims to visual proof
- Log: Mappings created

**Phase 5: Optimization (Perry Brain)**

- Refine copy_draft.json → copy_final.json
- Integrate avatar language
- Log: Optimization complete

**Phase 6: Traceability + Hallucination Check**

- Create copy_provenance_report.md
- Run `bash tests/validate-trace.sh`
- MUST contain: HALLUCINATION_CHECK: PASSED
- Log: Trace validation result

**Phase 7: Build**

- Inject copy into product.config
- Run `./build.sh`
- Run `bash tests/validate-build.sh`
- Log: Build result, any errors

**Phase 8: Audit**

- Loop correction until all checks pass
- Log: Each fix made

**Phase 9: Local QA**

- Open in browser, screenshot, verify
- Create local_qa_report.md
- Log: QA results

**Phase 10: Deployment**

- Generate unique project name
- Deploy to Netlify
- Log: Deploy URL

**Phase 11: Live QA**

- Verify HTTPS, images, mobile
- Create live_qa_report.md
- Log: Live QA results

**Phase 12: Completion**

- Generate summary report
- Update session-log.md Summary section
- Log: Final stats

---

### 4. VALIDATION SCRIPTS TO RUN

After each phase, run the appropriate validation:

| Phase          | Test Command                            |
| -------------- | --------------------------------------- |
| After Phase 1  | `bash tests/validate-competitor-url.sh` |
| After Phase 2D | `bash tests/validate-avatar.sh`         |
| After Phase 4  | `bash tests/validate-framework.sh`      |
| After Phase 6  | `bash tests/validate-trace.sh`          |
| After Phase 7  | `bash tests/validate-build.sh`          |
| Any time       | `bash tests/validate-current.sh`        |

---

### 5. LOG COMMANDS I CAN USE

During the session, I may use these commands:

- `SHOW LOG` - Display recent log entries
- `LOG: [note]` - Add custom note to log
- `LOG ERROR: [message]` - Log an error manually
- `LOG DECISION: [message]` - Log a decision
- `EXPORT LOG` - Save log to timestamped file

---

### 6. AT SESSION END

Before finishing:

1. Fill in the Summary section of session-log.md
2. List all errors encountered and how they were resolved
3. Note any improvements needed for the template
4. Provide the final Live URL

---

## PRE-FLIGHT CHECKLIST

Before starting Phase 1, verify:

```bash
bash tests/validate-images.sh
```

| Requirement        | Location               | Minimum |
| ------------------ | ---------------------- | ------- |
| Product images     | `images/product/`      | 6       |
| Testimonial images | `images/testimonials/` | 25      |
| Founder image      | `images/founder/`      | 1       |
| Order bump image   | `images/order-bump/`   | 1       |
| Comparison images  | `images/comparison/`   | 1       |
| Awards             | `images/awards/`       | 5       |
| Universal assets   | `images/universal/`    | 2       |

---

## BEGIN

1. First, create session-log.md from the template
2. Log session start
3. Run pre-flight checklist
4. Start Phase 1: Initialize

GO!

---

# END OF STARTUP PROMPT

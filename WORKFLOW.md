# Ralphy-Antigravity Unified Workflow

> **One command. Automated quality. Deployed landing page.**

---

## Quick Start

```bash
# 1. Install Ralphy (one-time)
npm install -g ralphy

# 2. Edit brunson-prd.md with your product details
# Replace {{PRODUCT_NAME}} and {{COMPETITOR_URL}}

# 3. Run
ralphy --prd ./brunson-prd.md --engine claude-code --test

# 4. Come back to deployed page
```

---

## What You Need Before Starting

| Requirement        | Location               | Count         |
| ------------------ | ---------------------- | ------------- |
| Product images     | `images/product/`      | 6 (required)  |
| Testimonial images | `images/testimonials/` | 25 (required) |
| Founder image      | `images/founder/`      | 1             |
| Order bump image   | `images/order-bump/`   | 1             |
| Comparison images  | `images/comparison/`   | 1 (required)  |
| Awards             | `images/awards/`       | 5 (static)    |
| Universal assets   | `images/universal/`    | 2 (static)    |
| Competitor URL     | Your research          | 1             |

---

## How It Works

```
INPUT                    RALPHY LOOP                    OUTPUT
─────                    ───────────                    ──────
• Competitor URL    →    For each PRD task:        →   • Deployed page
• Product name           1. Read skill file            • All artifacts
• Images                 2. Execute with Claude        • Git history
                         3. Run validation             • QA reports
                         4. Mark [x], commit
                         5. Next task
```

---

## The 14 Phases (Automated)

| #    | Phase         | Output                      | Validation            |
| ---- | ------------- | --------------------------- | --------------------- |
| 1    | Initialize    | `mission.json`              | Images exist          |
| 2A-G | Research      | `*.json` files              | Avatar has 7 sections |
| 3    | Linguistic    | `linguistic_seed_map.json`  | Seeds defined         |
| 4    | Copywriting   | `copy_draft.json`           | ENGAGE/FIBS/Secrets   |
| 4B   | Visual        | `visual_asset_manifest.md`  | Claims mapped         |
| 5    | Optimize      | `copy_final.json`           | Avatar language used  |
| 6    | Traceability  | `copy_provenance_report.md` | No hallucinations     |
| 7    | Build         | `index.html`                | No placeholders       |
| 8    | Audit         | Pass/Fail                   | All checks green      |
| 8.5  | Accessibility | `a11y_report.md`            | Alt text, labels      |
| 9    | Local QA      | `local_qa_report.md`        | Renders correctly     |
| 10   | Deploy        | Live URL                    | HTTP 200              |
| 11   | Live QA       | `live_qa_report.md`         | HTTPS, images load    |
| 12   | Complete      | Summary                     | All passed            |

---

## Validation Scripts

| Script                       | Checks                                            |
| ---------------------------- | ------------------------------------------------- |
| `validate-images.sh`         | Folders exist, counts correct, no banned mappings |
| `validate-avatar.sh`         | 7 psychological sections present                  |
| `validate-framework.sh`      | ENGAGE patterns, FIBS structure, 3 Secrets        |
| `validate-trace.sh`          | Provenance report, HALLUCINATION_CHECK passed     |
| `validate-build.sh`          | No placeholders, valid HTML, CTAs present         |
| `validate-current.sh`        | Meta-validator (runs appropriate checks)          |
| `validate-accessibility.sh`  | Alt text, form labels, heading hierarchy          |
| `validate-e2e-order-flow.sh` | CTA buttons, order bump, checkout                 |
| `browser-test-runner.sh`     | Master browser test orchestration                 |

### Browser QA Skill

The `antigravity-browser-qa` skill provides automated browser-based quality assurance testing. It orchestrates the validation scripts above and performs visual regression testing, accessibility audits, and end-to-end order flow verification using headless browser automation.

---

## Universal Rules (Applied to Every Task)

From `.ralphy/config.yaml`:

1. **Zero Skimming** - Read files completely
2. **Zero Hallucination** - Cite sources for all claims
3. **ENGAGE Headlines** - Pattern interrupts required
4. **FIBS Features** - Fear → Intrigue → Believability → Stakes
5. **Image Rules** - Product to hero, testimonials to features
6. **No Placeholders** - {{VAR}}, $00, XX% forbidden

---

## File Structure

```
project/
├── .ralphy/
│   └── config.yaml          # Universal rules
├── brunson-prd.md           # Task checklist
├── .agent/
│   └── skills/              # Reference library (Claude reads these)
├── tests/
│   └── validate-*.sh        # Quality gates
├── images/                  # Your images
├── product.config           # Generated config
├── copy_draft.json          # Generated copy
├── index.html               # Final build
└── WORKFLOW.md              # This file
```

---

## Troubleshooting

### Task keeps failing

- Check which validation script failed
- Run it manually: `bash tests/validate-X.sh`
- Fix the issue, Ralphy will retry

### Images not mapping correctly

- Check `IMAGE-MAPPING.md` for rules
- Verify no testimonials in slideshow sections
- Run `bash tests/validate-images.sh`

### Copy seems generic

- Check `avatar_profile.json` has 7 deep sections
- Verify `copy_provenance_report.md` exists
- Run `bash tests/validate-framework.sh`

### Build has placeholders

- Check `product.config` is complete
- Run `./build.sh` manually to see errors
- Run `bash tests/validate-build.sh`

---

## Manual Override

If you need to run a single phase manually:

```bash
# Read the skill, execute manually
cat .agent/skills/brunson-avatar/SKILL.md

# Run validation
bash tests/validate-avatar.sh
```

---

## GitHub Repo

**Template:** https://github.com/yourorg/template-verification

**Ralphy:** https://github.com/michaelshimeles/ralphy

---

## Summary

| Old System                 | New System              |
| -------------------------- | ----------------------- |
| Ralph Loop (manual verify) | Ralphy (automated loop) |
| progress.json              | PRD checkboxes          |
| verify_step.py             | bash validation scripts |
| Human gates                | Automated validation    |
| 12 manual steps            | 1 command               |

**Run once. Deploy. Done.**

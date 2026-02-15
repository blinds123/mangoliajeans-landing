---
name: fullautopink
description: "Full Auto Pink - Autonomous landing page builder with Agent Teams v3. Runs the complete antpink workflow from research to deploy. Reads master instructions from ~/.clawd/skills/antpink/SKILL.md"
version: 1.1
trigger: /fullautopink, fullautopink, fullauto pink, use fullautopink, full auto pink
---

# FullAutoPink - Autonomous Landing Page Builder

**This skill delegates to the master antpink workflow defined in `~/.clawd/skills/antpink/SKILL.md`.**

## How It Works

When triggered, Claude Code reads and executes the full antpink workflow from the clawd skills directory. This allows the same workflow to work in both:

- **OpenClaw/ClawdBot** (via `~/.openclaw/workflows/antpink.sh`)
- **Claude Code** (via this skill - automatically duplicates template)

## Quick Start

```
/fullautopink "product-name"
```

## Execution

1. **Phase 0: Auto-Duplicate Template** - Copies from original YES-Clean-Jarvis-Template
2. **Set workspace**: New duplicated template directory in Downloads/
3. **Set research dir**: `~/clawd/research/[PRODUCT]/`
4. **Read the master SKILL.md**: `~/.clawd/skills/antpink/SKILL.md`
5. **Execute all phases** as defined in the master SKILL.md

## Phase 0: Auto-Template Duplication

```bash
PRODUCT="product-name"
DATE=$(date +%Y-%m-%d)
WORKSPACE="${HOME}/Downloads/${PRODUCT}-lander-${DATE}"
SOURCE_TEMPLATE="/Users/nelsonchan/Downloads/YES-Clean-Jarvis-Template"

# Duplicate the template
cp -r "${SOURCE_TEMPLATE}/" "${WORKSPACE}/"
echo "✅ Template duplicated: ${WORKSPACE}"
```

## Pre-requisites

- **Source template exists**: `/Users/nelsonchan/Downloads/YES-Clean-Jarvis-Template/`
- Product seed image must be available
- Chrome must be available for Whisk image generation

## Template Structure

This template includes all component skills needed by fullautopink:

| Component Skill        | Purpose                     |
| ---------------------- | --------------------------- |
| `scout`                | Market research             |
| `spy`                  | Competitor analysis         |
| `avatar-builder`       | Customer persona            |
| `profiler`             | Customer profile            |
| `neuro-research`       | Neuro triggers              |
| `strategy-builder`     | Big Domino + 3 Secrets      |
| `mechanic`             | Unique mechanism            |
| `linguist`             | Linguistic seed map         |
| `copy-writer`          | ENGAGE framework copy       |
| `perry-brain`          | Perry Belcher optimization  |
| `config-builder`       | product.config population   |
| `e2e-validator`        | End-to-end testing          |
| `template-reset`       | Clean slate for new product |
| `css-conflict-checker` | CSS debugging               |

## Key Paths

| Resource                | Path                                          |
| ----------------------- | --------------------------------------------- |
| **Master workflow**     | `~/.clawd/skills/antpink/SKILL.md`            |
| **Shell orchestrator**  | `~/.openclaw/workflows/antpink.sh`            |
| **Research output**     | `~/clawd/research/[PRODUCT]/`                 |
| **CODEX-GESTALT**       | `~/clawd/research/[PRODUCT]/CODEX-GESTALT.md` |
| **Bubble overlay tool** | `/Users/nelsonchan/clawd/tools/bubble-overlay/` |
| **Bubble overlay cmd**  | `source .venv/bin/activate && python generate_bubbles.py generate /path/to/images` |
| **Image mapping**       | `./IMAGE-MAPPING.md` (in template)            |
| **Image prep script**   | `./prepare-images.sh` (in template)           |

## Image Structure (34 total)

All hardcoded in template - see `IMAGE-MAPPING.md`:

- 6 product images: `images/product/product-01 to 06.webp`
- 25 testimonial images: `images/testimonials/testimonial-01 to 25.webp`
- 1 comparison: `images/comparison/comparison-01.webp`
- 1 founder (hardcoded, not generated): `images/founder/founder-01.webp`
- 1 order bump: `images/order-bump/order-bump-01.webp`

## Instructions for Claude Code

When this skill is triggered:

1. **Phase 0: Duplicate Template** - Auto-copy from `/Users/nelsonchan/Downloads/YES-Clean-Jarvis-Template/`
2. **Create workspace**: New directory in `~/Downloads/[PRODUCT]-lander-[DATE]/`
3. **Create research directory** at `~/clawd/research/[PRODUCT]/`
4. Read `~/.clawd/skills/antpink/SKILL.md` for the complete phase-by-phase workflow
5. Change directory to the new workspace
6. Follow all phases (P0 through P6) as defined in the master SKILL.md
7. Use the component skills in `.claude/skills/` for individual phases
8. Use `.agent/skills/` for specialized agent behaviors
9. Image paths are hardcoded in the template - follow `IMAGE-MAPPING.md`

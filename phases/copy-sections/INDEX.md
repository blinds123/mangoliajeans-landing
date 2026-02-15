# Section Copy Files Index

> **FOR ALL AI MODELS**: Read the specific section file BEFORE writing that section.
> Each file is small (<80 lines) so you can fully understand the requirements.

## How to Use

1. Find your section number below
2. Read the corresponding JSON file
3. Follow the MANDATORY_READS in that file
4. Write the section

## Section Files

| Section       | File to Read                    | Critical?    |
| ------------- | ------------------------------- | ------------ |
| 03-hero       | `section-03-hero.json`          | Yes          |
| 07-big-domino | `section-07-big-domino.json`    | **CRITICAL** |
| 08-pricing    | `section-08-pricing.json`       | **CRITICAL** |
| 09-features   | `section-09-features.json`      | Yes          |
| 11-comparison | `section-11-comparison.json`    | Yes          |
| 14-secret-1   | `section-14-secret-1.json`      | Yes          |
| 16-secret-2   | `section-16-secret-2.json`      | Yes          |
| 18-founder    | `section-18-founder-story.json` | **CRITICAL** |
| 20-secret-3   | `section-20-secret-3.json`      | Yes          |
| 23-faq        | `section-23-faq.json`           | Yes          |
| 24-final-cta  | `section-24-final-cta.json`     | Yes          |

## Simple Sections (No special file needed)

These sections are straightforward - just follow COPY-REQUIREMENTS.md:

- 01-announcement-bar
- 02-header
- 04-product-info-bar
- 05-gallery
- 06-product-title
- 10-add-to-cart
- 12-press-logos
- 13, 15, 17, 19, 21 (testimonials)
- 22-segment
- 25-footer

## Parallel Execution

For **5x faster** copy generation, use `phase-3-copy-parallel.json`:

| Agent   | Sections | Special Files to Read              |
| ------- | -------- | ---------------------------------- |
| Agent A | 01-05    | section-03-hero.json               |
| Agent B | 06-10    | section-07, section-08, section-09 |
| Agent C | 11-15    | section-11, section-14             |
| Agent D | 16-20    | section-16, section-18, section-20 |
| Agent E | 21-25    | section-23, section-24             |

## Critical Rule

**NEVER skip reading the section file.**
Weak models that skip will produce generic, unusable copy.

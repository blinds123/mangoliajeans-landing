---
name: antigravity-project-namer
description: Generates unique, semantic project names for Netlify and GitHub. Use to ensure every deployment has its own unique URL and repository. NEVER overwrites existing projects.
---

# 🌌 UNIVERSAL SKILL: ANTIGRAVITY PROJECT NAMER

You are the **Antigravity Project Namer**. Your job is to generate unique, descriptive project names for every new deployment.

## When to use this skill

- Use this BEFORE creating a new Netlify site.
- Use this BEFORE creating a new GitHub repository.
- Use this at the START of every new product launch.

## THE NAMING PROTOCOL

### RULE 1: NEVER OVERWRITE
- **OVERWRITING IS FORBIDDEN.** Every project MUST have a unique name.
- Check for existing Netlify sites and GitHub repos before creating.

### RULE 2: NAMING CONVENTION
Generate a name using this formula:
`[brand]-[product-keyword]-[unique-id]`

**Examples:**
- `[brand]-[product-type]-landing` (e.g., `auralo-jacket-landing`)
- `[brand]-[product-name]-v2` (e.g., `auralo-hoodie-v2`)
- `[brand]-[product]-[region]` (e.g., `auralo-top-eu`)

### RULE 3: UNIQUENESS CHECK
Before finalizing:
1.  **Netlify Check:** Run `npx netlify sites:list` and verify the name does not exist.
2.  **GitHub Check:** Use `gh repo list` to verify no collision.
3.  **If Collision:** Append a timestamp or increment (e.g., `-v2`, `-1737234567`).

### RULE 4: OUTPUT
Provide:
- `PROJECT_NAME`: The unique project name.
- `NETLIFY_SITE_NAME`: The Netlify subdomain.
- `GITHUB_REPO_NAME`: The GitHub repository name.

## HOW TO USE

1.  Read the `product.config` to get `PRODUCT_NAME` and `BRAND_NAME`.
2.  Generate a slug: `brand-product-keyword`.
3.  Verify uniqueness.
4.  Output the final names.

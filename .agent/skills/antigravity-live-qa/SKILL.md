---
name: antigravity-live-qa
description: Opens the deployed Netlify URL in a browser and performs final visual and textual audits. Use after deployment to verify the live site matches local expectations.
---

# 🌌 UNIVERSAL SKILL: ANTIGRAVITY LIVE QA

You are the **Antigravity Live Auditor**. Your job is to open the DEPLOYED Netlify URL in a browser, take screenshots, and perform a final visual and textual audit to compare against the local QA report.

## When to use this skill

- Use this AFTER deployment to Netlify.
- Use this as the final verification step.
- Use this when comparing live site to local build.

## THE LIVE QA PROTOCOL

### RULE 1: BROWSER LAUNCH

1.  **Action:** Open a browser using the `mcp__chrome-devtools__` MCP tools (navigate_page, take_snapshot, take_screenshot).
2.  **Navigate:** The live Netlify production URL using `mcp__chrome-devtools__navigate_page`.

### RULE 2: VISUAL COMPARISON CHECKLIST

Capture screenshots and compare against `local_qa_report.md`:

- [ ] **Hero Section:** Does the live headline match the local version?
- [ ] **Images:** Are all CDN-hosted images loading correctly?
- [ ] **SSL:** Is the site served over HTTPS?
- [ ] **Mobile Responsiveness:** Resize to 375px and compare.

### RULE 3: TEXTUAL AUDIT

Using JavaScript execution in the browser:

1.  **Extract all text:** `document.body.innerText`
2.  **Search for Placeholders:** Any `{{VARIABLE}}` text is a CRITICAL FAILURE.
3.  **Verify Seed Presence:** Confirm the "Linguistic Seed" is present in the live DOM.

### RULE 4: THE LOOP (UP TO 20 ITERATIONS)

- **If ANY check fails:** Document the failure, return to the relevant earlier step (Builder, Auditor, or Copywriter), and re-run.
- **If ALL checks pass after 20 loops OR on first pass:** Mark as `LIVE_QA: PASSED`.

## OUTPUT REQUIREMENT

A `live_qa_report.md` with:

- Screenshot file paths.
- Checklist pass/fail status.
- Comparison against `local_qa_report.md`.
- Final `LIVE_QA: PASSED/FAILED` status.

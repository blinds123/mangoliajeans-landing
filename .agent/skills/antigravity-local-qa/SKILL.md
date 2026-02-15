---
name: antigravity-local-qa
description: Visual browser audit of index.html BEFORE deployment. Catches copy and image errors automated tests miss.
---

# ANTIGRAVITY LOCAL QA

Open the built `index.html` in browser and verify visually.

## When to Use

- After `./build.sh` generates `index.html`
- Before deploying to Netlify

## QA Steps

### 1. Open in Browser

Navigate to `file:///[project-path]/index.html`

### 2. Check for Failures (STOP if any found)

| Check                             | Pass Criteria                       |
| --------------------------------- | ----------------------------------- |
| No `{{PLACEHOLDER}}` text visible | All variables replaced              |
| All images load                   | No broken image icons               |
| Headline challenges a belief      | "Why..." / "The Lie..." / "Stop..." |
| Features have proof               | Numbers, materials, testing claims  |
| Secrets address 3 fears           | Vehicle, Internal, External         |

### 3. Mobile Check

Resize to 375px width - verify layout doesn't break.

### 4. Result

- **FAIL:** Return to Build Phase, fix issues
- **PASS:** Proceed to Deployment

## Output

`local_qa_report.md` with pass/fail status and screenshot paths.

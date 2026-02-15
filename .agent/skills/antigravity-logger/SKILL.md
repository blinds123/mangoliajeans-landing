---
name: antigravity-logger
description: Comprehensive session logging for Antigravity workflows. Tracks all actions, decisions, errors, and user requests. Creates audit trail for debugging and review.
---

# Antigravity Logger

## Purpose

Creates a detailed audit log of everything that happens during a Brunson Magic workflow session. This log can be reviewed later to diagnose issues, understand decisions, and improve the template.

## Activation

Add this to your prompt when starting a new template build:

```
ENABLE ANTIGRAVITY LOGGING to ./session-log.md
```

Or specify a custom path:

```
ENABLE ANTIGRAVITY LOGGING to ./logs/2026-01-22-product-name.md
```

## What Gets Logged

### 1. SESSION METADATA

- Start time
- Product name
- Competitor URL
- User name (if provided)

### 2. PHASE TRACKING

- Phase start/end times
- Phase status (PASS/FAIL/SKIP)
- Errors encountered
- Files modified

### 3. USER REQUESTS

- Every instruction from user
- Clarification questions asked
- Decisions made

### 4. FILE OPERATIONS

- Files read
- Files written/modified
- Files deleted
- Images processed

### 5. VALIDATION RESULTS

- Test scripts run
- Pass/fail status
- Error messages
- Fixes applied

### 6. ERRORS & ISSUES

- Build failures
- Missing variables
- Broken paths
- Placeholder issues

### 7. DECISIONS & REASONING

- Why certain approaches were chosen
- Trade-offs considered
- Deferred items

## Log Format

The log is written in markdown with clear sections:

```markdown
# Antigravity Session Log

## Session Info

- **Product**: [name]
- **Started**: [timestamp]
- **Template**: [directory]

---

## Timeline

### [HH:MM] Phase 1: Initialize

- **Status**: PASS
- **Actions**:
  - Read product.config
  - Validated competitor URL
- **Files Modified**: None

### [HH:MM] User Request

> "Change the headline to X"

- **Action Taken**: Modified HEADLINE_HOOK in product.config
- **Files Modified**: product.config

### [HH:MM] ERROR

- **Type**: Missing Variable
- **Details**: SECRET_IMAGE_3 undefined
- **Resolution**: Added to product.config

---

## Summary

- **Total Phases**: 12
- **Passed**: 11
- **Failed**: 1
- **User Requests**: 5
- **Errors Fixed**: 3
- **Files Modified**: 8
```

## How to Use the Log

### During Session

The log is updated in real-time. You can check progress:

```bash
tail -50 session-log.md
```

### After Session

Review the complete log to:

1. Understand what was done
2. Find patterns in errors
3. Identify template improvements needed

### Feed Back to Claude

Copy the log content and paste it to Claude:

```
Here is the session log from my last Antigravity run.
Please analyze it and tell me:
1. What went wrong
2. What improvements to make to the template
3. What patterns you see in the errors

[paste log content]
```

## Log Commands

During a session, you can use these commands:

| Command                   | Action                        |
| ------------------------- | ----------------------------- |
| `LOG: [message]`          | Add custom note to log        |
| `LOG ERROR: [message]`    | Log an error                  |
| `LOG DECISION: [message]` | Log a decision with reasoning |
| `SHOW LOG`                | Display recent log entries    |
| `EXPORT LOG`              | Save log to timestamped file  |

## Integration with Ralphy

When using Ralphy orchestration, add to your command:

```bash
ralphy --prd ./brunson-prd.md --engine claude-code --test --log ./session-log.md
```

## Template for Session Log

Create this file at start of session:

```markdown
# Antigravity Session Log

## Session Info

- **Product**: {{PRODUCT_NAME}}
- **Started**: {{TIMESTAMP}}
- **Template Directory**: {{DIRECTORY}}
- **Competitor URL**: {{COMPETITOR_URL}}
- **User**: {{USER_NAME}}

---

## Pre-Flight Checklist

- [ ] Images folder populated
- [ ] Competitor URL provided
- [ ] product.config backed up

---

## Timeline

[Entries will be added here chronologically]

---

## Errors Encountered

[Errors will be logged here with resolutions]

---

## User Requests

[All user instructions will be logged here]

---

## Files Modified

[List of all files changed during session]

---

## Summary

[Generated at end of session]
```

## Auto-Logging Prompt

Add this to CLAUDE.md or your system prompt to enable automatic logging:

```markdown
## Antigravity Logging Protocol

For EVERY action you take:

1. Log the action to session-log.md
2. Include timestamp, action type, and outcome
3. Log all errors with full context
4. Log all user requests verbatim
5. Log all file modifications

Format:

### [HH:MM] [ACTION_TYPE]

- **Details**: [what happened]
- **Files**: [files affected]
- **Status**: [PASS/FAIL/PENDING]
```

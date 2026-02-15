# Antigravity Logging Activation Prompt

Copy and paste this at the START of any new template build session:

---

## ACTIVATION PROMPT (Copy Below This Line)

```
ENABLE ANTIGRAVITY LOGGING

You MUST maintain a session log at ./session-log.md throughout this entire session.

## Logging Requirements

1. **Create Log File**: At session start, copy SESSION-LOG-TEMPLATE.md to session-log.md and fill in session info

2. **Log EVERY Action**: For each action you take, append to the Timeline section:
```

### [HH:MM] [ACTION_TYPE]

- **Details**: What you did
- **Files**: Files affected
- **Status**: PASS/FAIL/PENDING

```

3. **Log ALL Errors**: When any error occurs:
```

### Error: [Description]

- **Phase**: Where it happened
- **Details**: Full error
- **Root Cause**: Why
- **Resolution**: How fixed

```

4. **Log User Requests**: Every time I ask you to do something:
```

### User Request

> "[My exact message]"

- **Action**: What you did
- **Outcome**: Result

```

5. **Log Decisions**: When you make choices:
```

### Decision: [Topic]

- **Options**: What you considered
- **Chosen**: What you picked
- **Why**: Reasoning

```

6. **Update Summary**: At session end, fill in the Summary section with stats

## Commands I Can Use
- "SHOW LOG" - Display recent log entries
- "LOG: [note]" - Add custom note
- "EXPORT LOG" - Save to timestamped file

## Important
- Update the log IN REAL TIME, not at the end
- Be verbose - more detail is better for debugging
- Include file paths and line numbers when relevant
- Log even small changes

START LOGGING NOW.
```

---

## After Session - How to Review

When session is complete, you can:

### 1. Review Locally

```bash
cat session-log.md
```

### 2. Feed Back to Claude

Start a new conversation and paste:

```
Here is the session log from my Antigravity template build.
Please analyze it and tell me:
1. What patterns do you see in the errors?
2. What template improvements should we make?
3. What went wrong and how to prevent it?
4. Any bugs or issues in the workflow?

---
[PASTE session-log.md CONTENTS HERE]
---
```

### 3. Compare Sessions

Keep logs from multiple sessions:

```bash
mv session-log.md logs/2026-01-22-product-name.md
```

Then compare patterns across builds to identify recurring issues.

---

## Quick Start Checklist

1. [ ] Copy this activation prompt
2. [ ] Paste it at START of new Claude conversation
3. [ ] Provide competitor URL and product name
4. [ ] Claude creates session-log.md automatically
5. [ ] Review log at end of session
6. [ ] Save log for future reference

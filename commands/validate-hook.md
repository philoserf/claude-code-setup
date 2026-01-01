---
description: Validates a hook for correctness, safety, and performance
---

# validate-hook

Validates a hook script for correctness, safety, performance, and best practices.

## Usage

```bash
/validate-hook [hook-name]
```

- **With hook-name**: Validates the specified hook (e.g., `/validate-hook user-prompt-submit`)
- **Without args**: Validates all hooks in ~/.claude/hooks/

## What It Does

This command invokes the hook-auditor to perform comprehensive validation:

- **JSON stdin Handling**: Checks proper parsing and error handling
- **Exit Codes**: Verifies correct usage (0=allow, 2=block)
- **Error Handling**: Reviews safe degradation and error messages
- **Performance**: Analyzes execution speed and efficiency
- **settings.json Registration**: Validates hook configuration
- **Best Practices**: Checks defensive programming and portability

## Output

Generates a structured evaluation report with:

- Status (PASS/NEEDS WORK/FAIL) for Correctness, Safety, Performance
- Specific findings for each category
- Security and reliability analysis
- Prioritized recommendations
- Next steps

## Examples

```bash
# Validate the user-prompt-submit hook
/validate-hook user-prompt-submit

# Validate all hooks
/validate-hook
```

## Delegation

This command delegates to the **hook-auditor** skill, which analyzes hook scripts for correctness, safety, and performance.

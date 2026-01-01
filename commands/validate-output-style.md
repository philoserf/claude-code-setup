---
description: Validates an output-style for persona clarity and behavior specification
---

# validate-output-style

Validates an output-style configuration for persona clarity, behavior specification, and scope.

## Usage

```bash
/validate-output-style [style-name]
```

- **With style-name**: Validates the specified output-style (e.g., `/validate-output-style concise`)
- **Without args**: Validates all output-styles in ~/.claude/output-styles/

## What It Does

This command invokes the output-style-auditor to perform comprehensive validation:

- **YAML Frontmatter**: Checks required fields (name, description, scope)
- **Persona Clarity**: Ensures persona definition is clear and actionable
- **Behavior Specification**: Reviews concrete behavior changes
- **Coding Instructions**: Validates keep-coding-instructions decision
- **Scope Alignment**: Verifies user vs project scope is appropriate
- **Best Practices**: Checks against established patterns

## Output

Generates a structured evaluation report with:

- Status (PASS/NEEDS WORK/FAIL) for Persona, Behavior, Scope
- Specific findings for each category
- Effectiveness analysis
- Prioritized recommendations
- Next steps

## Examples

```bash
# Validate the concise output-style
/validate-output-style concise

# Validate all output-styles
/validate-output-style
```

## Delegation

This command delegates to the **output-style-auditor** skill, which analyzes output-style files for clarity and effectiveness.

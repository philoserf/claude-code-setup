---
description: Validates a command for delegation patterns and documentation
---

# validate-command

Validates a command configuration for delegation clarity, simplicity, and documentation.

## Usage

```bash
/validate-command [command-name]
```

- **With command-name**: Validates the specified command (e.g., `/validate-command commit`)
- **Without args**: Validates all commands in ~/.claude/commands/

## What It Does

This command invokes the command-auditor to perform comprehensive validation:

- **YAML Frontmatter**: Checks required description field
- **Delegation Clarity**: Ensures clear handoff to agent or skill
- **Simplicity Enforcement**: Validates 6-10 lines for simple, 30-80 for documented
- **Documentation Proportionality**: Checks if complexity justifies documentation
- **Argument Handling**: Reviews parameter passing patterns
- **Best Practices**: Checks against established patterns

## Output

Generates a structured evaluation report with:

- Status (PASS/NEEDS WORK/FAIL) for Delegation, Simplicity, Documentation
- Specific findings for each category
- Complexity analysis
- Prioritized recommendations
- Next steps

## Examples

```bash
# Validate the commit command
/validate-command commit

# Validate all commands
/validate-command
```

## Delegation

This command delegates to the **command-auditor** skill, which analyzes command files for proper delegation and structure.

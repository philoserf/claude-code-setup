---
description: Validates a skill for discoverability and triggering effectiveness
---

# validate-skill

Validates a skill configuration for discoverability, triggering effectiveness, and structure.

## Usage

```bash
/validate-skill [skill-name]
```

- **With skill-name**: Validates the specified skill (e.g., `/validate-skill pdf`)
- **Without args**: Validates all skills in ~/.claude/skills/

## What It Does

This command invokes the skill-auditor to perform comprehensive validation:

- **YAML Frontmatter**: Checks required fields (name, description, location)
- **Trigger Coverage**: Analyzes description for keyword and phrase coverage
- **Progressive Disclosure**: Ensures summary is concise while body has depth
- **SKILL.md Structure**: Reviews organization and completeness
- **Discoverability**: Assesses whether skill will be invoked appropriately
- **Best Practices**: Checks against established patterns

## Output

Generates a structured evaluation report with:

- Status (PASS/NEEDS WORK/FAIL) for Discoverability, Triggering, Structure
- Specific findings for each category
- Trigger phrase analysis
- Prioritized recommendations
- Next steps

## Examples

```bash
# Validate the pdf skill
/validate-skill pdf

# Validate all skills
/validate-skill
```

## Delegation

This command delegates to the **skill-auditor** skill, which analyzes skill files for effectiveness and discoverability.

---
description: Validates an agent configuration for correctness, clarity, and effectiveness
---

# validate-agent

Validates an agent configuration file for correctness, clarity, and effectiveness.

## Usage

```bash
/validate-agent [agent-name]
```

- **With agent-name**: Validates the specified agent (e.g., `/validate-agent bash`)
- **Without args**: Validates all agents in ~/.claude/agents/

## What It Does

This command invokes the claude-code-evaluator agent to perform comprehensive validation:

- **YAML Frontmatter**: Checks required fields (name, description, model)
- **Model Validity**: Ensures model is sonnet, opus, or haiku
- **Name Matching**: Verifies name matches filename
- **Structure**: Reviews focus areas and approach sections
- **Context Economy**: Assesses file size and efficiency
- **Best Practices**: Checks against established patterns

## Output

Generates a structured evaluation report with:

- Status (PASS/NEEDS WORK/FAIL) for Correctness, Clarity, Effectiveness
- Specific findings for each category
- Context usage analysis
- Prioritized recommendations
- Next steps

## Examples

```bash
# Validate the bash agent
/validate-agent bash

# Validate all agents
/validate-agent
```

## Delegation

This command delegates to the **claude-code-evaluator** agent, which uses read-only tools (Read, Grep, Glob, Bash) to analyze agent files without making modifications.

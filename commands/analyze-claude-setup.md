---
description: Comprehensive analysis of your entire Claude Code configuration
---

# analyze-claude-setup

Comprehensive analysis of your entire Claude Code configuration.

## Usage

```bash
/analyze-claude-setup
```

## What It Does

This command invokes the claude-code-evaluator agent to perform a complete audit of your Claude Code setup:

### Inventory

- Count of all customizations (agents, commands, skills, hooks, output-styles)
- Total size and estimated context usage
- File organization assessment

### Configuration Health

- Validates settings.json structure
- Checks hook configurations
- Verifies all hooks in settings.json exist as files
- Identifies orphaned references

### Tool Permissions

- Reviews allowed and denied tools
- Checks for security issues
- Ensures permissions cover customization needs
- Identifies overly permissive patterns

### Integration Analysis

- Checks for conflicting hooks
- Verifies customizations work together
- Assesses hook execution order
- Identifies integration issues

### Context Economy

- Calculates total token usage estimate
- Identifies largest files
- Evaluates progressive disclosure usage
- Recommends optimizations

### Security Assessment

- Reviews protected file patterns
- Checks denied commands
- Evaluates hook safety
- Identifies security concerns

## Output

Generates a comprehensive report with:

- **Inventory Summary**: Counts and breakdown by type
- **Health Report**: Configuration status and issues
- **Security Assessment**: Potential vulnerabilities
- **Context Analysis**: Usage estimates and optimization opportunities
- **Prioritized Recommendations**: Action items ordered by importance

## Examples

```bash
# Analyze your complete setup
/analyze-claude-setup
```

## Delegation

This command delegates to the **claude-code-evaluator** agent, which performs read-only analysis of:

- All files in ~/.claude/agents/, commands/, skills/, hooks/, output-styles/
- ~/.claude/settings.json configuration
- Directory structure and organization
- File sizes and context impact

No modifications are made during analysis.

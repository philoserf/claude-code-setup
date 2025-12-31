---
description: Tests a skill's discoverability and effectiveness with sample queries
---

# test-claude-skill

Tests a skill's discoverability and effectiveness with sample queries.

## Usage

```bash
/test-claude-skill [skill-name]
```

- **With skill-name**: Tests the specified skill (e.g., `/test-claude-skill git-workflow`)
- **Without args**: Lists all available skills

## What It Does

This command delegates to specialized agents to perform comprehensive skill testing:

### Discovery Testing (via claude-code-skill-auditor)

- Analyzes frontmatter description for trigger quality
- Generates test queries that should trigger the skill
- Identifies queries that might be missed
- Scores discoverability (1-10 scale)
- Provides recommendations for improving triggers

### Functionality Testing (via claude-code-test-runner)

- Generates sample queries based on skill description
- Tests whether skill would be properly triggered
- Optionally invokes the skill with test scenarios
- Validates expected behavior and outputs
- Reports edge cases and potential issues

## Output

Generates a comprehensive test report including:

- **Discovery Score**: How well the skill can be found (1-10)
- **Trigger Analysis**: Queries that would/wouldn't trigger
- **Test Results**: PASS/FAIL for functional tests
- **Recommendations**: Specific improvements to enhance discovery and functionality

## Examples

```bash
# Test the git-workflow skill
/test-claude-skill git-workflow

# Test the claude-code-audit skill
/test-claude-skill claude-code-audit

# List all skills (no args)
/test-claude-skill
```

## Delegation

This command orchestrates two agents:

1. **claude-code-skill-auditor** agent: Analyzes description quality and discoverability
2. **claude-code-test-runner** agent: Performs functional testing with sample queries

Both agents use read-only tools for analysis and testing.

## Use Cases

- **Before deploying a new skill**: Ensure it will be discoverable
- **After updating a skill**: Verify changes improved triggering
- **Troubleshooting**: Understand why a skill isn't being selected
- **Optimization**: Identify missing trigger phrases and use cases

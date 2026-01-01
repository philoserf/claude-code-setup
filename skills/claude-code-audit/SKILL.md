---
name: claude-code-audit
description: Comprehensive evaluation and validation of Claude Code customizations. Auto-triggers when reviewing, evaluating, or improving agents, commands, skills, hooks, or output-styles. Provides naming conventions, structural guidance, and best practices for all .claude/ components.
allowed-tools: Read, Grep, Glob, Bash, AskUserQuestion
---

# Claude Code Audit Skill

Automated evaluation and validation workflow for Claude Code customizations. This skill provides comprehensive analysis of agents, commands, skills, hooks, and output-styles, along with naming conventions and organizational standards.

## When to Use

This skill auto-triggers when:

- User asks to "review", "evaluate", or "analyze" a customization
- User wants to "improve" or "optimize" an agent, skill, command, or hook
- User is working on files in ~/.claude/ and requests feedback
- User wants to validate their Claude Code setup
- User asks "does this look good?" about a .claude/ file
- User needs naming conventions or organizational guidance
- User asks about best practices for Claude Code components

## Quick Start

Simply ask to evaluate or get guidance:

- "Review the claude-code-evaluator agent"
- "Check if my git-workflow skill is discoverable"
- "Analyze my entire Claude Code setup"
- "Is this hook configured correctly?"
- "What should I name my new agent?"
- "How should I organize this skill's references?"

## Workflow

### 1. Identify Target

Determine what needs evaluation or guidance:

- **Single File**: Specific agent, command, skill, hook, or output-style
- **Type**: All agents, all skills, all hooks, etc.
- **Setup**: Entire ~/.claude/ configuration
- **Guidance**: Naming conventions, organization, best practices

Use Read, Grep, and Glob tools to locate target files.

### 2. Determine Evaluation Type

Based on what's being evaluated:

**Agent** → Check:

- YAML frontmatter (name, description, model)
- Model validity (sonnet, opus, haiku)
- Name matches filename
- Focus areas specificity
- Approach completeness
- Context economy (<500 lines target)

**Command** → Check:

- Clear purpose statement
- Usage instructions
- Delegation pattern (what agent/skill it uses)
- Simplicity (no complex logic)

**Skill** → Check:

- YAML frontmatter (name, description, allowed-tools)
- Description triggers (>50 chars, includes what AND when)
- Progressive disclosure (SKILL.md <500 lines, references/ structure)
- allowed-tools matches usage
- Reference file organization
- Markdown linting (run `markdownlint` on SKILL.md and references/\*.md)
  - **MD040**: All code blocks must have language specifiers
  - Common issues: unlabeled code blocks in examples, workflows, error messages

**Hook** → Check:

- Shebang line
- JSON stdin handling
- Exit codes (0=allow, 2=block)
- Error handling (exit 0 on failures)
- stderr message clarity
- Performance (execution speed)

**Output-Style** → Check:

- YAML frontmatter (name, description)
- Persona clarity
- Tone appropriateness
- Use case explanation

**Setup** → Check:

- Inventory (counts by type)
- settings.json health
- Hook registrations
- Tool permissions
- Orphaned references
- Context economy
- Security assessment

### 3. Apply Evaluation Framework

Use specialized agents for deep analysis:

**For General Evaluation**:

Invoke the **claude-code-evaluator** agent to assess:

- Correctness (required fields, syntax, structure)
- Clarity (readability, organization, documentation)
- Effectiveness (context economy, triggering, integration)

**For Skill Discovery**:

Invoke the **claude-code-skill-auditor** agent to analyze:

- Description quality for triggering (1-10 score)
- Trigger phrase coverage
- Progressive disclosure compliance
- allowed-tools appropriateness

**For Systematic Testing**:

Invoke the **claude-code-test-runner** agent to perform:

- Functional tests (does it work?)
- Integration tests (works with others?)
- Usability tests (good UX?)
- Edge case identification

See [references/evaluation-criteria.md](references/evaluation-criteria.md) for detailed criteria.

### 4. Provide Naming and Organizational Guidance

When users need structural guidance:

- Reference [naming-conventions.md](../../references/naming-conventions.md) for component naming patterns (shared)
- Reference [file-organization.md](references/file-organization.md) for directory structure
- Reference [frontmatter-requirements.md](../../references/frontmatter-requirements.md) for YAML specifications (shared)
- Reference [when-to-use-what.md](../../references/when-to-use-what.md) for choosing agents vs skills vs commands (shared)
- Reference [anti-patterns.md](references/anti-patterns.md) for common mistakes to avoid

### 5. Generate Report

Create a structured evaluation report with:

- **Summary**: 1-2 sentence overview
- **Status**: PASS/NEEDS WORK/FAIL for each dimension
- **Findings**: Specific issues organized by category
- **Context Usage**: Size and efficiency metrics
- **Recommendations**: Prioritized improvements (P1, P2, P3)
- **Next Steps**: Actionable tasks

Reports follow standardized format for consistency.

### 6. Ask for Confirmation

Use AskUserQuestion to offer:

- **Detailed Recommendations**: Expand on specific improvements?
- **Automatic Fixes**: Apply straightforward fixes automatically?
- **Additional Analysis**: Run more specialized evaluations?
- **Save Report**: Save to logs/evaluations/ for future reference?

## Integration with Agents

This skill orchestrates specialized agents:

### Claude Code Evaluator Agent

**Use for**: General-purpose evaluation of any customization type

**Invocation**: "Invoke the claude-code-evaluator agent to assess [target]"

**Tools**: Read, Grep, Glob, Bash (read-only)

**Output**: Structured report with correctness/clarity/effectiveness findings

### Claude-Code-Skill-Auditor Agent

**Use for**: Deep analysis of skill discoverability

**Invocation**: "Invoke the claude-code-skill-auditor agent to audit [skill-name]"

**Tools**: Read, Grep, Glob, Bash (read-only)

**Output**: Discovery score (1-10), trigger analysis, recommendations

### Claude-Code-Test-Runner Agent

**Use for**: Systematic testing with sample queries

**Invocation**: "Invoke the claude-code-test-runner agent to test [target]"

**Tools**: Read, Grep, Glob, Bash, Skill (optional)

**Output**: Test results (PASS/FAIL counts), edge cases, failures

## Common Evaluation Patterns

### Pattern 1: Single File Evaluation

```text
User: "Review the bash agent"

1. Read ~/.claude/agents/claude-code-test-runner.md
2. Invoke claude-code-evaluator agent on claude-code-test-runner.md
3. Present findings to user
4. Ask if they want detailed recommendations
```

### Pattern 2: Skill Discovery Analysis

```text
User: "Is my git-workflow skill discoverable?"

1. Read ~/.claude/skills/git-workflow/SKILL.md
2. Invoke claude-code-skill-auditor agent
3. Present discovery score and trigger analysis
4. Suggest description improvements
5. Ask if they want to test with sample queries
```

### Pattern 3: Setup-Wide Audit

```text
User: "Analyze my entire Claude Code setup"

1. Glob all files in ~/.claude/
2. Count customizations by type
3. Invoke claude-code-evaluator agent for setup analysis
4. Check settings.json health
5. Generate comprehensive inventory and recommendations
6. Ask if they want detailed analysis of specific components
```

### Pattern 4: Naming Guidance

```text
User: "What should I name my new agent?"

1. Determine agent purpose from context
2. Reference naming-conventions.md
3. Suggest appropriate kebab-case name
4. Provide examples of similar agents
5. Explain naming rationale
```

### Pattern 5: Pre-Deployment Validation

```text
User: "Does this new skill look good?" (while editing SKILL.md)

1. Read the SKILL.md being edited
2. Invoke claude-code-evaluator agent for correctness check
3. Invoke claude-code-skill-auditor for discovery analysis
4. Present quick validation summary
5. Flag any blocking issues (missing fields, invalid YAML)
6. Ask if they want full evaluation or just quick check
```

## Best Practices

1. **Start with Quick Check**: For simple validations, use claude-code-evaluator agent directly
2. **Deep Dive When Needed**: For skills, add claude-code-skill-auditor analysis
3. **Test Before Deploy**: Use claude-code-test-runner for new customizations
4. **Incremental Evaluation**: Don't overwhelm with all findings at once
5. **Prioritize Fixes**: Always rank recommendations by importance
6. **Offer Auto-Fix**: For simple issues (typos, formatting), offer to fix
7. **Save Reports**: Store evaluations in logs/evaluations/ for tracking
8. **Re-Evaluate After Changes**: Confirm improvements work
9. **Reference Standards**: Point to naming conventions and organization guides
10. **Teach Patterns**: Help users learn best practices, not just fix issues

## Reference Documentation

This skill provides comprehensive reference materials for all aspects of Claude Code customization:

### Shared References (Used by All Authoring Skills)

- **[Naming Conventions](../../references/naming-conventions.md)** - Patterns for agents, commands, skills, hooks, and output-styles
- **[Frontmatter Requirements](../../references/frontmatter-requirements.md)** - Complete YAML specification for each component type
- **[When to Use What](../../references/when-to-use-what.md)** - Decision guide for choosing agents vs skills vs commands vs output-styles

### Evaluation-Specific References

- **[Evaluation Criteria](references/evaluation-criteria.md)** - Comprehensive criteria for each extension type
- **[Common Issues](references/common-issues.md)** - Frequent problems and how to fix them with examples
- **[Anti-Patterns](references/anti-patterns.md)** - Common mistakes to avoid
- **[File Organization](references/file-organization.md)** - Directory structure and layout best practices
- **[Hook Events](references/hook-events.md)** - Hook event types and timing
- **[Examples](references/examples.md)** - Example evaluations and reports

These references are loaded on-demand to maintain context efficiency.

## Example Evaluations

### Quick Agent Check

```text
User: "Validate the claude-code-evaluator agent"
Claude Code Audit: *Reads claude-code-evaluator.md, checks frontmatter*
→ "PASS - claude-code-evaluator agent looks good:
  ✓ Valid frontmatter (name, description, model: sonnet)
  ✓ Comprehensive focus areas
  ✓ Clear evaluation framework
  ✓ Structured output format
  ✓ Context economy: 354 lines (under target)

  Want a detailed report with all findings?"
```

### Skill Discovery Analysis

```text
User: "Is meta-evaluator discoverable?"
Claude Code Audit: *Reads SKILL.md, invokes claude-code-skill-auditor*
→ "Discovery Score: 9/10

  Strengths:
  - Description includes 'what' (auto-evaluates customizations)
  - Description includes 'when' (reviewing .claude/ files)
  - Trigger phrases: review, evaluate, improve, validate
  - Good length (200+ chars)

  Minor improvements:
  - Could add 'audit' as trigger phrase
  - Could mention 'check setup' as use case

  Would trigger on these queries:
  - 'Review my agent'
  - 'Evaluate this skill'
  - 'Analyze my setup'

  Want to see suggested description improvements?"
```

### Naming Guidance

```text
User: "What should I name my agent that reviews security?"
Claude Code Audit: *References naming-conventions.md*
→ "For a security review agent, use the pattern {domain}-{role}:

  Recommended: security-reviewer.md

  Examples of similar patterns:
  - code-reviewer.md
  - performance-optimizer.md
  - api-designer.md

  The name should:
  - Use kebab-case (lowercase with hyphens)
  - Be descriptive and specific
  - Follow the {domain}-{role} pattern

  Would you like me to help draft the frontmatter too?"
```

## Tips for Users

- **Be Specific**: "Review bash agent" is clearer than "check my code"
- **One at a Time**: Evaluate individual components before full setup audit
- **Iterative Improvement**: Fix P1 issues, then re-evaluate
- **Save Reports**: Keep evaluation history to track improvements
- **Test Changes**: After fixing issues, run claude-code-test-runner to verify
- **Learn the Patterns**: Review naming conventions and anti-patterns regularly
- **Ask for Guidance**: When unsure about structure, ask before building

## Integration Notes

This skill works alongside:

- **skill-authoring**: Use skill-authoring to build new skills, claude-code-audit to validate them
- **Validation hook**: validate_config.py catches errors at write time, claude-code-audit provides deeper analysis
- **Commands**: /validate-agent, /test-skill, /analyze-setup all delegate to agents that claude-code-audit also uses

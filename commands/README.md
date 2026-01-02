# Command Delegation Pattern Guide

## Quick Reference

Commands in `~/.claude/commands/` use **descriptive delegation** - Claude reads the command file and interprets the delegation instructions.

### How It Works

Commands describe what skill/agent to invoke using natural language. Claude reads this description and performs the delegation automatically.

**NOT**: Explicit tool invocation syntax
**YES**: Descriptive statements about what to invoke

## The Pattern

### Minimal Pattern (~11 lines)

```markdown
---
description: Brief description of what command does
---

# command-name

Brief description sentence.

**Usage:** `/command-name [optional-args]`

**Delegation:** Invokes the **skill-name** skill for [what it does].
```

### Example: audit-bash

```markdown
---
description: Audit shell scripts for best practices, security, and portability
---

# audit-bash

Audit shell scripts for best practices, security, and portability.

**Usage:** `/audit-bash [script-path]`

**Delegation:** Invokes the **bash-audit** skill for comprehensive shell script analysis.
```

### Key Elements

1. **Frontmatter** with `description` field (required)
2. **Heading** matching command name
3. **Brief description** (1-2 sentences)
4. **Usage line** showing syntax
5. **Delegation statement** identifying the target skill/agent

## Delegation Statement Patterns

### Pattern 1: Skill Delegation (Most Common)

```markdown
**Delegation:** Invokes the **skill-name** skill for [purpose].
```

Examples:

- `Invokes the **bash-audit** skill for comprehensive shell script analysis.`
- `Invokes the **skill-audit** skill to analyze description quality, trigger phrase coverage, progressive disclosure, and discovery score (1-10 scale).`
- `Invokes the **agent-authoring** skill for comprehensive interactive guidance on purpose definition, model selection, tool restrictions, focus areas, approach, description crafting, and validation.`

### Pattern 2: Agent Delegation (Less Common)

```markdown
**Delegation:** Invokes the **agent-name** agent for [purpose].
```

Example:

- `Invokes the **claude-code-evaluator** agent to perform complete audit of your Claude Code setup.`

### Pattern 3: Descriptive Without "Delegation" Label

```markdown
Execute the skill-name skill to handle [purpose].
```

Example (from automate-git.md):

```markdown
Execute the git-workflow skill to handle complete git workflow automation including branch management, atomic commits, history cleanup, and PR creation.
```

## Two Command Sizes

### Simple Commands (6-11 lines)

Minimal documentation, just the essentials:

- Frontmatter
- Heading
- Description
- Usage
- Delegation

**Examples**: audit-bash, create-agent, create-command, create-skill, create-output-style, test-claude-skill, analyze-claude-setup, automate-git

### Documented Commands (25-27 lines)

Include detailed documentation:

- Frontmatter
- Heading
- Description with target specification (e.g., `${ARGUMENTS:-default}`)
- Bullet list of validation checks or features
- Usage section (optional)
- Delegation statement

**Examples**: validate-agent, validate-skill, validate-hook, validate-command, validate-output-style

## Argument Handling

### Pattern 1: Documented in Usage

```markdown
**Usage:** `/command-name [optional-arg]`
```

The skill/agent automatically receives arguments when invoked.

### Pattern 2: With Default Value

```markdown
**Target**: ${ARGUMENTS:-all agents in ~/.claude/agents/}
```

Shows user what will be used if no argument provided.

## Complete Examples

### Example 1: Minimal Pattern (create-skill.md)

```markdown
---
description: Guide for authoring effective skills that extend Claude's capabilities
---

# create-skill

Guides you through creating a new skill with specialized knowledge and workflows.

**Usage:** `/create-skill [skill-name]`

**Delegation:** Invokes the **skill-authoring** skill for comprehensive guidance on skill structure, progressive disclosure, resource organization, description writing, tool permissions, validation, and packaging.
```

### Example 2: Documented Pattern (validate-agent.md)

```markdown
---
description: Validates an agent configuration for correctness, clarity, and effectiveness
---

Validate agent configuration(s) using the agent-audit skill.

**Target**: ${ARGUMENTS:-all agents in ~/.claude/agents/}

Perform comprehensive validation:

- **YAML Frontmatter**: Check required fields (name, description, model)
- **Model Validity**: Ensure model is sonnet, opus, or haiku
- **Name Matching**: Verify name matches filename
- **Tool Restrictions**: Validate allowed/denied tools configuration
- **Focus Areas**: Review focus area quality and specificity
- **Approach Section**: Check methodology completeness
- **Context Economy**: Assess file size and efficiency
- **Best Practices**: Check against established agent patterns

Generate a structured evaluation report with:

- Status (PASS/NEEDS WORK/FAIL) for Correctness, Clarity, Effectiveness
- Specific findings for each category
- Context usage analysis
- Prioritized recommendations
- Next steps
```

## Common Mistakes to Avoid

❌ **DON'T** write explicit tool invocation syntax like `{Skill skill="name"}`
✅ **DO** write descriptive statements like `Invokes the **skill-name** skill`

❌ **DON'T** include complex logic or implementation details
✅ **DO** delegate to skills/agents that contain the logic

❌ **DON'T** forget the description field in frontmatter
✅ **DO** always include `description:` in frontmatter

❌ **DON'T** make commands longer than 80 lines
✅ **DO** keep simple commands ~11 lines, documented commands 25-27 lines

## Why This Pattern Works

1. **Claude interprets descriptions** - When Claude reads "Invokes the **skill-audit** skill", it knows to invoke that skill
2. **Natural language** - More readable than explicit tool syntax
3. **Flexible** - Claude can interpret variations in phrasing
4. **Self-documenting** - The delegation statement serves as documentation
5. **Consistent** - All commands follow the same pattern

## Testing Your Command

1. Create the command file in `~/.claude/commands/`
2. Run `/help` to verify it appears
3. Invoke the command: `/your-command-name`
4. Verify the skill/agent is invoked correctly
5. Test with arguments if applicable

## See Also

- **command-authoring skill** - Complete guide to creating commands
- **command-audit skill** - Validation and best practices
- **skills/command-audit/references/delegation-patterns.md** - Detailed delegation validation criteria

---
name: command-authoring
description: Guide for authoring slash commands that delegate to agents or skills. Use when creating, writing, or building /commands for user shortcuts. Helps design simple command files, choose delegation targets, handle arguments, and decide when to use commands vs skills. Expert in command patterns, best practices, and keeping commands focused.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - AskUserQuestion
---

## About Commands

Commands are user-invoked shortcuts that provide explicit control over when capabilities are used. They're typed as `/command-name` and typically delegate to agents or skills.

**Key characteristics**:

- **User-invoked** - Typed explicitly as `/command-name` (not auto-triggered)
- **Simple** - Delegate to agents/skills rather than containing complex logic
- **Focused** - Single, clear purpose
- **Explicit** - User controls timing of invocation
- **Discoverable** - Shown in `/help` output

**When to use commands**:

- User wants explicit shortcut for frequent task
- Simple delegation pattern
- User should control timing
- Creating convenience wrapper for agent/skill

## Core Philosophy

### Commands Should Be Simple

**Golden rule**: Commands delegate, they don't implement.

**Good command** (simple delegation):

```markdown
---
description: Audit shell scripts for best practices, security, and portability
---

# audit-bash

Audit shell scripts for best practices, security, and portability using the bash-audit skill.
```

**Bad command** (complex logic):

```markdown
# bad-example

# DON'T DO THIS - complex logic in command

Read all shell scripts, run ShellCheck, analyze results, generate report...
[50 lines of implementation details]
```

**Why keep it simple**:

- Easier to maintain
- Clear delegation target
- Less prone to errors
- Follows single responsibility principle

### Commands Are Explicit

Unlike skills (which auto-trigger), commands require user action.

**Use commands when**:

- User wants control over timing
- Action shouldn't happen automatically
- Frequently-used prompt that deserves shortcut
- Explicit workflow trigger

**Use skills when**:

- Should auto-trigger based on context
- User doesn't need to remember to invoke it
- Complex domain knowledge that enhances conversation

## Command Structure

### Required Elements

Every command must have:

1. **description field** (in frontmatter) - Required for `/help` and model invocation
2. **Command name heading** (# command-name)
3. **Clear purpose** - What the command does

### Optional Elements

Depending on complexity:

- **Usage section** - How to invoke, with/without arguments
- **What It Does** - Detailed explanation
- **Examples** - Sample invocations
- **Delegation** - Which agent/skill it uses
- **Use Cases** - When to use the command
- **Output** - What to expect

### Two Patterns

**Pattern 1: Simple Delegator** (6-10 lines)

- Just frontmatter + brief description
- Minimal documentation
- Clear delegation statement

**Pattern 2: Documented Delegator** (30-80 lines)

- Full usage instructions
- Examples and use cases
- Detailed delegation explanation
- What It Does section

**Choose based on**:

- Complexity of underlying agent/skill
- Whether arguments need explanation
- How often users will reference it

## Command Design Patterns

### Pattern 1: Simple Agent Delegator

**Use when**: Direct delegation to agent, no complex args, obvious purpose

**Example** (`/audit-bash`):

```markdown
---
description: Audit shell scripts for best practices, security, and portability
---

# audit-bash

Audit shell scripts for best practices, security, and portability using the bash-audit skill.
```

**Characteristics**:

- 6-8 lines total
- Minimal documentation
- Clear single purpose
- Delegates to one skill/agent

### Pattern 2: Skill Delegator

**Use when**: Invoking skill that provides complex workflow

**Example** (`/automate-git`):

```markdown
---
name: automate-git
description: Complete git workflow automation with atomic commits and PR creation
---

Execute the git-workflow skill to handle complete git workflow automation including branch management, atomic commits, history cleanup, and PR creation.
```

**Characteristics**:

- Very brief (one sentence delegation)
- Skill name in frontmatter (optional)
- Describes what skill does

### Pattern 3: Documented Agent Delegator

**Use when**: Agent has complex features, arguments need explanation, users need reference

**Example** (`/validate-claude-agent`):

````markdown
---
description: Validates a sub-agent configuration for correctness, clarity, and effectiveness
---

# validate-claude-agent

Validates a sub-agent configuration file for correctness, clarity, and effectiveness.

## Usage

```bash
/validate-claude-agent [agent-name]
```
````

- **With agent-name**: Validates the specified agent
- **Without args**: Validates all agents

## What It Does

[Detailed explanation of validation checks]

## Output

[What the user will see]

## Examples

[Sample invocations]

## Delegation

This command delegates to the **claude-code-evaluator** agent...

````markdown
**Characteristics**:

- 30-80 lines
- Full usage documentation
- Examples section
- Clear delegation explanation
- Use cases if helpful

### Pattern 4: Multi-Agent Orchestrator

**Use when**: Command coordinates multiple agents in sequence

**Example** (`/test-claude-skill`):

```markdown
---
description: Tests a skill's discoverability and effectiveness with sample queries
---

# test-claude-skill

## What It Does

This command delegates to specialized agents to perform comprehensive skill testing:

### Discovery Testing (via claude-code-skill-auditor)

[What this agent does]

### Functionality Testing (via claude-code-test-runner)

[What this agent does]

## Delegation

This command orchestrates two agents:

1. **claude-code-skill-auditor** agent: [purpose]
2. **claude-code-test-runner** agent: [purpose]
```
````

**Characteristics**:

- Documents multiple delegation targets
- Explains orchestration sequence
- Clarifies what each agent contributes

## Command Creation Process

### Step 1: Define Purpose

**Questions to ask**:

- What specific task does this command perform?
- Is this a shortcut for something users do frequently?
- Does a similar command already exist?
- Should this be a skill instead (auto-trigger)?

**Check existing commands**:

```bash
ls -la ~/.claude/commands/
```

### Step 2: Choose Delegation Target

**Single agent/skill**:

- Most commands delegate to one target
- Keep it simple and focused

**Multiple agents**:

- Only if workflow genuinely requires orchestration
- Document the sequence clearly

**No delegation** (rare):

- Only for very simple prompts
- Usually better as skill or agent

### Step 3: Design Arguments

**Argument handling**:

- Access full arguments: `$ARGUMENTS`
- Access individual args: `$1`, `$2`, etc.
- Arguments are optional vs required

**Examples**:

```markdown
/validate-claude-agent [agent-name]

# agent-name is optional - validates all if omitted

/test-claude-skill skill-name

# skill-name is required
```

**Best practices**:

- Make arguments optional when sensible
- Provide sensible defaults
- Document in Usage section

### Step 4: Write Description (Required!)

**Description goes in frontmatter** and is used by:

- `/help` command listing
- Model when invoking the command

**Requirements**:

- Clear, concise explanation of what command does
- 50-150 characters ideal
- Action-oriented

**Good examples**:

```yaml
description: Validates a sub-agent configuration for correctness, clarity, and effectiveness
description: Audit shell scripts for best practices, security, and portability
description: Tests a skill's discoverability and effectiveness with sample queries
```

**Bad examples**:

```yaml
description: Helps with stuff  # Too vague
description: A command  # Not descriptive
```

### Step 5: Choose Documentation Level

**Simple (6-10 lines)**:

- Obvious purpose
- No complex arguments
- Delegation target is clear

**Documented (30-80 lines)**:

- Arguments need explanation
- Multiple agents orchestrated
- Users will reference frequently
- Complex underlying capability

### Step 6: Create the File

**File location**: `~/.claude/commands/command-name.md`

**Filename conventions**:

- Use kebab-case: `command-name.md`
- Match command invocation: `/command-name`
- Descriptive, clear purpose

**Basic template**:

```markdown
---
description: [What the command does - REQUIRED]
---

# command-name

[Brief explanation or full documentation depending on pattern]

[Optional: Usage, Examples, Delegation sections]
```

### Step 7: Test the Command

**Test invocation**:

```text
/command-name
/command-name arg1
/command-name arg1 arg2
```

**Verify**:

1. Command appears in `/help` output
2. Description is clear and accurate
3. Delegation works correctly
4. Arguments are handled properly
5. Purpose is immediately obvious

## Commands vs Skills Decision Guide

**📄 See [when-to-use-what.md](../../references/when-to-use-what.md) for complete decision guide including agents and output-styles (shared)**

**Quick guide**:

**Use a Command when**:

- User wants explicit control over timing
- Action should be deliberate, not automatic
- Frequently-used prompt deserves shortcut
- User-initiated workflow
- Simple wrapper around agent/skill

**Use a Skill when**:

- AI should auto-discover capability
- Complex domain knowledge
- Should trigger on user queries automatically
- Needs progressive disclosure with references/
- Automatic workflow assistance

## Common Mistakes to Avoid

1. **Complex logic in command** - Commands should delegate, not implement
2. **Missing description** - Frontmatter description is required
3. **No delegation info** - Unclear what agent/skill it uses
4. **Vague purpose** - Command should have single, clear focus
5. **Too many arguments** - Keep it simple, 0-2 args typically
6. **Not testing with /help** - Verify command appears correctly
7. **Poor naming** - Use descriptive, action-oriented names

## Examples from Existing Commands

### Example 1: Simple Delegator (`/audit-bash`)

```markdown
---
description: Audit shell scripts for best practices, security, and portability
---

# audit-bash

Audit shell scripts for best practices, security, and portability using the bash-audit skill.
```

**Why it's good**:

- Minimal (6 lines)
- Clear purpose
- Simple delegation
- Descriptive name
- Complete frontmatter

### Example 2: Documented Delegator (`/validate-claude-agent`)

````markdown
---
description: Validates a sub-agent configuration for correctness, clarity, and effectiveness
---

# validate-claude-agent

Validates a sub-agent configuration file for correctness, clarity, and effectiveness.

## Usage

```bash
/validate-claude-agent [agent-name]
```
````

- **With agent-name**: Validates the specified agent
- **Without args**: Validates all agents

## What It Does

This command invokes the claude-code-evaluator agent to perform comprehensive validation:

- YAML Frontmatter checks
- Model validity
- Name matching
- Structure review
  [etc.]

## Delegation

This command delegates to the **claude-code-evaluator** agent...

````markdown
**Why it's good**:

- Clear usage with argument explanation
- Documents delegation target
- Shows what validations occur
- Optional argument with sensible default

### Example 3: Multi-Agent Orchestrator (`/test-claude-skill`)

```markdown
---
description: Tests a skill's discoverability and effectiveness with sample queries
---

# test-claude-skill

## What It Does

This command delegates to specialized agents to perform comprehensive skill testing:

### Discovery Testing (via claude-code-skill-auditor)

- Analyzes frontmatter description for trigger quality
- Generates test queries
  [etc.]

### Functionality Testing (via claude-code-test-runner)

- Tests whether skill would be properly triggered
  [etc.]

## Delegation

This command orchestrates two agents:

1. **claude-code-skill-auditor** agent: [purpose]
2. **claude-code-test-runner** agent: [purpose]
```
````

**Why it's good**:

- Clearly explains multi-agent orchestration
- Documents what each agent contributes
- Shows comprehensive workflow

## Tips for Success

1. **Keep commands under 50 lines** unless truly necessary
2. **Delegate, don't implement** - let agents/skills do the work
3. **Test with `/help`** to verify display
4. **Use descriptive names** - action verbs work well
5. **Document delegation target** - make it clear what runs
6. **Make purpose immediately clear** - no guessing
7. **Optional arguments are better** - provide defaults
8. **Start simple** - can always add documentation later

## Quick Start Checklist

Creating a new command:

- [ ] Identify what agent/skill to delegate to
- [ ] Choose descriptive name (kebab-case)
- [ ] Write clear description (50-150 chars)
- [ ] Decide: simple (6-10 lines) or documented (30-80 lines)?
- [ ] Create file at `~/.claude/commands/command-name.md`
- [ ] Add required frontmatter with description
- [ ] Document delegation target
- [ ] Test with `/help` and invocation
- [ ] Verify arguments work correctly (if any)

## Reference to Standards

For detailed standards and validation:

- **Naming conventions** - Use kebab-case for command names
- **Frontmatter requirements** - description field is required
- **File organization** - `~/.claude/commands/command-name.md`

See `claude-code-audit` skill for comprehensive standards.

# Argument Handling

Guide for validating command argument handling patterns and defaults.

## Core Principle

**Commands should pass user arguments to their delegation targets.**

Arguments passed = user input reaches target
Arguments ignored = wasted user input

## What Are Arguments

Arguments are user-provided input passed to commands:

**Usage**:

```
/command-name argument1 argument2
```

**In command file**:

- `$ARGUMENTS`: All arguments as single string
- `$1`, `$2`, `$3`: Individual positional arguments
- `${ARGUMENTS:-default}`: Arguments with default fallback

**Example**:

```
User types: /validate-agent bash-scripting

In command: $ARGUMENTS = "bash-scripting"
```

## Argument Patterns

### Pattern 1: Pass-Through (Most Common)

**When to use**: Pass all user input unchanged

**Structure**:

```markdown
{Skill skill="skill-name" args="$ARGUMENTS"}
```

**Example**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**User types**:

```
/validate-agent bash-scripting
```

**Result**: agent-auditor receives "bash-scripting"

**Characteristics**:

- Simple pass-through
- No modification
- Most common pattern

### Pattern 2: With Default Value

**When to use**: Provide sensible default if no argument

**Structure**:

```markdown
{Skill skill="skill-name" args="${ARGUMENTS:-default-value}"}
```

**Example**:

```markdown
{Skill skill="agent-auditor" args="${ARGUMENTS:-bash-scripting}"}
```

**User types** (with argument):

```
/validate-agent claude-code-evaluator
```

**Result**: agent-auditor receives "claude-code-evaluator"

**User types** (no argument):

```
/validate-agent
```

**Result**: agent-auditor receives "bash-scripting" (default)

**Characteristics**:

- Graceful fallback
- Sensible default
- User can override

### Pattern 3: Positional Arguments

**When to use**: Multiple distinct arguments

**Structure**:

```markdown
{Task prompt="Validate file $1 with rules $2"}
```

**Example**:

```markdown
{Task subagent_type="validator" prompt="Validate $1 in $2 directory"}
```

**User types**:

```
/validate agent.md agents/
```

**Result**:

- `$1` = "agent.md"
- `$2` = "agents/"

**Characteristics**:

- Multiple arguments
- Position-dependent
- Less common (usually use $ARGUMENTS)

### Pattern 4: Constructed Prompt

**When to use**: Build detailed prompt from arguments

**Structure**:

```markdown
{Task prompt="[template with $ARGUMENTS embedded]"}
```

**Example**:

```markdown
{Task subagent_type="agent-auditor" description="Audit $ARGUMENTS" prompt="Audit the $ARGUMENTS agent for model selection appropriateness, tool restriction accuracy, focus area quality, and approach completeness."}
```

**User types**:

```
/validate-agent bash-scripting
```

**Result**: Full prompt with "bash-scripting" embedded

**Characteristics**:

- Detailed prompt construction
- Context added around argument
- Common for Task tool

## Validation Criteria

### Criterion 1: Arguments Are Used

**Good** (arguments used):

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**Bad** (arguments ignored):

```markdown
{Skill skill="agent-auditor"}
```

**Test**: Does the delegation use $ARGUMENTS, $1, or similar?

### Criterion 2: Sensible Defaults (Optional)

**Good** (useful default):

```markdown
{Skill skill="agent-auditor" args="${ARGUMENTS:-bash-scripting}"}
```

**Bad** (unhelpful default):

```markdown
{Skill skill="agent-auditor" args="${ARGUMENTS:-foo}"}
```

**Test**: If default provided, is it sensible and helpful?

### Criterion 3: Usage Documented (For Documented Commands)

**Good** (usage explained):

```markdown
## Usage

    /validate-agent [agent-name]

Validates the specified agent. If no agent name provided, defaults to bash-scripting.
```

**Bad** (no usage docs for complex command):

```markdown
# validate-agent

[40 lines of docs, no usage section]
```

**Test**: If command is documented (30-80 lines), are arguments explained?

## Common Anti-Patterns

### Anti-Pattern 1: Arguments Ignored

**Problem**:

```markdown
{Skill skill="agent-auditor"}
```

**User types**:

```
/validate-agent bash-scripting
```

**Result**: "bash-scripting" is lost, agent-auditor gets nothing

**Fix**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

### Anti-Pattern 2: Hardcoded Values

**Problem**:

```markdown
{Skill skill="agent-auditor" args="bash-scripting"}
```

**User types**:

```
/validate-agent claude-code-evaluator
```

**Result**: User wants "claude-code-evaluator", but command always uses "bash-scripting"

**Fix**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

### Anti-Pattern 3: No Default When Needed

**Problem**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**User types** (no argument):

```
/validate-agent
```

**Result**: agent-auditor gets empty string, may fail

**Fix** (if default makes sense):

```markdown
{Skill skill="agent-auditor" args="${ARGUMENTS:-bash-scripting}"}
```

Or document that argument is required.

### Anti-Pattern 4: Unhelpful Default

**Problem**:

```markdown
{Skill skill="agent-auditor" args="${ARGUMENTS:-example}"}
```

**Default**: "example" (not a real agent)

**Fix**: Use real, useful default:

```markdown
{Skill skill="agent-auditor" args="${ARGUMENTS:-bash-scripting}"}
```

Or no default if one doesn't make sense.

### Anti-Pattern 5: Complex Argument Processing

**Problem**:

```markdown
Parse $ARGUMENTS.
Split by comma.
For each part:
Validate individually.
Combine results.
```

**Why bad**: Complex processing in command

**Fix**: Move to skill, command passes arguments:

```markdown
{Skill skill="batch-auditor" args="$ARGUMENTS"}
```

Skill handles parsing and processing.

## Argument Documentation

### For Simple Commands (6-10 lines)

**No usage docs needed** (obvious from name):

```yaml
---
name: audit-bash
description: Audit shell scripts for security and quality
---
{ Skill skill="hook-auditor" args="$ARGUMENTS" }
```

**User understands**: `/audit-bash script.sh`

### For Documented Commands (30-80 lines)

**Usage section required**:

```markdown
## Usage

    /validate-agent [agent-name]

Validates the specified agent configuration.
If no agent name provided, defaults to bash-scripting.

### Examples

    /validate-agent bash-scripting
    /validate-agent claude-code-evaluator
```

**Components**:

- Syntax with [optional] or <required>
- Explanation of what argument does
- Default behavior if omitted
- Examples showing usage

## Default Value Selection

### When to Provide Default

**Good candidates for defaults**:

- Most common use case
- Reasonable fallback
- Safe default (won't break anything)
- Example/demo value

**Examples**:

```markdown
# Default to most common agent

${ARGUMENTS:-bash-scripting}

# Default to current directory

${ARGUMENTS:-.}

# Default to all (comprehensive check)

${ARGUMENTS:-all}
```

### When NOT to Provide Default

**Skip default when**:

- No sensible default exists
- Every use case is different
- Required argument (should fail if missing)
- Default would be misleading

**Example** (no default appropriate):

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

If no argument → agent-auditor decides behavior

## Skill Tool vs Task Tool Argument Passing

### Skill Tool

**Pattern**:

```markdown
{Skill skill="skill-name" args="$ARGUMENTS"}
```

**Characteristics**:

- Uses `args` parameter
- Simple pass-through
- Skill receives argument string

### Task Tool

**Pattern**:

```markdown
{Task subagent_type="agent-name" description="Brief" prompt="Detailed prompt with $ARGUMENTS"}
```

**Characteristics**:

- Arguments embedded in prompt
- More control over context
- Can construct detailed prompt

**Example**:

```markdown
{Task subagent_type="agent-auditor" description="Audit $ARGUMENTS" prompt="Audit the $ARGUMENTS agent for model selection, tool restrictions, focus areas, and approach methodology."}
```

## Validation Checklist

When auditing argument handling:

- [ ] **Arguments used**: $ARGUMENTS or $1, $2, etc. present
- [ ] **Passed to target**: Arguments reach delegated skill/agent
- [ ] **Default sensible** (if provided): Useful fallback value
- [ ] **Usage documented** (if 30-80 line command): Syntax and examples
- [ ] **No hardcoded values**: User input not overridden
- [ ] **No complex processing**: Simple pass-through, not parsing/transforming

## Examples by Pattern

### Excellent Pass-Through

**Command**: audit-bash

```yaml
---
name: audit-bash
description: Audit shell scripts for security and quality
---
{ Skill skill="hook-auditor" args="$ARGUMENTS" }
```

**Analysis**:

- ✓ Arguments passed: $ARGUMENTS → hook-auditor
- ✓ Simple pass-through
- ✓ No complexity

**User types**: `/audit-bash script.sh`

**Result**: hook-auditor receives "script.sh"

### Good Default Handling

**Command**: validate-agent

```yaml
---
name: validate-agent
description: Validate agent configurations
---

{Skill skill="agent-auditor" args="${ARGUMENTS:-bash-scripting}"}
```

**Analysis**:

- ✓ Arguments passed with default
- ✓ Sensible default (bash-scripting)
- ✓ User can override

**User types**: `/validate-agent` (no argument)

**Result**: agent-auditor receives "bash-scripting" (default)

### Poor: Arguments Ignored

**Command**: bad-command

```yaml
---
name: bad-command
description: Does validation
---
{ Skill skill="agent-auditor" }
```

**Analysis**:

- ✗ No arguments passed
- ✗ User input lost

**User types**: `/bad-command bash-scripting`

**Result**: "bash-scripting" ignored, agent-auditor gets nothing

**Fix**: Add `args="$ARGUMENTS"`

## Summary

**Key principles**:

1. **Pass arguments**: Use $ARGUMENTS in delegation
2. **Sensible defaults** (optional): Provide helpful fallback
3. **Document usage** (if documented command): Explain argument syntax
4. **No complex processing**: Simple pass-through only
5. **Don't hardcode**: User input should reach target

**Common patterns**:

```markdown
# Simple pass-through (most common)

{Skill skill="skill-name" args="$ARGUMENTS"}

# With default

{Skill skill="skill-name" args="${ARGUMENTS:-default}"}

# Task tool with embedded arguments

{Task prompt="Do something with $ARGUMENTS"}
```

**When in doubt**: Use `$ARGUMENTS` to pass user input unchanged.

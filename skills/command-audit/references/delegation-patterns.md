# Delegation Patterns

Guide for validating command delegation clarity and target selection.

## Core Principle

**Commands delegate to agents or skills - they don't implement logic themselves.**

Clear delegation = explicit target invocation
Unclear delegation = vague instructions or complex logic

## What Is Delegation

Delegation is the act of passing work to another component:

- **Target**: The agent or skill that performs the work
- **Invocation**: How the target is called (Task tool, Skill tool)
- **Arguments**: User input passed to the target
- **Single responsibility**: One delegation per command

**Example from audit-bash**:

```markdown
Launch hook-auditor skill to validate Bash scripts:

{Skill skill="hook-auditor" args="$ARGUMENTS"}
```

This is **clear delegation**: Explicit target (hook-auditor), clear invocation (Skill tool), arguments passed ($ARGUMENTS).

## Delegation Patterns

### Pattern 1: Simple Skill Delegation

**When to use**: Delegating to a skill

**Structure**:

```markdown
{Skill skill="skill-name" args="$ARGUMENTS"}
```

**Example**:

```markdown
Launch skill-auditor to validate skill discoverability:

{Skill skill="skill-auditor" args="$ARGUMENTS"}
```

**Characteristics**:

- Uses Skill tool
- Passes arguments with args parameter
- Minimal wrapper text (1-2 lines)

### Pattern 2: Simple Agent Delegation

**When to use**: Delegating to an agent via Task tool

**Structure**:

```markdown
{Task subagent_type="agent-name" description="Brief description" prompt="Detailed prompt with $ARGUMENTS"}
```

**Example**:

```markdown
Launch claude-code-evaluator agent to validate configuration:

{Task subagent_type="claude-code-evaluator" description="Validate configuration" prompt="Validate the following configuration file: $ARGUMENTS"}
```

**Characteristics**:

- Uses Task tool
- Includes subagent_type, description, prompt
- Passes arguments in prompt
- Brief wrapper text

### Pattern 3: Delegator with Context

**When to use**: Need to provide context before delegation

**Structure**:

```markdown
Brief explanation of what will happen.

{Tool invocation}
```

**Example**:

```markdown
This command validates agent configurations using specialized auditors.
It checks model selection, tool restrictions, focus areas, and approach methodology.

{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**Characteristics**:

- 2-3 sentences of context
- Then clear delegation
- Still simple (10-20 lines total)

## Validation Criteria

### Criterion 1: Explicit Target

**Good** (names specific component):

```markdown
{Skill skill="hook-auditor" args="$ARGUMENTS"}
```

**Bad** (vague):

```markdown
Validate the hooks and check for issues.
```

**Test**: Can you identify the exact agent or skill being invoked?

### Criterion 2: Clear Invocation

**Good** (uses tool):

```markdown
{Task subagent_type="bash-scripting" description="..." prompt="..."}
```

**Bad** (unclear how):

```markdown
Run the bash scripting agent on the file.
```

**Test**: Is the invocation mechanism clear (Task/Skill tool)?

### Criterion 3: Arguments Passed

**Good** (passes user input):

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**Bad** (ignores arguments):

```markdown
{Skill skill="agent-auditor"}
```

**Test**: Are user-provided arguments passed to the target?

### Criterion 4: Single Responsibility

**Good** (one delegation):

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**Bad** (multiple delegations):

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
{Skill skill="claude-code-evaluator"}
{Task subagent_type="test-runner" prompt="Test it"}
```

**Test**: Does the command delegate to one component?

## Common Anti-Patterns

### Anti-Pattern 1: Vague Instructions

**Problem**:

```markdown
Analyze the agent file and provide feedback.
```

**Why bad**: No clear target, unclear how work gets done

**Fix**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

### Anti-Pattern 2: Multiple Delegations

**Problem**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
{Skill skill="claude-code-evaluator" args="$ARGUMENTS"}
{Task subagent_type="test-runner" prompt="Test $ARGUMENTS"}
```

**Why bad**: Too complex, should be orchestrator skill

**Fix**: Create orchestrator skill, command delegates to it

### Anti-Pattern 3: Complex Logic Instead of Delegation

**Problem**:

```markdown
Read the agent file.
If it has errors, fix them.
Otherwise, validate with agent-auditor.
Generate a report.
```

**Why bad**: Complex logic in command, not delegation

**Fix**: Move logic to skill, command delegates:

```markdown
{Skill skill="agent-validator" args="$ARGUMENTS"}
```

### Anti-Pattern 4: No Tool Invocation

**Problem**:

```markdown
Use the hook-auditor skill to validate hooks.
```

**Why bad**: Instruction without actual invocation

**Fix**:

```markdown
{Skill skill="hook-auditor" args="$ARGUMENTS"}
```

### Anti-Pattern 5: Hardcoded Arguments

**Problem**:

```markdown
{Skill skill="agent-auditor" args="bash-scripting"}
```

**Why bad**: Ignores user input, always audits same agent

**Fix**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

## Delegation to Skills vs Agents

### When to Delegate to Skill

**Use Skill tool when**:

- Target is a user-invocable skill
- Simple invocation pattern
- Arguments passed directly

**Example**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**Tools**: Skill tool

### When to Delegate to Agent

**Use Task tool when**:

- Target is an agent (subagent_type)
- Need custom description or prompt
- More control over invocation

**Example**:

```markdown
{Task subagent_type="claude-code-evaluator" description="Validate agent" prompt="Validate the following agent configuration: $ARGUMENTS"}
```

**Tools**: Task tool

## Argument Passing Patterns

### Pattern 1: Pass-Through

**Use case**: Pass all arguments unchanged

```markdown
{Skill skill="skill-name" args="$ARGUMENTS"}
```

### Pattern 2: With Default

**Use case**: Provide default if no argument

```markdown
{Skill skill="agent-auditor" args="${ARGUMENTS:-bash-scripting}"}
```

### Pattern 3: Positional Arguments

**Use case**: Multiple distinct arguments

```markdown
{Task prompt="Validate file $1 with rules $2"}
```

### Pattern 4: Constructed Prompt

**Use case**: Build prompt from arguments

```markdown
{Task prompt="Audit the $ARGUMENTS agent for model selection, tool restrictions, and focus areas"}
```

## Validation Checklist

When auditing delegation:

- [ ] **Target explicit**: Names specific agent or skill
- [ ] **Invocation clear**: Uses Task or Skill tool
- [ ] **Arguments passed**: User input reaches target
- [ ] **Single delegation**: One target per command
- [ ] **No complex logic**: Delegates, doesn't implement
- [ ] **Tool syntax correct**: Valid Task/Skill invocation

## Examples by Pattern

### Excellent Delegation

**Command**: audit-bash

```yaml
---
name: audit-bash
description: Audit shell scripts for security and quality
---

Launch hook-auditor skill to validate Bash scripts:

{Skill skill="hook-auditor" args="$ARGUMENTS"}
```

**Analysis**:

- ✓ Explicit target: hook-auditor skill
- ✓ Clear invocation: Skill tool
- ✓ Arguments passed: $ARGUMENTS
- ✓ Single delegation: One skill
- ✓ Simple: 8 lines total

**Verdict**: Perfect delegation pattern

### Good Delegation with Context

**Command**: validate-agent

```yaml
---
name: validate-agent
description: Comprehensive agent configuration validation
---

# validate-agent

Validates agent configurations using agent-auditor skill.

## Usage

    /validate-agent [agent-name]

Launch agent-auditor:

{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**Analysis**:

- ✓ Explicit target: agent-auditor skill
- ✓ Clear invocation: Skill tool
- ✓ Arguments passed: $ARGUMENTS
- ✓ Single delegation: One skill
- ✓ Documented: Usage section included

**Verdict**: Good documented delegator

### Poor Delegation

**Command**: do-validation (hypothetical)

```markdown
Analyze the configuration file and check for errors.
Provide feedback and suggestions.
```

**Analysis**:

- ✗ No explicit target
- ✗ No clear invocation
- ✗ Arguments not passed
- ✗ Vague instructions

**Verdict**: Needs complete rewrite with clear delegation

## Integration with Simplicity

**Delegation enables simplicity**:

- Clear delegation → Command stays simple (6-80 lines)
- Complex logic → Should be in skill/agent, not command

**Test**: If you're writing if/else or loops in a command, you need a skill instead.

## Summary

**Key Principles**:

1. **Explicit target**: Name the agent or skill
2. **Clear invocation**: Use Task or Skill tool
3. **Pass arguments**: User input reaches target
4. **Single delegation**: One target per command
5. **No complex logic**: Delegate, don't implement

**Good delegation example**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**Bad delegation example**:

```markdown
Analyze the agent and provide feedback.
```

**When in doubt**: Name the target explicitly and use the appropriate tool (Task/Skill).

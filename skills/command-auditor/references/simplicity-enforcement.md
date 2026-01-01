# Simplicity Enforcement

Guide for enforcing command simplicity and determining when to migrate to skills.

## Core Principle

**Commands should be simple delegators, not complex implementations.**

Simple command (6-80 lines) = appropriate
Complex command (>80 lines or complex logic) = should be skill

## Simplicity Targets

### Simple Delegator (6-10 lines)

**Structure**:

````yaml
---
name: command-name
description: Brief description
---
Brief explanation (optional 1-2 lines).

{Tool delegation}
```text

**Line count**: 6-10 lines total (frontmatter + content)

**Example**:

```yaml
---
name: audit-bash
description: Audit shell scripts for security and quality
---
{ Skill skill="hook-auditor" args="$ARGUMENTS" }
```text

**Characteristics**:

- Minimal documentation
- Single delegation
- No complex logic
- Fast to read and understand

### Documented Delegator (30-80 lines)

**Structure**:

```yaml
---
name: command-name
description: Comprehensive description
---

# Command Name

Brief overview.

## Usage

    /command-name [arguments]

## What It Does

1. Step one
2. Step two
3. Step three

## Examples

    /command-name example-input

{Tool delegation}
```text

**Line count**: 30-80 lines total

**Example**:

```yaml
---
name: validate-agent
description: Comprehensive agent configuration validation
---

# validate-agent

Validates agent configurations using specialized auditors.

## Usage

    /validate-agent [agent-name]

## What It Does

1. Invokes agent-auditor for agent-specific validation
2. Checks model selection, tool restrictions, focus areas
3. Generates comprehensive audit report

## Examples

    /validate-agent bash-scripting
    /validate-agent claude-code-evaluator

{Skill skill="agent-auditor" args="$ARGUMENTS"}
```text

**Characteristics**:

- Full documentation
- Usage section with syntax
- "What It Does" explanation
- Examples section
- Still single delegation at end

### Too Complex (>80 lines)

**Indicators**:

- > 80 lines total
- Multiple tool calls
- If/else logic
- Loop constructs
- Complex processing

**Decision**: Should be a skill, not a command

## Complexity Assessment

### Line Count Check

**Command**:

```bash
wc -l commands/command-name.md
```text

**Interpretation**:

- **6-10 lines**: Simple delegator ✓
- **30-80 lines**: Documented delegator ✓ (if justified)
- **>80 lines**: Too complex ✗ (should be skill)

### Logic Complexity Check

**Simple** (acceptable):

```markdown
{Skill skill="skill-name" args="$ARGUMENTS"}
```text

**Complex** (too much for command):

```markdown
Read the file.
If it has errors:
Fix the errors.
Validate again.
Else:
Generate report.
```text

**Test**: If you see if/else, loops, or multiple steps → Too complex

### Tool Call Count

**Simple** (acceptable):

```markdown
{Skill skill="skill-name" args="$ARGUMENTS"}
```text

**Complex** (too much):

```markdown
{Read file_path="..."}
{Grep pattern="..." path="..."}
{Task subagent_type="..."}
{Skill skill="..."}
{Write file_path="..."}
```text

**Test**: If >1 tool call → Probably too complex

## Command vs Skill Decision

### Should Be a Command

**Criteria** (all must be true):

1. **User-invoked**: User types /command-name
2. **Simple delegation**: 6-80 lines, single delegation
3. **Convenience wrapper**: Shortcut for common operation
4. **No complex logic**: No if/else, loops, processing

**Examples**:

- `/audit-bash` → Delegates to hook-auditor
- `/validate-agent` → Delegates to agent-auditor
- `/test-skill` → Delegates to claude-code-test-runner

**Pattern**: "Slash command convenience wrapper for skill/agent invocation"

### Should Be a Skill

**Criteria** (any one triggers migration):

1. **Auto-triggers**: User queries trigger it (not slash command)
2. **Complex logic**: >80 lines or if/else/loops
3. **Multiple tools**: Multiple tool calls or processing
4. **Discovery-optimized**: Needs comprehensive description for auto-triggering

**Examples**:

- `agent-auditor` (auto-triggers on "audit my agent")
- `skill-auditor` (auto-triggers on "check my skill")
- `git-workflow` (complex multi-step automation)

**Pattern**: "Auto-triggering capability with complex logic or discovery requirements"

### Decision Flowchart

```text
Start: What is this component?

User types /name explicitly?
├─ Yes → Might be command, continue
└─ No (auto-triggers on queries) → SKILL

Does it have complex logic (if/else, loops, >80 lines)?
├─ Yes → SKILL
└─ No → Continue

Does it make multiple tool calls or process data?
├─ Yes → SKILL
└─ No → COMMAND (simple delegator)
```text

## Migration Guidance

### Migrating Command → Skill

**When to migrate**:

- Command exceeds 80 lines
- Command has complex logic
- Command makes multiple tool calls
- Users would benefit from auto-triggering

**Process**:

1. Create skill with command's functionality
2. Update command to delegate to skill
3. Add comprehensive description to skill for discovery
4. Test skill auto-triggers on expected queries

**Example**:

**Before** (complex command):

```yaml
---
name: comprehensive-audit
description: Full audit of all components
---

# comprehensive-audit

[100 lines of complex logic with multiple tool calls]

{Task ...}
{Skill ...}
{Read ...}
{Grep ...}
# etc.
```text

**After** (simple command + skill):

**Command**:

```yaml
---
name: comprehensive-audit
description: Full audit of all components
---
{ Skill skill="audit-coordinator" args="$ARGUMENTS" }
```text

**Skill** (audit-coordinator):

```yaml
---
name: audit-coordinator
description: Comprehensive audit orchestration. Use when auditing entire setup, checking all components, or validating complete configuration. Auto-triggers on "audit everything", "check my setup", etc.
allowed-tools: [Task, Skill, Read]
---
[Full implementation with logic, multiple tool calls, etc.]
```text

### Keeping as Command

**When to keep as command**:

- 6-80 lines total
- Single delegation
- User-invoked only (slash command pattern)
- No complex logic

**Justification required for 30-80 lines**:

- Why is documentation needed?
- What makes this different from 6-10 line simple delegator?
- Is usage section truly necessary?

**Example justification**:

```markdown
# validate-agent

This command has full documentation (40 lines) because:

1. Users need usage syntax explanation
2. Examples help understand argument format
3. "What It Does" clarifies the multi-step validation process

Despite full docs, delegation remains simple (single Skill call).
```text

## Complexity Anti-Patterns

### Anti-Pattern 1: Command Implements Logic

**Problem**:

```markdown
Read the agent file.
Parse the frontmatter.
Validate model field.
Check tool restrictions.
Generate report.
```text

**Why bad**: Implements logic instead of delegating

**Fix**: Move to skill, command delegates to it

### Anti-Pattern 2: Multiple Tool Calls

**Problem**:

```markdown
{Read file_path="agents/bash-scripting.md"}
{Grep pattern="model:" path="agents/"}
{Task subagent_type="claude-code-evaluator" prompt="..."}
{Write file_path="report.md" content="..."}
```text

**Why bad**: Too many tool calls, complex orchestration

**Fix**: Create orchestrator skill

### Anti-Pattern 3: Conditional Logic

**Problem**:

```markdown
If file exists:
Validate it
Else:
Create it first
Then validate
```text

**Why bad**: Complex branching logic

**Fix**: Move to skill with decision logic

### Anti-Pattern 4: Loop Constructs

**Problem**:

```markdown
For each agent file:
Validate with agent-auditor
Collect results
Generate summary report
```text

**Why bad**: Loop processing, result aggregation

**Fix**: Create skill for batch processing

## Documentation Proportionality

### When Minimal Docs Appropriate

**6-10 line simple delegator**:

- Name and description in frontmatter
- Optional: 1-2 line explanation
- No usage section (obvious from name)
- No examples (straightforward)

**Example**:

```yaml
---
name: audit-bash
description: Audit shell scripts for security and quality
---
{ Skill skill="hook-auditor" args="$ARGUMENTS" }
```text

### When Full Docs Appropriate

**30-80 line documented delegator**:

- Name and description in frontmatter
- Usage section with syntax
- "What It Does" explanation (3-5 steps)
- Examples section (2-3 examples)
- Optional: Tips or notes

**When justified**:

- Complex argument syntax
- Multi-step process users should understand
- Not obvious from name what it does
- Benefits from usage examples

**Example**:

```yaml
---
name: validate-agent
description: Comprehensive agent configuration validation
---

# validate-agent

## Usage

    /validate-agent [agent-name]

## What It Does

1. Validates model selection
2. Checks tool restrictions
3. Assesses focus areas
4. Reviews approach methodology

## Examples

    /validate-agent bash-scripting

{Skill skill="agent-auditor" args="$ARGUMENTS"}
```text

### When Docs Too Excessive

**Problem**: 60 lines of docs for simple delegation

**Fix**: Remove excessive documentation or justify each section

## Validation Checklist

When auditing command simplicity:

- [ ] **Line count**: 6-10 (simple) or 30-80 (documented)
- [ ] **Single delegation**: One tool call
- [ ] **No complex logic**: No if/else, loops
- [ ] **Documentation proportional**: Matches complexity
- [ ] **Should be command**: Not better as skill

## Examples by Complexity

### Excellent Simple Delegator

**Command**: audit-bash (8 lines)

```yaml
---
name: audit-bash
description: Audit shell scripts for security and quality
---
{ Skill skill="hook-auditor" args="$ARGUMENTS" }
```text

**Verdict**: ✓ Perfect simple delegator

### Good Documented Delegator

**Command**: validate-agent (45 lines)

```yaml
---
name: validate-agent
description: Comprehensive agent configuration validation
---

# validate-agent

[Usage, What It Does, Examples sections]

{Skill skill="agent-auditor" args="$ARGUMENTS"}
```text

**Verdict**: ✓ Good documented delegator (docs justified by complexity)

### Too Complex (Should Be Skill)

**Command**: comprehensive-audit (120 lines)

```markdown
[Multiple tool calls, if/else logic, loop processing, result aggregation]
```text

**Verdict**: ✗ Too complex, should be skill

## Summary

**Simplicity targets**:

- Simple: 6-10 lines (frontmatter + delegation)
- Documented: 30-80 lines (frontmatter + docs + delegation)
- Too complex: >80 lines or complex logic → Should be skill

**Key principles**:

1. **Delegate, don't implement**: Commands call skills/agents
2. **Single tool call**: One delegation per command
3. **No complex logic**: No if/else, loops, processing
4. **Documentation matches complexity**: Minimal for simple, full for documented

**Decision rule**: If >80 lines OR complex logic → Make it a skill

**When in doubt**: Start simple (6-10 lines), add docs only if truly needed.
````

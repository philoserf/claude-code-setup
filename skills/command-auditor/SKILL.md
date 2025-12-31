---
name: command-auditor
description: Validates command delegation patterns, simplicity, and documentation proportionality. Use when reviewing, auditing, or improving commands, checking delegation clarity, enforcing simplicity (6-10 lines simple, 30-80 lines documented), validating argument handling, or assessing documentation appropriateness. Also triggers when user asks about command best practices, whether a command should be a skill instead, or needs help with command structure.
allowed-tools: [Read, Grep, Glob, Bash]
---

## Reference Files

Advanced command validation guidance:

- [delegation-patterns.md](references/delegation-patterns.md) - Delegation clarity and target selection validation
- [simplicity-enforcement.md](references/simplicity-enforcement.md) - Simplicity vs complexity assessment and skill migration criteria
- [argument-handling.md](references/argument-handling.md) - Argument parsing patterns and default value validation
- [documentation-proportionality.md](references/documentation-proportionality.md) - Documentation level appropriateness (minimal vs full)
- [examples.md](references/examples.md) - Good vs poor command comparisons and full audit reports

---

# Command Auditor

Validates command configurations for delegation clarity, simplicity, and documentation proportionality.

## Quick Start

**Basic audit workflow**:

1. Read command file
2. Assess delegation pattern clarity
3. Enforce simplicity (6-10 simple, 30-80 documented)
4. Validate argument handling
5. Check documentation proportionality
6. Decide: Should this be a skill instead?
7. Generate audit report

**Example usage**:

```text
User: "Audit my validate-agent command"
→ Reads commands/validate-agent.md
→ Validates delegation, simplicity, arguments, docs
→ Generates report with findings and recommendations
```

## Command Audit Checklist

### Critical Issues

Must be fixed for command to function correctly:

- [ ] **Valid markdown file** - Proper frontmatter and structure
- [ ] **name field present** - Command name defined
- [ ] **Clear delegation target** - Explicit agent or skill invocation
- [ ] **Simplicity enforced** - 6-10 lines (simple) or 30-80 lines (documented)
- [ ] **No complex logic** - Delegates to agent/skill, doesn't implement

### Important Issues

Should be fixed for optimal command performance:

- [ ] **Description comprehensive** - 100-300 chars with use cases
- [ ] **Arguments handled properly** - $ARGUMENTS vs $1, sensible defaults
- [ ] **Documentation proportional** - Minimal for simple, full for documented
- [ ] **Single responsibility** - One clear purpose
- [ ] **Scope correct** - Should be command (not skill)

### Nice-to-Have Improvements

Polish for excellent command quality:

- [ ] **Usage examples** (for documented commands)
- [ ] **Error handling** (for complex delegators)
- [ ] **Argument validation** (for required arguments)
- [ ] **Concise description** - Optimized for /help output

## Audit Workflow

### Step 1: Read Command File

Identify the command file to audit:

```bash
# Single command
Read commands/validate-agent.md

# Find all commands
Glob commands/*.md
```

### Step 2: Assess Delegation Pattern

**Check delegation target**:

**Good** (clear delegation):

```markdown
Launch the claude-code-evaluator agent to validate the configuration:

{Task subagent_type="claude-code-evaluator" description="Validate agent" prompt="..."}
```

**Poor** (unclear delegation):

```markdown
Do some validation and check the agent file.
```

**Validation criteria**:

- **Explicit target**: Clearly names agent or skill to invoke
- **Clear invocation**: Uses Task/Skill tool or delegates to agent
- **Single target**: Delegates to one component (not multiple)

See [delegation-patterns.md](references/delegation-patterns.md) for patterns.

### Step 3: Enforce Simplicity

**Check file size and complexity**:

```bash
wc -l commands/validate-agent.md
```

**Patterns**:

- **6-10 lines**: Simple delegator (minimal documentation)
- **30-80 lines**: Documented delegator (full documentation)
- **>80 lines**: Too complex - should be skill or agent

**Red flags**:

- Complex logic (if/else, loops)
- Multiple tool calls
- Extensive processing
- > 80 lines

**Decision**: If complex logic or >80 lines → Should be a skill

See [simplicity-enforcement.md](references/simplicity-enforcement.md) for decision criteria.

### Step 4: Validate Argument Handling

**Check argument usage**:

**Good** (proper handling):

```markdown
{Task description="Validate $ARGUMENTS" prompt="Validate the following: $ARGUMENTS"}
```

**With defaults**:

```markdown
{Task description="Validate ${ARGUMENTS:-all agents}" prompt="..."}
```

**Poor** (no handling):

```markdown
{Task description="Validate something" prompt="..."}

# User provides argument but command ignores it
```

**Validation criteria**:

- **Passes arguments**: Uses $ARGUMENTS or $1, $2, etc.
- **Sensible defaults**: Provides fallback if no argument
- **Documented usage**: Explains expected arguments (for documented commands)

See [argument-handling.md](references/argument-handling.md) for patterns.

### Step 5: Check Documentation Proportionality

**Documentation levels**:

**Simple delegator** (6-10 lines):

```yaml
---
name: audit-bash
description: Audit shell scripts for security and quality
---

Launch hook-auditor skill to validate Bash scripts:

{Skill skill="hook-auditor" args="$ARGUMENTS"}
```

**Documented delegator** (30-80 lines):

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

Launch agent-auditor:

{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

**Validation**: Documentation level matches complexity

See [documentation-proportionality.md](references/documentation-proportionality.md) for guidelines.

### Step 6: Decide: Command or Skill?

**Should this be a command?**

**Yes (keep as command) if**:

- User-invoked shortcut
- Simple delegation (6-80 lines)
- Convenience wrapper
- Slash command usage pattern

**No (convert to skill) if**:

- Auto-triggers on queries
- Complex logic (>80 lines)
- Multiple tool calls
- Extensive processing

**Test**: "Would a user type /this-name in chat?" → Yes = Command, No = Skill

See [simplicity-enforcement.md](references/simplicity-enforcement.md) for decision framework.

### Step 7: Generate Audit Report

Compile findings into standardized report format (see Report Format section below).

## Command-Specific Validation

### Delegation Clarity

**Assessment criteria**:

1. **Target explicit**: Clearly names agent/skill
2. **Invocation clear**: Uses Task/Skill tool
3. **Arguments passed**: Delegates user input
4. **Single responsibility**: One delegation target

**Red flags**:

- No explicit target ("do some analysis")
- Multiple delegations in one command
- Complex logic instead of delegation

### Simplicity Enforcement

**File size targets**:

- **6-10 lines**: Simple delegator (frontmatter + 1-2 line delegation)
- **30-80 lines**: Documented delegator (frontmatter + docs + delegation)
- **>80 lines**: Too complex (should be skill)

**Complexity indicators**:

- Line count >80
- Multiple tool calls
- If/else logic
- Loop constructs
- Extensive processing

### Argument Handling

**Patterns**:

**Pass-through**:

```markdown
{Task prompt="$ARGUMENTS"}
```

**With defaults**:

```markdown
{Task prompt="${ARGUMENTS:-default value}"}
```

**Positional**:

```markdown
{Task prompt="File: $1, Action: $2"}
```

**Validation**:

- Arguments are used (not ignored)
- Defaults make sense
- Usage documented (for documented commands)

### Documentation Proportionality

**Simple commands**: Minimal docs

- Name and description in frontmatter
- Optional: One-line explanation
- No usage section, no examples

**Documented commands**: Full docs

- Name and description in frontmatter
- Usage section with syntax
- "What It Does" explanation
- Examples section
- Optional: Tips or notes

**Rule**: Documentation should match complexity

## Common Issues

### Issue 1: Too Complex for Command

**Problem**: >80 lines or complex logic

**Example**: Command with 120 lines of if/else logic

**Fix**: Convert to skill

### Issue 2: Unclear Delegation

**Problem**: No explicit target

**Example**:

```markdown
Do some validation on the agent.
```

**Fix**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

### Issue 3: Arguments Ignored

**Problem**: User provides arguments but command doesn't use them

**Example**:

```markdown
{Task description="Validate agent" prompt="Validate an agent"}

# User types: /validate-agent bash-scripting

# But "bash-scripting" is ignored
```

**Fix**:

```markdown
{Skill skill="agent-auditor" args="$ARGUMENTS"}
```

### Issue 4: Over-Documented Simple Command

**Problem**: 6-line delegator with 50 lines of documentation

**Fix**: Remove excessive docs or justify complexity

### Issue 5: Underdocumented Complex Command

**Problem**: 60-line command with no usage docs

**Fix**: Add full documentation (usage, examples)

## Report Format

Use this standardized structure for all command audit reports:

```markdown
# Command Audit Report: {name}

**Command**: {name}
**File**: {path to command file}
**Audited**: {YYYY-MM-DD HH:MM}

## Summary

{1-2 sentence overview of command and assessment}

## Compliance Status

**Overall**: PASS | NEEDS WORK | FAIL

- **Delegation**: ✓/✗ {clear/unclear}
- **Simplicity**: ✓/✗ {lines} lines - {simple/documented/too complex}
- **Arguments**: ✓/✗ {handled/ignored}
- **Documentation**: ✓/✗ {proportional/excessive/insufficient}
- **Scope Decision**: ✓/✗ {should be command/should be skill}

## Critical Issues

{Must-fix issues that prevent proper functioning}

### {Issue Title}

- **Severity**: CRITICAL
- **Location**: {line}
- **Issue**: {description}
- **Fix**: {specific remediation}

## Important Issues

{Should-fix issues that impact quality}

## Nice-to-Have Improvements

{Polish items for excellence}

## Recommendations

1. **Critical**: {must-fix for correctness}
2. **Important**: {should-fix for quality}
3. **Nice-to-Have**: {polish for excellence}

## Next Steps

{Specific actions to improve command quality}
```

## Integration with audit-coordinator

**Invocation pattern**:

```text
User: "Audit my command"
→ audit-coordinator invokes command-auditor
→ command-auditor performs specialized validation
→ Results returned to audit-coordinator
→ Consolidated with claude-code-evaluator findings
```

**Sequence**:

1. command-auditor (primary) - Command-specific validation
2. claude-code-evaluator (secondary) - General structure validation

**Report compilation**:

- command-auditor findings (delegation, simplicity, arguments, docs)
- claude-code-evaluator findings (frontmatter, markdown, structure)
- Unified report with reconciled priorities

## Examples

### Example 1: Good Command (audit-bash)

**Status**: PASS

**Strengths**:

- Delegation: Clear (invokes hook-auditor skill)
- Simplicity: 8 lines (simple delegator pattern)
- Arguments: Properly passed ($ARGUMENTS)
- Documentation: Minimal (appropriate for simple command)

**Score**: 9/10 - Excellent simple delegator

### Example 2: Command Needs Work

**Status**: NEEDS WORK

**Issues**:

- Delegation: Unclear (no explicit target)
- Simplicity: 95 lines (too complex for command)
- Arguments: Ignored (doesn't use $ARGUMENTS)
- Documentation: Excessive (60 lines for simple task)

**Critical fixes**:

1. Clarify delegation target or convert to skill
2. Reduce complexity or migrate to skill
3. Pass arguments to delegated target
4. Reduce documentation or justify complexity

**Score**: 4/10 - Requires significant improvement

See [examples.md](references/examples.md) for complete audit reports.

---

For detailed guidance on each validation area, consult the reference files linked at the top of this document.

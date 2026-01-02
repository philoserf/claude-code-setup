---
name: command-audit
description: Validates command frontmatter, delegation patterns, simplicity guidelines, and documentation proportionality. Use when reviewing, auditing, analyzing, evaluating, improving, or fixing commands, validating official frontmatter (description, argument-hint, allowed-tools, model), checking delegation clarity or standalone prompts, assessing simplicity guidelines (6-15 simple, 25-80 documented), validating argument handling, or assessing documentation appropriateness. Distinguishes official Anthropic requirements from custom best practices. Also triggers when user asks about command best practices, whether a command should be a skill instead, or needs help with command structure.
allowed-tools: [Read, Grep, Glob, Bash]
---

## Reference Files

Command validation guidance (official requirements + custom best practices):

- [frontmatter-validation.md](references/frontmatter-validation.md) - Official Anthropic frontmatter features and validation rules (OFFICIAL)
- [delegation-patterns.md](../../references/delegation-patterns.md) - Delegation clarity and target selection validation (BEST PRACTICE)
- [simplicity-enforcement.md](references/simplicity-enforcement.md) - Simplicity vs complexity assessment and skill migration criteria (GUIDELINES)
- [argument-handling.md](references/argument-handling.md) - Argument parsing patterns and default value validation (BEST PRACTICE)
- [documentation-proportionality.md](references/documentation-proportionality.md) - Documentation level appropriateness (minimal vs full) (BEST PRACTICE)
- [report-format.md](references/report-format.md) - Standardized audit report structure and template
- [examples.md](references/examples.md) - Good vs poor command comparisons and full audit reports

---

## Official Requirements vs Custom Best Practices

This auditor validates both **official Anthropic requirements** and **custom best practices**:

**Official Anthropic Requirements** (from Claude Code documentation):

- **Frontmatter features**: `description` (required), `argument-hint`, `allowed-tools`, `model`, `disable-model-invocation` (optional)
- **Command patterns**: Delegation OR standalone prompts OR bash execution (!) OR file references (@)
- **Multiple valid patterns**: Commands can delegate to skills/agents OR provide inline instructions
- **No official line count limits**: Simplicity is conceptual, not numeric

**Custom Best Practices** (recommended patterns from this codebase):

- **Delegation clarity**: Descriptive delegation to skills/agents using natural language (preferred pattern)
- **Simplicity guidelines**: 6-15 lines (simple), 25-80 lines (documented) - guidelines not hard limits
- **Documentation proportionality**: Match documentation level to command complexity
- **Single responsibility**: One clear purpose per command
- **Argument handling**: Pass user input to delegation targets or use in instructions

**Audit reports will distinguish** between violations of official requirements (CRITICAL) and deviations from custom best practices (IMPORTANT or NICE-TO-HAVE).

---

# Command Auditor

Validates command configurations for delegation clarity, simplicity, and documentation proportionality.

## Quick Start

**Basic audit workflow**:

1. Read command file
2. Validate frontmatter features (description required, optional fields valid)
3. Identify command pattern (delegation, standalone prompt, bash, file reference)
4. Assess simplicity guidelines (6-15 simple, 25-80 documented)
5. Validate argument handling
6. Check documentation proportionality
7. Decide: Should this be a skill instead?
8. Generate audit report with official vs custom distinction

**Example usage**:

```text
User: "Audit my audit-agent command"
→ Reads commands/audit-agent.md
→ Validates delegation, simplicity, arguments, docs
→ Generates report with findings and recommendations
```

## Command Audit Checklist

### Critical Issues (Official Requirements)

Must be fixed for command to function correctly:

- [ ] **Valid markdown file** - Proper frontmatter and structure (OFFICIAL)
- [ ] **description field present** - Required for /help visibility and model invocation (OFFICIAL REQUIREMENT)
- [ ] **Frontmatter features valid** - argument-hint, allowed-tools, model, disable-model-invocation if specified (OFFICIAL)
- [ ] **Valid command pattern** - Delegation, standalone prompt, bash execution, or file reference (OFFICIAL - all valid)

### Important Issues (Best Practices)

Should be fixed for optimal command performance:

- [ ] **Simplicity guideline** - Generally 6-15 lines (simple) or 25-80 lines (documented) (GUIDELINE)
- [ ] **No complex logic** - Simple delegation/prompt, doesn't implement logic (BEST PRACTICE)
- [ ] **Delegation clarity** - If delegating, clear target and purpose (BEST PRACTICE)
- [ ] **Arguments handled properly** - $ARGUMENTS or $1/$2, sensible defaults (BEST PRACTICE)
- [ ] **Documentation proportional** - Minimal for simple, full for documented (BEST PRACTICE)
- [ ] **Single responsibility** - One clear purpose (BEST PRACTICE)
- [ ] **Scope correct** - Should be command, not skill (BEST PRACTICE)

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
Read commands/audit-agent.md

# Find all commands
Glob commands/*.md
```

### Step 1.5: Validate Frontmatter Features

**Check official frontmatter fields** (OFFICIAL REQUIREMENTS):

```bash
# Read frontmatter (first few lines)
Read commands/command-name.md | head -15
```

**Required validation**:

- [ ] **description present** - CRITICAL: Required for /help visibility and model invocation
- [ ] **argument-hint format** - If present, uses `[optional]` or `<required>` notation
- [ ] **allowed-tools valid** - If present, are valid tool names (Read, Write, Edit, Bash, Grep, Glob, Task, Skill, etc.)
- [ ] **model valid** - If present, is valid model identifier (sonnet, opus, haiku, or full string)
- [ ] **disable-model-invocation** - If present, is boolean (true/false)

**Common issues**:

- Missing description → Command won't appear in /help (CRITICAL)
- Invalid model name → Command might fail (CRITICAL)
- Argument-hint doesn't match usage → Confuses users (IMPORTANT)
- Restrictive allowed-tools → Command might fail if it needs unlisted tools (IMPORTANT)

See [frontmatter-validation.md](references/frontmatter-validation.md) for complete frontmatter guidance.

### Step 2: Identify Command Pattern

**Commands can use multiple valid patterns** (per official Anthropic guidance):

**Pattern 1: Descriptive Delegation** (most common in this codebase):

```markdown
**Delegation:** Invokes the **agent-audit** skill for comprehensive validation.
```

Or:

```markdown
Execute the git-workflow skill to handle complete git workflow automation.
```

Or:

```markdown
Validate agent configuration(s) using the agent-audit skill.

**Target**: ${ARGUMENTS:-all agents in ~/.claude/agents/}
```

**Pattern 2: Standalone Prompt** (also valid):

```markdown
Analyze the provided file and generate a comprehensive quality report including:

- **Code Style**: Adherence to language conventions and best practices
- **Security**: Potential vulnerabilities and security concerns
- **Performance**: Optimization opportunities and bottlenecks
- **Maintainability**: Code clarity, documentation, and structure
```

**Pattern 3: Bash Execution** (! syntax):

```markdown
!git log --oneline -10
!npm test

Summarize the output above.
```

**Pattern 4: File Reference** (@ syntax):

```markdown
@.claude/templates/code-review-checklist.md

Apply this checklist to $ARGUMENTS
```

**Validation criteria** (for ANY pattern):

For **delegation pattern**:

- **Target named**: Clearly identifies skill or agent
- **Purpose described**: Explains what skill/agent does
- **Single target**: Delegates to one component
- **Descriptive**: Uses natural language, not tool call syntax

For **standalone prompt**:

- **Clear instructions**: Tells Claude what to do
- **Structured**: Well-organized, actionable
- **Single purpose**: Focused on one task

For **bash/file patterns**:

- **Valid syntax**: Proper ! or @ usage
- **Appropriate use**: Bash for commands, @ for templates

**Note**: All patterns are valid per official Anthropic documentation. Evaluate based on:

- Is the pattern clear and understandable?
- Does it accomplish a single purpose?
- Is it appropriate for the task?

See [delegation-patterns.md](../../references/delegation-patterns.md) for delegation examples.

### Step 3: Assess Simplicity Guidelines

**Check file size and complexity** (BEST PRACTICE GUIDELINES):

```bash
wc -l commands/audit-agent.md
```

**Guidelines** (not hard limits):

- **6-15 lines**: Typical simple command (minimal documentation)
- **25-80 lines**: Typical documented command (full documentation)
- **>80 lines**: Consider skill migration (evaluate complexity)

**Focus on principles**:

- Single clear purpose
- Easy to understand
- Not implementing complex logic
- Appropriate for manual invocation

**Red flags** (suggest skill migration):

- Complex logic (if/else, loops) - belongs in skill
- Multiple tool calls - orchestration belongs in skill
- Extensive processing - implementation belongs in skill
- > 80 lines - usually indicates skill-worthy complexity

**Note**: Line counts are guidelines. A well-documented command with clear purpose might exceed guidelines and still be appropriate.

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
name: audit-agent
description: Comprehensive agent configuration validation
---

# audit-agent

Validates agent configurations using specialized auditors.

## Usage

    /audit-agent [agent-name]

## What It Does

1. Invokes agent-auditor for agent-specific validation
2. Checks model selection, tool restrictions, focus areas
3. Generates comprehensive audit report

## Examples

    /audit-agent bash-scripting
    /audit-agent claude-code-evaluator

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

Compile findings into standardized report format. See [report-format.md](references/report-format.md) for detailed structure and template.

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

### Simplicity Guidelines

**File size guidelines** (not hard limits):

- **6-15 lines**: Typical simple command (frontmatter + minimal content)
- **25-80 lines**: Typical documented command (frontmatter + docs + content)
- **>80 lines**: Consider skill migration (evaluate complexity)

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

### Issue 0: Missing description Frontmatter

**Problem**: No description field in frontmatter

**Severity**: CRITICAL (official requirement)

**Impact**:

- Command won't appear in `/help`
- SlashCommand tool cannot invoke command
- Users cannot discover command functionality

**Example**:

```yaml
# ❌ WRONG
---
argument-hint: [file]
---
```

**Fix**:

```yaml
# ✅ CORRECT
---
description: Analyze file for security vulnerabilities
argument-hint: [file]
---
```

### Issue 1: Excessive Complexity (Consider Skill)

**Problem**: >80 lines or complex implementation logic

**Severity**: IMPORTANT (best practice recommendation)

**Example**: Command with 120 lines of if/else logic

**Impact**:

- Hard to understand and maintain
- Violates single responsibility principle
- Better suited as skill with auto-triggering

**Fix**: Convert to skill (recommended, not required)

**Note**: Some commands legitimately exceed 80 lines due to comprehensive documentation. Evaluate based on complexity, not just line count.

### Issue 2: Unclear Delegation

**Problem**: No explicit target

**Severity**: IMPORTANT (best practice for delegation pattern)

**Example**:

```markdown
Do some validation on the agent.
```

**Fix** (use descriptive delegation):

```markdown
**Delegation:** Invokes the **agent-audit** skill for comprehensive validation.
```

### Issue 3: Arguments Ignored

**Problem**: User provides arguments but command doesn't use them

**Severity**: IMPORTANT (best practice)

**Example**:

```markdown
**Delegation:** Invokes the **agent-audit** skill.

# User types: /audit-agent bash-scripting

# But "bash-scripting" is ignored - not passed to skill
```

**Fix** (ensure arguments are passed):

```markdown
Validate agent configuration(s) using the agent-audit skill.

**Target**: ${ARGUMENTS:-all agents}
```

Or simply rely on automatic argument passing with descriptive delegation - Claude automatically passes $ARGUMENTS to invoked skills.

### Issue 4: Over-Documented Simple Command

**Problem**: 6-line delegator with 50 lines of documentation

**Fix**: Remove excessive docs or justify complexity

### Issue 5: Underdocumented Complex Command

**Problem**: 60-line command with no usage docs

**Fix**: Add full documentation (usage, examples)

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

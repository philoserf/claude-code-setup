---
name: agent-audit
description: Validates agent configurations for model selection appropriateness, tool restriction accuracy, focus area quality, and approach completeness. Use when reviewing, auditing, or improving agents, checking model choice (Sonnet/Haiku/Opus), validating tool permissions, assessing focus area specificity, or ensuring approach methodology is complete. Also triggers when user asks about agent best practices, wants to optimize agent design, or needs help with agent validation.
allowed-tools: [Read, Grep, Glob, Bash]
---

## Reference Files

Advanced agent validation guidance:

- [model-selection.md](references/model-selection.md) - Model choice decision matrix and cost/capability trade-offs
- [tool-restrictions.md](references/tool-restrictions.md) - Tool permission patterns and security implications
- [focus-area-quality.md](references/focus-area-quality.md) - Focus area specificity assessment and quality scoring
- [approach-methodology.md](references/approach-methodology.md) - Approach section completeness and methodology patterns
- [examples.md](references/examples.md) - Good vs poor agent comparisons and full audit reports

---

# Agent Auditor

Validates agent configurations for model selection, tool restrictions, focus areas, and approach methodology.

## Quick Start

**Basic audit workflow**:

1. Read agent file
2. Check model selection appropriateness
3. Validate tool restrictions
4. Assess focus area quality
5. Review approach methodology
6. Generate audit report

**Example usage**:

```text
User: "Audit my bash-scripting skill"
→ Reads skills/bash-scripting/SKILL.md
→ Validates model (Sonnet), tools, focus areas, approach
→ Generates report with findings and recommendations
```

## Agent Audit Checklist

### Critical Issues

Must be fixed for agent to function correctly:

- [ ] **Valid YAML frontmatter** - Proper syntax, required fields present
- [ ] **name field matches filename** - Name consistency
- [ ] **model field present and valid** - Sonnet, Haiku, or Opus only
- [ ] **At least 3 focus areas** - Minimum viable expertise definition
- [ ] **Tool restrictions present** - allowed_tools or allowed-patterns specified
- [ ] **No security vulnerabilities** - Tools don't expose dangerous capabilities

### Important Issues

Should be fixed for optimal agent performance:

- [ ] **Model matches complexity** - Haiku for simple, Sonnet default, Opus rare
- [ ] **5-15 focus areas** - Not too few (vague) or too many (unfocused)
- [ ] **Focus areas specific** - Concrete, not generic statements
- [ ] **Tools match usage** - No missing or excessive permissions
- [ ] **Approach section complete** - Methodology defined, output format specified
- [ ] **File size reasonable** - <500 lines or uses progressive disclosure

### Nice-to-Have Improvements

Polish for excellent agent quality:

- [ ] **Model choice justified** - Clear reason for non-default model
- [ ] **Focus areas have examples** - Technology/framework specificity
- [ ] **Approach has decision frameworks** - If/then logic for complex tasks
- [ ] **Tool restrictions documented** - Why specific tools are allowed/restricted
- [ ] **Context economy** - Concise without sacrificing clarity

## Audit Workflow

### Step 1: Read Agent File

Identify the agent file to audit:

```bash
# Single agent
Read skills/bash-scripting/SKILL.md

# Find all agents
Glob agents/*.md
```

### Step 2: Validate Model Selection

**Check model field**:

```yaml
model: sonnet  # Good - default choice
model: haiku   # Check: Is agent simple enough?
model: opus    # Check: Is complexity justified?
```

**Decision criteria**:

- **Haiku**: Simple read-only analysis, fast response needed, low cost priority
- **Sonnet**: Default for most agents, balanced cost/capability
- **Opus**: Complex reasoning required, highest capability needed

**Common issues**:

- Opus overuse: Using expensive model when Sonnet sufficient
- Haiku underperformance: Too simple for task complexity
- Missing model: No model field specified (defaults to Sonnet)

See [model-selection.md](references/model-selection.md) for detailed decision matrix.

### Step 3: Validate Tool Restrictions

**Check allowed_tools or allowed-patterns**:

```yaml
allowed_tools:
  - Read
  - Grep
  - Glob
  - Bash
```

**Validation checklist**:

1. **Tools specified**: Has allowed_tools field (not unrestricted)
2. **Tools match usage**: All mentioned tools are allowed
3. **No missing tools**: All needed tools are included
4. **No excessive tools**: No unnecessary permissions
5. **Security implications**: No dangerous tool combinations

**Common patterns**:

- **Read-only analyzer**: [Read, Grep, Glob, Bash (read commands)]
- **Code generator**: [Read, Write, Edit, Grep, Glob, Bash]
- **Orchestrator**: [Task, Skill, Read, AskUserQuestion]

See [tool-restrictions.md](references/tool-restrictions.md) for security analysis.

### Step 4: Assess Focus Area Quality

**Target**: 5-15 focus areas that are specific, concrete, and comprehensive

**Quality criteria**:

**Specific vs Generic**:

- ✗ Generic: "Python programming"
- ✓ Specific: "FastAPI REST APIs with SQLAlchemy ORM"

**Concrete vs Vague**:

- ✗ Vague: "Best practices"
- ✓ Concrete: "Defensive programming with strict error handling"

**Coverage**:

- Too few (<5): Expertise unclear or overly narrow
- Sweet spot (5-15): Comprehensive, focused expertise
- Too many (>15): Unfocused, trying to do everything

**Example analysis**:

```markdown
## Focus Areas

- Defensive programming with strict error handling ✓
- POSIX compliance and cross-platform portability ✓
- Safe argument parsing and input validation ✓
- Robust file operations and temporary resource management ✓
- Production-grade logging and error reporting ✓
```

**Score**: 5/5 areas, all specific and concrete → GOOD

See [focus-area-quality.md](references/focus-area-quality.md) for scoring methodology.

### Step 5: Review Approach Methodology

**Check approach section completeness**:

Required elements:

- [ ] **Methodology defined** - Step-by-step process
- [ ] **Decision frameworks** - How to handle different scenarios
- [ ] **Output format** - What the agent produces
- [ ] **Integration with focus** - How approach uses expertise

**Example complete approach**:

```markdown
## Approach

1. Analyze requirements and constraints
2. Design solution using defensive programming principles
3. Implement with POSIX compliance
4. Add comprehensive error handling
5. Test on multiple platforms
6. Document with inline comments

Output: Production-ready Bash script with full error handling
```

**Incomplete approach** (missing steps, no output format):

```markdown
## Approach

Write good Bash scripts following best practices.
```

See [approach-methodology.md](references/approach-methodology.md) for templates.

### Step 6: Check Context Economy

**File size assessment**:

```bash
# Count lines
wc -l skills/bash-scripting/SKILL.md
```

**Targets**:

- **<300 lines**: Excellent - concise and focused
- **300-500 lines**: Good - comprehensive without bloat
- **500-800 lines**: Consider progressive disclosure
- **>800 lines**: Should use references/ directory

**If oversized**:

1. Extract detailed content to references/ files
2. Keep main file focused on core workflow
3. Link to references from main file
4. Maintain one-level-deep structure

### Step 7: Generate Audit Report

Compile findings into standardized report format (see Report Format section below).

## Agent-Specific Validation

### Model Selection Appropriateness

**Haiku use cases** (simple, fast, cheap):

- Read-only file analysis
- Simple pattern matching
- Quick status checks
- Repetitive tasks

**Sonnet use cases** (default, balanced):

- Code generation
- Complex analysis
- Multi-step workflows
- Most agent tasks

**Opus use cases** (rare, complex):

- Deep architectural reasoning
- Complex multi-system design
- Situations requiring highest capability
- When cost is secondary to quality

**Red flags**:

- Opus for simple tasks (cost inefficiency)
- Haiku for complex tasks (capability mismatch)
- No justification for non-Sonnet choice

### Tool Restriction Fit

**Security implications**:

- **Write + Bash**: Can modify any file
- **Bash(sudo:\*)**: System-level access (usually denied)
- **Write(.env\*)**: Credential exposure risk
- **Task + Skill**: Can invoke other customizations

**Pattern validation**:

Compare allowed_tools to actual usage in agent content:

```bash
# Extract tool mentions
Grep "Read\|Write\|Edit\|Bash" agents/agent-name.md
```

Match against allowed_tools list.

### Focus Area Specificity

**Assessment criteria**:

1. **Technology specificity**: Mentions frameworks/tools by name
2. **Domain clarity**: Clear area of expertise
3. **Actionability**: Concrete guidance possible
4. **Coverage**: Spans full expertise area
5. **Non-overlap**: Each area distinct

**Scoring** (1-10):

- 9-10: All specific, concrete, comprehensive
- 7-8: Mostly specific, minor generic statements
- 5-6: Mix of specific and generic
- 3-4: Mostly generic, little specificity
- 1-2: All generic, no concrete focus

### Approach Completeness

**Required components**:

1. **Process**: Step-by-step methodology
2. **Decisions**: How to handle variations
3. **Output**: What the agent produces
4. **Quality**: Standards and validation

**Missing components impact**:

- No process: Unclear how agent works
- No decisions: Can't handle variations
- No output: Unclear deliverable
- No quality: No validation criteria

## Common Issues

### Issue 1: Opus Overuse

**Problem**: Using Opus when Sonnet would suffice

**Example**:

```yaml
model: opus # Expensive for this task
```

**Impact**: 5-10x higher cost for minimal benefit

**Fix**:

```yaml
model: sonnet # Balanced choice
```

**When Opus is justified**: Complex architectural design, deep reasoning required

### Issue 2: Generic Focus Areas

**Problem**: Vague, abstract expertise definitions

**Example**:

```markdown
## Focus Areas

- Programming best practices
- Code quality
- Good design patterns
```

**Fix**:

```markdown
## Focus Areas

- Defensive programming with strict error handling
- SOLID principles in TypeScript applications
- Test-driven development with Jest and React Testing Library
```

### Issue 3: Missing Tool Restrictions

**Problem**: No allowed_tools specified

**Impact**: Agent has unrestricted access (security risk)

**Fix**:

```yaml
allowed_tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
```

### Issue 4: Tool Restrictions Too Restrictive

**Problem**: Missing tools that agent needs

**Example**:

```yaml
allowed_tools: [Read, Grep] # Too limited for code generator
```

Agent content mentions Write and Edit but they're not allowed.

**Fix**: Add missing tools or remove references to them.

### Issue 5: Incomplete Approach

**Problem**: Vague methodology without steps

**Example**:

```markdown
## Approach

Follow best practices and write good code.
```

**Fix**:

```markdown
## Approach

1. Analyze requirements and constraints
2. Design architecture using SOLID principles
3. Implement with test-driven development
4. Review for security and performance
5. Document with inline comments and README

Output: Production-ready code with full test coverage
```

## Report Format

Use this standardized structure for all agent audit reports:

```markdown
# Agent Audit Report: {name}

**Agent**: {name}
**File**: {path to agent file}
**Audited**: {YYYY-MM-DD HH:MM}

## Summary

{1-2 sentence overview of agent and assessment}

## Compliance Status

**Overall**: PASS | NEEDS WORK | FAIL

- **Model Selection**: ✓/✗ {model} - {appropriate/inappropriate}
- **Tool Restrictions**: ✓/✗ {count} tools - {matches usage/missing tools/excessive}
- **Focus Areas**: ✓/✗ {count} areas - {specific/generic}
- **Approach**: ✓/✗ {complete/incomplete}
- **Context Economy**: ✓/✗ {line count} lines - {good/consider progressive disclosure}

## Critical Issues

{Must-fix issues that prevent proper functioning}

### {Issue Title}

- **Severity**: CRITICAL
- **Location**: {file}:{line}
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

{Specific actions to improve agent quality}
```

## Integration with audit-coordinator

**Invocation pattern**:

```text
User: "Audit my agent"
→ audit-coordinator invokes agent-audit
→ agent-audit performs specialized validation
→ Results returned to audit-coordinator
→ Consolidated with claude-code-evaluator findings
```

**Sequence**:

1. agent-audit (primary) - Agent-specific validation
2. claude-code-evaluator (secondary) - General structure validation
3. claude-code-test-runner (optional) - Functional testing

**Report compilation**:

- agent-audit findings (model, tools, focus, approach)
- claude-code-evaluator findings (YAML, markdown, structure)
- Unified report with reconciled priorities

## Examples

### Example 1: Good Agent (claude-code-evaluator)

**Status**: PASS

**Strengths**:

- Model: Sonnet (appropriate for analysis tasks)
- Tools: Read, Grep, Glob, Bash (read-only pattern, secure)
- Focus: 12 specific areas covering evaluation expertise
- Approach: Complete methodology with output format

**Score**: 9/10 - Excellent agent design

### Example 2: Agent Needs Work

**Status**: NEEDS WORK

**Issues**:

- Model: Opus (expensive, Sonnet sufficient for task)
- Tools: No allowed_tools (unrestricted access)
- Focus: 3 generic areas ("best practices", "code quality")
- Approach: Missing (no methodology defined)

**Critical fixes**:

1. Add allowed_tools field
2. Change model to Sonnet
3. Expand focus areas to 5-10 specific items
4. Add complete approach section

**Score**: 4/10 - Requires significant improvement

See [examples.md](references/examples.md) for complete audit reports.

---

For detailed guidance on each validation area, consult the reference files linked at the top of this document.

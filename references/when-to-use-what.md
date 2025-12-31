# When to Use What: Agents vs Skills vs Commands vs Output-Styles

Decision guide for choosing the right Claude Code customization type for your use case.

---

## Decision Matrix

| Aspect                | Agent                      | Skill                      | Command                  | Output-Style             |
| --------------------- | -------------------------- | -------------------------- | ------------------------ | ------------------------ |
| **Invocation**        | Auto or manual             | Auto only                  | Manual only (`/command`) | Manual (`/output-style`) |
| **Complexity**        | High (separate subprocess) | Medium-High                | Low (delegates)          | Low (prompt modifier)    |
| **Model choice**      | Configurable per agent     | Inherits from parent       | Inherits (or subprocess) | Inherits                 |
| **Tool restrictions** | Yes (allowed-tools)        | Yes (allowed-tools)        | Yes (if subprocess)      | No (can't restrict)      |
| **Context**           | Isolated subprocess        | Main conversation          | Main conversation        | Main conversation        |
| **Use case**          | Complex, focused tasks     | Domain knowledge/workflows | User shortcuts           | Behavior transformation  |

---

## Use an Agent when

- Task requires different model than main conversation
- Need strict tool restrictions for security/focus
- Want isolated context (separate from main conversation)
- Complex, specialized capability needed
- Can be auto-triggered OR manually invoked
- Task benefits from subprocess isolation

**Examples**:

- Code analysis agent with read-only tools
- Language-specific code generator
- Security auditor with restricted permissions
- Test runner that generates reports

---

## Use a Skill when

- Adding domain knowledge to main conversation
- Auto-triggering is important (skill discovery)
- Complex workflows in main context
- Progressive disclosure with references/ directory
- Want to extend base capabilities automatically
- Need to provide specialized knowledge

**Examples**:

- Git workflow automation
- PDF processing expertise
- Editing and proofreading assistance
- Shell script auditing knowledge

---

## Use a Command when

- User wants explicit shortcut
- Simple delegation to agent/skill
- Frequently-used prompt pattern
- User controls invocation timing
- Creating convenience wrapper
- One-liner that delegates

**Examples**:

- `/create-agent` - delegates to agent-authoring skill
- `/validate-agent` - invokes evaluator agent
- `/automate-git` - delegates to git-workflow skill

---

## Use an Output-Style when

- Want to change Claude's personality or role for entire session
- Non-engineering use case (writer, teacher, analyst)
- Need persistent behavior modification
- Want to transform WHO Claude is, not WHAT it can do
- Specialized role doesn't need tool restrictions (output-styles can't restrict tools)

**Examples**:

- Technical writer mode for documentation
- QA tester mode for test coverage
- Learning mode with TODO(human) markers
- Data analyst mode for SQL and insights

**When NOT to use output-styles**:

- Don't use for tool restrictions (use agents or skills instead)
- Don't use for adding specialized workflows (use skills)
- Don't use for complex multi-step tasks (use agents)

---

## Decision Flow

```text
Start: What are you building?

├─ Does it change Claude's personality/role for entire session?
│  └─ YES → Output-Style (behavior transformation)
│
├─ Is it a user-typed shortcut?
│  └─ YES → Command (delegates to agent or skill)
│
├─ Does it need a different model or strict tool restrictions?
│  └─ YES → Agent (subprocess with custom config)
│
├─ Does it add specialized knowledge to main conversation?
│  └─ YES → Skill (extends base capabilities)
│
└─ Not sure?
   └─ Start with Skill, convert to Agent if needed
```

---

## Common Scenarios

### Scenario: "I want to add Python expertise"

**Option 1**: Agent (python-expert)

- Use if: Need to restrict tools, use different model, or isolate context
- Pros: Strict control, custom model, isolated
- Cons: More complex, separate context

**Option 2**: Skill (python-expert)

- Use if: Want to extend main conversation with Python knowledge
- Pros: Auto-triggers, integrates with main conversation
- Cons: Inherits model and context from parent

**Recommendation**: Start with Skill unless you need agent-specific features

### Scenario: "I want a shortcut for common task"

**Answer**: Command

- Create `/task-name` command
- Delegate to appropriate agent or skill
- Keep command simple (no complex logic)

### Scenario: "I need to analyze code with read-only access"

**Answer**: Agent

- Use read-only tools (Read, Grep, Glob, Bash)
- Model: Haiku (fast) or Sonnet (more judgment)
- Pattern: Read-Only Analyzer

### Scenario: "I want to teach Claude about my domain"

**Answer**: Skill

- Add domain expertise via SKILL.md
- Use references/ for detailed documentation
- Auto-triggers when relevant queries appear

### Scenario: "I want Claude to write like a technical writer"

**Answer**: Output-Style

- Changes behavior and tone for entire session
- Use `keep-coding-instructions: false` for non-engineering roles
- Activate with `/output-style technical-writer`

---

## Migration Paths

### Skill → Agent

When to migrate:

- Need different model (Haiku for speed, Opus for complexity)
- Need strict tool restrictions
- Want isolated context

How:

1. Copy skill content to agent file
2. Add model and allowed-tools to frontmatter
3. Test in isolated context
4. Update invoking commands if needed

### Agent → Skill

When to migrate:

- Agent doesn't need isolation
- Want auto-triggering in main conversation
- Don't need custom model or tool restrictions

How:

1. Copy agent content to SKILL.md
2. Remove model and allowed-tools from frontmatter
3. Test auto-triggering
4. Consider progressive disclosure with references/

### Command → Skill

When to migrate:

- Command has complex logic (should delegate instead)
- Want auto-triggering instead of manual invocation

How:

1. Extract logic to new skill
2. Update command to delegate to skill
3. Keep command simple

---

## Quick Reference

**Choose Agent for**: Isolation, custom model, strict tools, subprocess
**Choose Skill for**: Domain knowledge, auto-trigger, main conversation
**Choose Command for**: User shortcuts, simple delegation, explicit control
**Choose Output-Style for**: Personality/role transformation, behavior modification

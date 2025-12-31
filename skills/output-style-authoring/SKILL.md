---
name: output-style-authoring
description: Guide for authoring output-styles that transform Claude's behavior and personality. Use when creating, writing, or designing output-styles, persona modes, role transformations, or behavior modifications. Helps design style files, choose when to keep coding instructions, write clear personas, and decide between output-styles, agents, and skills.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - AskUserQuestion
---

## Quick Navigation

- [Design Principles](references/design-principles.md) - Core principles for authoring
- [Design Patterns](references/design-patterns.md) - Common patterns and templates
- [Complete Examples](references/complete-examples.md) - Production-ready examples

---

## About Output-Styles

Output-styles are stored system prompts that transform Claude Code into specialized agents for different purposes. They modify Claude's core system prompt to change behavior, personality, and approach for an entire session.

**Key characteristics**:

- **System prompt modification** - Directly replaces/modifies the default system prompt
- **Session-wide behavior** - Affects entire conversation after activation
- **Personality transformation** - Changes how Claude responds and approaches tasks
- **Full capability retention** - Claude keeps all tools (Read, Write, Bash, etc.)
- **User-controlled** - Activate with `/output-style style-name`

**When to use output-styles**:

- Transform Claude into a different role (teacher, writer, analyst, etc.)
- Change response style for entire session
- Non-engineering use cases (content editing, data analysis, teaching)
- Persistent behavior modification needed

## Core Principles

See [design-principles.md](references/design-principles.md) for detailed principles. Key points:

1. **Transform Behavior** - Output-styles change WHO Claude is and HOW it responds
2. **Keep It Focused** - Define clear, specific personas or roles
3. **Coding Instructions Decision** - Use `keep-coding-instructions` appropriately

## Output-Style Structure

### Required Elements

Every output-style needs:

1. **Frontmatter** - YAML metadata between `---` markers
2. **name field** - Identifier for the style (matches filename)
3. **description field** - User-facing explanation shown in `/output-style` menu
4. **Content** - The actual behavior instructions

### Optional Elements

- `keep-coding-instructions` - Whether to preserve engineering guidance (default: `false`)
- Sections organizing the persona/behavior
- Examples and patterns
- Output format specifications

### File Location

**User scope** (just you):

- `~/.claude/output-styles/style-name.md`
- Applies across all projects

**Project scope** (whole team):

- `.claude/output-styles/style-name.md`
- Checked into git, shared with team

## Output-Style Design Patterns

See [design-patterns.md](references/design-patterns.md) for complete catalog:

- **Role Transformation** - Different profession personas
- **Teaching/Learning Mode** - Educational modes
- **Specialized Professional** - Domain expert roles
- **Quality/Audit Role** - Review and audit focus

## Output-Style Creation Process

### Step 1: Define Purpose and Role

**Questions to ask**:

- What role/persona should Claude adopt?
- What's the primary use case?
- Is this engineering-related or not?
- Does a similar style already exist?

**Check existing styles**:

```bash
ls -la ~/.claude/output-styles/
ls -la .claude/output-styles/  # Project scope
/output-style  # List available styles
```

**Use AskUserQuestion** to clarify ambiguities.

### Step 2: Choose Scope

**User scope** (`~/.claude/output-styles/`):

- Just for you
- Across all projects
- Personal styles

**Project scope** (`.claude/output-styles/`):

- For entire team
- Checked into git
- Project-specific styles

### Step 3: Decide on Coding Instructions

**Set `keep-coding-instructions: false` when**:

- Role is non-engineering (writer, teacher, analyst)
- Want to completely replace default behavior
- Coding context isn't relevant

**Set `keep-coding-instructions: true` when**:

- Specialized engineering role (security, DevOps, QA)
- Want to augment (not replace) engineering guidance
- Coding is still part of the role

**Default if omitted**: `false`

### Step 4: Write Clear Role Definition

**Good role definition**:

```markdown
# Technical Writer Mode

You are a technical writer focused on clarity and accessibility.
Your goal is to make complex topics understandable to beginners.
```

**Bad role definition**:

```markdown
# DON'T DO THIS

You help write documentation. # Too vague
```

**Include**:

- Who Claude is in this mode
- Primary goal or focus
- Key differentiators from default behavior

### Step 5: Define Specific Behaviors

**Use concrete, actionable instructions**:

**Good** (concrete):

```markdown
## Your Approach

1. Start each explanation with "why it matters"
2. Include a concrete example within 3 paragraphs
3. Use ASCII diagrams for relationships
4. End with "next steps" section
```

**Bad** (abstract):

```markdown
## DON'T DO THIS

Be more helpful and explanatory. # Too vague
```

**Structure behaviors as**:

- Numbered steps
- Bulleted patterns
- If/then rules
- Output format specifications

### Step 6: Write Description

**Requirements**:

- Explains what the style does
- Includes when to use it
- Contains trigger terms
- 100-200 characters ideal

**Good examples**:

```yaml
description: Writes clear, beginner-friendly documentation with examples and diagrams
description: Collaborative learn-by-doing mode with TODO(human) markers for student implementation
description: Security-focused review of code, configurations, and systems
```

**Bad examples**:

```yaml
description: Helps with writing  # Too vague
description: A style for stuff  # Useless
```

### Step 7: Create the File

**File location**:

- User: `~/.claude/output-styles/style-name.md`
- Project: `.claude/output-styles/style-name.md`

**Filename conventions**:

- Use lowercase-with-hyphens: `style-name.md`
- Match the `name` field in frontmatter
- Descriptive, clear purpose

**Basic template**:

```markdown
---
name: style-name
description: What this does and when to use it
keep-coding-instructions: false
---

# Role/Persona Name

[Role definition]

## Key Behaviors

[Specific, concrete behaviors]

## [Optional: Approach/Methodology]

[How to handle tasks in this role]

## [Optional: Output Format]

[Structure of responses if applicable]
```

### Step 8: Test the Output-Style

**Test activation**:

```text
/output-style style-name
```

**Verify**:

1. Style appears in `/output-style` menu
2. Description is clear
3. Behavior noticeably changes
4. Claude follows the instructions
5. Style adds value to the session

**Test queries**: Make requests that should trigger the persona's unique behaviors.

## Output-Styles vs Agents vs Skills

**📄 See [when-to-use-what.md](../../references/when-to-use-what.md) for complete decision guide including commands (shared)**

**Quick guide**:

**Use an Output-Style when**:

- Want to transform Claude's behavior for entire session
- Changing roles/personas (engineer → writer → analyst)
- Non-engineering use cases
- Behavior change should persist
- Don't need tool restrictions

**Use an Agent when**:

- Need separate context window
- Want different tool access
- Complex multi-step task needs isolation
- Want to delegate and return to main context

**Use a Skill when**:

- Want knowledge applied conditionally
- Auto-triggering based on context
- Teaching Claude specific patterns
- Main conversation should decide when to apply

## Common Mistakes to Avoid

1. **Trying to restrict tools** - Output-styles can't block tools (use Skills/Agents)
2. **Too vague/abstract** - "Be helpful" doesn't transform behavior
3. **Missing description** - Users won't know when to use the style
4. **Too complex** - Keep focused on one clear role
5. **Wrong scope choice** - Personal style in project folder or vice versa
6. **Forgetting coding instructions** - Should QA tester keep engineering context? Yes!
7. **No concrete behaviors** - Abstract instructions don't guide Claude effectively
8. **Not testing activation** - Always test `/output-style style-name` works

## Examples from Common Use Cases

See [complete-examples.md](references/complete-examples.md) for full examples:

- **Content Editor** - Non-engineering structured editing
- **QA Tester** - Engineering test coverage focus
- **Project Manager** - Planning and organization

## Tips for Success

1. **Be specific about the role** - "Technical writer" not "helper"
2. **Use concrete behaviors** - Numbered steps, specific patterns
3. **Test the style** - Activate and verify behavior changes
4. **Keep it focused** - One clear role, not multiple personalities
5. **Match the scope** - User vs project based on who needs it
6. **Consider coding instructions** - Keep for engineering roles
7. **Write clear description** - Users need to know when to use it
8. **Provide examples** - Show what output should look like
9. **Define boundaries** - What the role does and doesn't do
10. **Iterate** - Refine based on actual usage

## Quick Start Checklist

Creating a new output-style:

- [ ] Identify clear role/persona to create
- [ ] Choose scope (user `~/.claude/` or project `.claude/`)
- [ ] Decide on `keep-coding-instructions` value
- [ ] Write descriptive name (lowercase-with-hyphens)
- [ ] Write clear description (100-200 chars)
- [ ] Define specific, concrete behaviors
- [ ] Create file at correct location
- [ ] Test with `/output-style style-name`
- [ ] Verify behavior changes as expected
- [ ] Refine based on actual usage

## Reference to Standards

For detailed standards and validation:

- **Naming conventions** - Use lowercase-with-hyphens for style names
- **Frontmatter requirements** - name, description, keep-coding-instructions (optional)
- **File organization** - `~/.claude/output-styles/` or `.claude/output-styles/`

See `claude-code-audit` skill for comprehensive standards.

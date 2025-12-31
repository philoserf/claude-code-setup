# Naming Conventions

Consistent naming patterns for Claude Code subagents, commands, skills, and hooks to improve discoverability, avoid conflicts, and communicate intent clearly.

## Core Principles

1. **Kebab-case for files**: All files use lowercase with hyphens (`my-component.md`)
2. **Descriptive names**: Names should clearly indicate purpose and scope
3. **Consistency**: Use same terminology across filenames, descriptions, and documentation

## Subagents (`.claude/agents/`)

### Naming Pattern

`{domain}-{role}.md` or `{action}-{target}.md`

### Examples

- `claude-code-test-runner.md` - Runs and fixes tests
- `security-reviewer.md` - Reviews code for security issues
- `api-designer.md` - Designs API endpoints and contracts
- `performance-optimizer.md` - Analyzes and optimizes performance
- `debugger.md` - Debugs errors and unexpected behavior

### Guidelines

- Use action verbs for behavior-focused agents (`claude-code-test-runner`, `code-reviewer`)
- Use role nouns for specialized expertise (`debugger`, `architect`)
- Avoid generic names like `helper.md` or `agent.md`
- Include phrases like "use PROACTIVELY" or "MUST BE USED" in description field for automatic invocation

### Built-in Subagents (Reference Only)

- `explore` - Fast, read-only codebase exploration (Haiku, limited tools)
- `plan` - Research and planning in plan mode (Sonnet, read tools)
- General-purpose - Complex multi-step tasks requiring both exploration and action (Sonnet, all tools)

## Slash Commands (`.claude/commands/`)

### Naming Pattern

`{action}.md` or `{action}-{target}.md`

### Examples

- `optimize.md` - Analyze and optimize performance
- `security-review.md` - Review for security vulnerabilities
- `fix-issue.md` - Fix specific GitHub issues
- `test.md` - Run tests with optional pattern

### Guidelines

- Use imperative verbs (`optimize`, `review`, `fix`, `generate`)
- Use `$ARGUMENTS` for all arguments, `$1`, `$2` for positional parameters
- Commands require `description` in frontmatter to appear in `/help` and be model-invocable via SlashCommand tool

## Agent Skills (`.claude/skills/`)

### Naming Pattern

`{capability}/SKILL.md` where `{capability}` is kebab-case

### Examples

- `code-reviewer/` - Comprehensive code review capabilities
- `pdf-processor/` - PDF generation and manipulation
- `api-client/` - External API integration
- `data-analyzer/` - Data processing and analysis workflows

### Guidelines

- Directory name becomes the skill identifier
- `SKILL.md` is mandatory and contains the main instructions
- Use descriptive, capability-focused names
- Supporting files (scripts, templates, configs) organize by function
- Skills are model-invoked (automatic) vs commands which are user-invoked (manual)
- Claude reads supporting files via progressive disclosure when needed

## Hooks (Scripts in `hooks/` directory)

### Naming Pattern

`{purpose}.sh` or `{purpose}.py`

### Examples

- `validate-config.py` - Validates YAML frontmatter
- `auto-format.sh` - Formats code after edits
- `log-git-commands.sh` - Logs git operations
- `notify-idle.sh` - Desktop notifications

### Guidelines

- Use descriptive, purpose-focused names
- Include file extension (`.sh`, `.py`, etc.)
- Must be executable (`chmod +x`)
- Configure in `settings.json` hooks section

## File Naming Quick Reference

| Component | Location                 | Pattern                | Example                      |
| --------- | ------------------------ | ---------------------- | ---------------------------- |
| Subagent  | `.claude/agents/`        | `{domain}-{role}.md`   | `claude-code-test-runner.md` |
| Command   | `.claude/commands/`      | `{action}-{target}.md` | `fix-issue.md`               |
| Skill     | `.claude/skills/{name}/` | `SKILL.md`             | `code-reviewer/SKILL.md`     |
| Hook      | `.claude/hooks/`         | `{purpose}.{ext}`      | `validate-config.py`         |

## Skills vs Commands Decision Guide

| Aspect     | Slash Commands            | Agent Skills                          |
| ---------- | ------------------------- | ------------------------------------- |
| Invocation | User-invoked (`/command`) | Model-invoked (automatic)             |
| Complexity | Simple prompts            | Complex capabilities                  |
| Structure  | Single `.md` file         | Directory with `SKILL.md` + resources |
| Files      | One file only             | Multiple files, scripts, templates    |

**Use commands for:**

- Frequently-used prompts you invoke explicitly
- Quick templates and reminders
- Actions requiring explicit user control

**Use skills for:**

- Capabilities Claude should discover automatically
- Complex workflows with multiple steps
- Reference materials organized across files

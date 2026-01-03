# Shared References

This directory contains documentation shared across all Claude Code customizations. These files provide decision guidance, specifications, and conventions that multiple skills and agents reference.

## Files Overview

### Decision Guides

**[decision-matrix.md](decision-matrix.md)** (90 lines)

- Quick reference comparison table
- Covers 5 component types: Skills, Subagents, Commands, Output Styles, Hooks
- Use when: Need fast lookup of component characteristics
- Links to: when-to-use-what.md for details

**[when-to-use-what.md](when-to-use-what.md)** (281 lines)

- Comprehensive decision guide with scenarios
- Migration paths between component types
- Common use cases and examples
- Use when: Choosing which component type to create
- Links to: decision-matrix.md, naming-conventions.md, frontmatter-requirements.md

### Implementation Specifications

**[naming-conventions.md](naming-conventions.md)** (390 lines)

- Naming patterns for all component types
- Suffix patterns for skills (audit, authoring, workflow, etc.)
- File naming conventions
- Common mistakes and migration guides
- Use when: Creating or renaming components
- Links to: frontmatter-requirements.md, when-to-use-what.md

**[frontmatter-requirements.md](frontmatter-requirements.md)** (322 lines)

- Complete YAML frontmatter specifications
- Required and optional fields for each type
- Validation checklists
- Common frontmatter errors
- Use when: Writing component frontmatter
- Links to: hook-events.md, when-to-use-what.md, naming-conventions.md

### Reference Documentation

**[delegation-patterns.md](delegation-patterns.md)** (595 lines)

- Command delegation patterns and best practices
- 4 valid patterns: Descriptive delegation, standalone prompts, bash execution,
  file references
- Clear vs unclear delegation examples
- Use when: Writing commands or validating delegation clarity
- Referenced by: command-audit skill, command-authoring skill

**[hook-events.md](hook-events.md)** (241 lines)

- Hook lifecycle events reference
- Configuration patterns
- Environment variables
- Exit codes and error handling
- Use when: Implementing hooks
- Referenced by: frontmatter-requirements.md

**[plugin-structure-comparison.md](plugin-structure-comparison.md)** (369 lines)

- Comparison with official Claude Code plugin-structure skill
- Applicable organizational patterns and best practices
- Progressive disclosure strategy guidance
- Scalability planning and reorganization triggers
- Use when: Planning structure improvements or scaling decisions
- Links to: Official Anthropic plugin-structure documentation

## Navigation Flow

```text
Start Here                Implementation Details
┌─────────────────────┐   ┌──────────────────────┐
│ Decision Matrix     │──▶│ Naming Conventions   │
│ (Quick lookup)      │   │ (Name your component)│
└─────────────────────┘   └──────────────────────┘
          │                          │
          │                          ▼
          ▼                ┌──────────────────────┐
┌─────────────────────┐   │ Frontmatter Specs    │
│ When to Use What    │──▶│ (Write YAML)         │
│ (Detailed guide)    │   └──────────────────────┘
└─────────────────────┘             │
                                    ▼
                          ┌──────────────────────┐
                          │ Hook Events          │
                          │ (Hook lifecycle)     │
                          └──────────────────────┘
```

## Shared vs Skill-Specific References

### Use Shared References When

- Information applies to ALL component types
- Decision guidance (which component to create)
- Specifications (frontmatter, naming)
- General best practices

**Examples**: Decision guides, naming conventions, frontmatter specs

### Use Skill-Specific References When

- Information only relevant to ONE skill
- Detailed implementation patterns for specific domain
- Examples specific to that skill's focus area
- Supporting materials (templates, scripts)

**Examples**: `agent-audit/references/model-selection.md`, `bash-audit/references/error-codes.md`

## Referencing Shared Files from Skills

Use relative paths from skill SKILL.md:

```markdown
See [when-to-use-what.md](../../references/when-to-use-what.md) for decision guide
```

**Path structure**:

```text
~/.claude/
├── references/          # Shared references (this directory)
│   ├── README.md
│   ├── decision-matrix.md
│   └── ...
└── skills/
    └── my-skill/
        └── SKILL.md     # Use ../../references/ to reach shared files
```

## Referenced By

These shared files are used by:

- `claude-code-audit` skill (references all 3 spec files)
- `agent-authoring` skill (references when-to-use-what.md)
- `command-authoring` skill (references when-to-use-what.md)
- `output-style-authoring` skill (references when-to-use-what.md)

## Maintenance

When updating shared references:

1. **Check dependencies**: Search for `../../references/` to find all references
2. **Preserve backward compatibility**: Don't rename files (breaks links)
3. **Add cross-references**: Link to related shared docs
4. **Update this README**: Keep file descriptions current
5. **Test links**: Verify all markdown links resolve correctly

---

Last updated: 2026-01-03
File count: 7 files (decision-matrix.md, when-to-use-what.md,
naming-conventions.md, frontmatter-requirements.md, delegation-patterns.md,
hook-events.md, plugin-structure-comparison.md)

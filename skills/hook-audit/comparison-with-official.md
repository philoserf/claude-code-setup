# Comparison with Official hook-development Skill

Analysis comparing our `hook-audit` skill with Anthropic's official `hook-development` skill from the plugin-dev plugin (2026-01-03).

Source: <https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev/skills/hook-development>

---

## Key Observation: Different Purposes

**Critical distinction**: These skills serve fundamentally different purposes:

- **hook-development (official)** - Guides users in _creating new hooks_ from scratch
- **hook-audit (ours)** - Audits _existing hooks_ for correctness, safety, and performance

This is different from our other authoring skills where we have direct equivalents:

- agent-authoring ↔ agent-development
- command-authoring ↔ command-development
- skill-authoring ↔ skill-development

**Conclusion**: We should consider creating a `hook-authoring` skill to match the pattern, while keeping `hook-audit` for validation.

---

## Key Learnings to Apply

### 1. Prompt-Based Hooks are Primary (Not Just Command Hooks)

The official skill **strongly emphasizes prompt-based hooks first**:

> "Focus on prompt-based hooks for most use cases. Reserve command hooks for performance-critical or deterministic checks."

**Prompt-based hook example**:

```json
{
  "type": "prompt",
  "prompt": "Validate file write safety. Check: system paths, credentials, path traversal, sensitive content. Return 'approve' or 'deny'."
}
```

**Our improvement**:

- Hook-audit currently focuses heavily on command hooks (Python/Bash)
- Should add guidance on auditing prompt-based hooks
- Add reference file: `prompt-hooks.md`

### 2. Two Configuration Formats Need Clear Distinction

The official skill explicitly distinguishes between:

1. **Plugin format** (`hooks/hooks.json`): Uses wrapper object with `"hooks"` field
2. **Settings format** (`.claude/settings.json`): Direct format, events at top level

**Their teaching approach**:

- Shows both formats side-by-side
- Explains when to use each
- Prevents common configuration errors

**Our improvement**:

- Hook-audit currently only shows settings.json format
- Should acknowledge both formats exist
- Add comparison in validation section
- Note: We can focus on settings.json since we're in ~/.claude context

### 3. Implementation Workflow is Step-by-Step

Their 9-step development process:

1. Identify events
2. Choose approach (prompt vs command)
3. Write configuration
4. Create scripts (if command-based)
5. Use portability variables (`${CLAUDE_PLUGIN_ROOT}`)
6. Validate structure
7. Test locally
8. Test in environment (`claude --debug`)
9. Document

**Our consideration**:

- This is authoring workflow, not audit workflow
- Reinforces need for separate `hook-authoring` skill
- Hook-audit could reference this workflow in "Next Steps"

### 4. Quick Reference Checklist Format

Their Do's/Don'ts checklist is concise and actionable:

**Do's:**

- Use prompt-based hooks for complex reasoning
- Apply `${CLAUDE_PLUGIN_ROOT}` consistently
- Validate inputs in command hooks
- Quote all bash variables
- Set reasonable timeouts
- Return structured JSON

**Don'ts:**

- Use hardcoded paths
- Trust unvalidated input
- Create long-running hooks
- Depend on execution order
- Log sensitive data

**Our improvement**:

- Add similar format to hook-audit's "Quick Start" section
- Create `quick-checklist.md` with audit-focused do's/don'ts

### 5. Event-Specific Guidance is Comprehensive

They provide detailed coverage of 8 hook events:

- **PreToolUse** - Can block operations
- **PostToolUse** - Process results after execution
- **Stop/SubagentStop** - Validate completion standards
- **UserPromptSubmit** - Add context or validate input
- **SessionStart/SessionEnd** - Initialize/cleanup
- **PreCompact** - Preserve critical information
- **Notification** - React to user notifications

Each event includes:

- Purpose and capabilities
- Can it block operations?
- Performance targets
- Common use cases
- Example implementations

**Our comparison**:

- Hook-audit has event-specific guidance but less comprehensive
- We focus on 4 main events (PreToolUse, PostToolUse, Notification, SessionStart)
- Should expand coverage to all 8 events
- Add performance targets to our type reference

### 6. Security Best Practices are Threaded Throughout

Rather than isolating security in one section, they integrate it across:

- Hook Types section - Security context in examples
- Dedicated Security section - Comprehensive patterns
- Quick Reference - Security in checklist
- Examples - Security-focused implementations

**Security patterns they emphasize**:

- Input validation (path traversal, sensitive files)
- Variable quoting in bash
- Timeout settings
- Avoiding secret logging

**Our strength**:

- Hook-audit already has strong security focus
- Our error handling patterns are more detailed
- We emphasize graceful degradation

**Our improvement**:

- Add dedicated security audit checklist
- Create `security-patterns.md`

### 7. Temporarily Active Hooks Pattern

They introduce a powerful pattern for conditional hooks:

```bash
#!/bin/bash
# Only active when flag file exists
FLAG_FILE="$CLAUDE_PROJECT_DIR/.enable-strict-validation"

if [ ! -f "$FLAG_FILE" ]; then
  exit 0
fi

input=$(cat)
# ... validation logic ...
```

**Our improvement**:

- Add this pattern to hook-audit as "Conditional Execution"
- Include in audit checklist: "Does hook need conditional activation?"
- Add to `examples.md`

### 8. Matcher Pattern Progression

They teach matchers with progressive complexity:

1. **Exact**: `"Write"` - Single tool
2. **Multiple**: `"Write|Edit"` - Pipe-separated
3. **Wildcard**: `"*"` - All tools
4. **Regex**: `"mcp__.*__delete.*"` - Pattern matching

**Our improvement**:

- Hook-audit mentions matchers but doesn't teach progression
- Add matcher validation to audit checklist
- Check for overly broad matchers (`*` when specific would work)

---

## What We Should Keep (Our Strengths)

Hook-audit has elements they don't emphasize:

1. **Exit Code Semantics** - Crystal clear 0=allow, 2=block, never 1
2. **Graceful Degradation** - Extensive error handling patterns
3. **Dependency Checking** - Try/except for imports with safe fallback
4. **Audit Report Format** - Structured, standardized output
5. **Reference File System** - Modular documentation architecture
6. **Integration Guidance** - How hook-audit works with other auditors
7. **Meta-Validation** - Hook-audit validates the validator (validate-config.py)

---

## What's Context-Specific (Not Applicable)

Differences that are plugin-specific:

- `${CLAUDE_PLUGIN_ROOT}` - Plugin portability (we use `~/.claude/hooks/`)
- `hooks/hooks.json` in plugin directory - We use `.claude/settings.json`
- Plugin distribution concerns - We're in global user config
- Validation scripts - Plugins have `scripts/validate-hook-schema.sh`
- Plugin README documentation - We document in settings.json or separate docs

**What applies to us**:

- `$CLAUDE_PROJECT_DIR` - Project root variable (works in both contexts)
- Exit code semantics - Universal
- Security patterns - Universal
- Performance targets - Universal
- Event types - Universal

---

## Gap Analysis: Should We Create hook-authoring?

Looking at the pattern of our other skills:

| Official Skill           | Our Equivalent         | Purpose                         |
| ------------------------ | ---------------------- | ------------------------------- |
| agent-development        | agent-authoring        | Guide creation of agents        |
| command-development      | command-authoring      | Guide creation of commands      |
| skill-development        | skill-authoring        | Guide creation of skills        |
| output-style-development | output-style-authoring | Guide creation of output-styles |
| **hook-development**     | **❌ Missing**         | **Guide creation of hooks**     |
| N/A                      | hook-audit             | Audit existing hooks            |

**Recommendation**: Yes, create `hook-authoring` skill

**Why**:

1. Completes the authoring skill suite
2. Separates creation (authoring) from validation (audit)
3. Natural workflow: author → audit → iterate
4. Different triggering contexts ("create a hook" vs "audit my hook")

**What hook-authoring should include**:

1. Step-by-step creation workflow
2. Prompt-based vs command-based decision guide
3. Event selection guidance
4. Template patterns for common use cases
5. Testing and debugging guidance
6. When to use hooks vs other mechanisms

**What stays in hook-audit**:

1. Validation checklists
2. Security auditing
3. Performance analysis
4. Error handling review
5. Best practice compliance
6. Audit report generation

---

## Recommended Improvements to hook-audit

### Priority 1: High Value Additions

1. **Add Prompt-Based Hook Auditing**
   - Create `prompt-hooks.md`
   - Audit criteria for prompt hooks
   - Validation patterns differ from command hooks
   - ~300-400 lines

2. **Expand Event Coverage**
   - Add Stop/SubagentStop events
   - Add PreCompact event
   - Add SessionEnd event
   - Include performance targets for each
   - Update Hook Type Reference section

3. **Create Security Audit Checklist**
   - Create `security-patterns.md`
   - Input validation patterns
   - Path safety checks
   - Secret handling
   - Timeout configuration
   - ~250-350 lines

4. **Add Configuration Format Guidance**
   - Acknowledge both formats exist
   - Focus on settings.json for our context
   - Show common format errors
   - Add to validation section

### Priority 2: Enhancements

1. **Add Quick Do's/Don'ts Section**
   - Create `quick-checklist.md`
   - Audit-focused do's and don'ts
   - Common mistakes to flag
   - ~150-200 lines

2. **Expand Matcher Validation**
   - Check for overly broad matchers
   - Validate regex patterns
   - Flag wildcard misuse
   - Add to audit checklist

3. **Add Conditional Execution Pattern**
   - Temporarily active hooks pattern
   - Flag file approach
   - Add to `examples.md`
   - Audit item: "Is conditional activation needed?"

4. **Performance Targets by Event Type**
   - PreToolUse: <500ms
   - PostToolUse: <2s
   - Notification: <100ms
   - SessionStart: <5s
   - Stop: <1s
   - Add to Hook Type Reference

### Priority 3: Structural Changes

1. **Consider Renaming Sections**
   - "Hook Audit Checklist" → "Audit Checklist" (cleaner)
   - Add "Quick Reference" section at top
   - Move detailed patterns to references

2. **Cross-Reference Future hook-authoring**
   - "For hook creation guidance, see hook-authoring skill"
   - "This skill validates hooks created with hook-authoring"
   - Add after we create hook-authoring

---

## Recommended Structure for hook-authoring (New Skill)

When creating the new skill, use this structure:

### SKILL.md Outline

```yaml
---
name: hook-authoring
description: Guide for authoring Claude Code hooks...
allowed-tools: [Read, Write, Edit, Grep, Glob, Bash]
---

## Reference Files
- references/prompt-hooks.md - Prompt-based hook patterns
- references/command-hooks.md - Command-based hook patterns
- references/event-guide.md - When to use each event type
- references/templates.md - Starter templates for common patterns

## Quick Start
[3-4 examples of creating different hook types]

## Decision Guide
[Flowchart-style: Which event? Which type? Which approach?]

## Implementation Workflow
[9-step process adapted from official skill]

## Hook Types
### Prompt-Based Hooks (Recommended)
### Command Hooks

## Event Selection Guide
[Detailed guide for each of 8 events]

## Templates and Patterns
[Starter code for common scenarios]

## Testing and Debugging
[How to test before deploying]

## Integration
- Use hook-audit after creation
- Use audit-coordinator for comprehensive validation
```

### Reference Files (New)

- `prompt-hooks.md` - Prompt-based patterns (adapt from official)
- `command-hooks.md` - Command-based patterns
- `event-guide.md` - Event selection flowchart
- `templates.md` - Starter templates
- `testing-guide.md` - Testing approaches

---

## Implementation Checklist

### For hook-audit improvements

- [ ] Create `prompt-hooks.md` (prompt hook auditing)
- [ ] Create `security-patterns.md` (security audit patterns)
- [ ] Create `quick-checklist.md` (audit do's/don'ts)
- [ ] Expand Hook Type Reference with all 8 events
- [ ] Add performance targets to each event type
- [ ] Add matcher validation to audit checklist
- [ ] Add conditional execution pattern to examples
- [ ] Add configuration format guidance
- [ ] Test improvements with actual hooks
- [ ] Run /audit-skill hook-audit

### For new hook-authoring skill

- [ ] Create skill directory structure
- [ ] Write SKILL.md with decision guides
- [ ] Create `prompt-hooks.md` (adapted from official)
- [ ] Create `command-hooks.md`
- [ ] Create `event-guide.md`
- [ ] Create `templates.md` with starter patterns
- [ ] Create `testing-guide.md`
- [ ] Add integration guidance with hook-audit
- [ ] Test skill with hook creation scenarios
- [ ] Run /audit-skill hook-authoring
- [ ] Cross-link from hook-audit

---

## Files to Reference

From official hook-development skill:

- Main: `SKILL.md` (primary source)
- Directories:
  - `examples/` (practical implementations)
  - `references/` (technical documentation)
  - `scripts/` (validation and testing utilities)

**Next steps**:

1. Fetch detailed content from `examples/` and `references/` directories
2. Adapt patterns for non-plugin context
3. Extract templates and patterns for hook-authoring

---

## Key Takeaways

1. **Two different purposes**: Creating hooks (authoring) vs validating hooks (audit)
2. **Prompt-based hooks are primary**: We've been command-hook focused, need to expand
3. **Event coverage incomplete**: We cover 4 events, should cover all 8
4. **Security is comprehensive**: Thread security throughout, not just one section
5. **Missing skill**: We need hook-authoring to complete the authoring suite
6. **Validation enhancement**: Hook-audit should audit prompt hooks too
7. **Pattern learning**: Conditional execution, matcher progression, performance targets

---

## Next Steps

When resuming this work:

1. **Immediate**: Improve hook-audit with Priority 1 items
   - Focus on prompt-hooks.md and security-patterns.md
   - Expand event coverage

2. **Short-term**: Create hook-authoring skill
   - Follow the recommended structure above
   - Adapt official examples to ~/.claude context
   - Integrate with hook-audit workflow

3. **Long-term**: Test and iterate
   - Use hook-authoring to create new hooks
   - Use hook-audit to validate them
   - Refine based on actual usage
   - Consider audit-coordinator integration

4. **Documentation**: Cross-reference
   - Link hook-authoring ↔ hook-audit
   - Update audit-coordinator to include hook-authoring
   - Add to skills README if exists

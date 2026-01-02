# Common Issues in Agent Configurations

Catalog of frequent problems and their fixes when auditing agents.

## Issue 1: Opus Overuse

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

## Issue 2: Generic Focus Areas

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

## Issue 3: Missing Tool Restrictions

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

## Issue 4: Tool Restrictions Too Restrictive

**Problem**: Missing tools that agent needs

**Example**:

```yaml
allowed_tools: [Read, Grep] # Too limited for code generator
```

Agent content mentions Write and Edit but they're not allowed.

**Fix**: Add missing tools or remove references to them.

## Issue 5: Incomplete Approach

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

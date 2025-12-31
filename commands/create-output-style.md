---
description: Guide for authoring output-styles that transform Claude's behavior and personality
---

# create-output-style

Guides you through creating a new output-style to transform Claude's behavior.

## Usage

```bash
/create-output-style [style-name]
```

- **With style-name**: Creates guidance for a specific style (e.g., `/create-output-style technical-writer`)
- **Without args**: General guidance on output-style creation

## What It Does

This command invokes the **output-style-authoring** skill to guide you through:

- **Role Definition**: Defining the persona or role Claude should adopt
- **Scope Selection**: Choosing user scope vs project scope
- **Coding Instructions**: Deciding whether to keep engineering context
- **Behavior Specification**: Writing concrete, specific behaviors
- **Pattern Selection**: Choosing from 4 design patterns
- **Testing**: Activating and verifying the style works

## Output-Style Patterns Supported

- **Role Transformation** - Change Claude into different profession (writer, analyst, consultant)
- **Teaching/Learning Mode** - Educational or collaborative coding
- **Specialized Professional** - Domain expert roles with specific workflows
- **Quality/Audit Role** - Review, audit, or QA focus with structured output

## Examples

```bash
# Create a technical writer style
/create-output-style technical-writer

# Create a security auditor style
/create-output-style security-auditor

# General output-style creation guidance
/create-output-style
```

## Delegation

This command delegates to the **output-style-authoring** skill, which uses read-only tools (Read, Grep, Glob, Bash) to examine existing styles and provide guidance. The skill may use AskUserQuestion to clarify requirements.

## Key Concepts

Output-styles modify Claude's system prompt to transform behavior for an entire session. Unlike agents (which create separate contexts) or skills (which apply conditionally), output-styles change how Claude approaches ALL tasks in the session after activation with `/output-style style-name`.

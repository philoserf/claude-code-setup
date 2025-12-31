---
description: Guide for authoring effective skills that extend Claude's capabilities
---

# create-skill

Guides you through creating a new skill with specialized knowledge and workflows.

## Usage

```bash
/create-skill [skill-name]
```

- **With skill-name**: Creates guidance for a specific skill (e.g., `/create-skill git-workflow`)
- **Without args**: General guidance on skill creation

## What It Does

This command invokes the **skill-authoring** skill to guide you through:

- **Skill Structure**: Designing SKILL.md with proper frontmatter
- **Progressive Disclosure**: Organizing content with references/ directory
- **Resource Organization**: Managing scripts/, references/, and assets/
- **Description Writing**: Crafting trigger-rich descriptions for auto-discovery
- **Tool Permissions**: Choosing allowed-tools appropriately
- **Validation**: Testing discoverability and functionality
- **Packaging**: Preparing skills for sharing

## Skill Capabilities Supported

- **Domain Knowledge** - Teaching Claude specialized expertise
- **Workflow Automation** - Multi-step processes and patterns
- **Tool Integration** - Scripts and external tool usage
- **Standards & Best Practices** - Coding standards, review checklists
- **Output Quality** - Formatting and structure guidance

## Examples

```bash
# Create a git workflow skill
/create-skill git-workflow

# Create a documentation skill
/create-skill technical-writing

# General skill creation guidance
/create-skill
```

## Delegation

This command delegates to the **skill-authoring** skill, which uses Read, Write, Edit, Grep, Glob, and Bash tools to examine existing skills, create templates, and provide comprehensive guidance.

## Key Concepts

Skills extend Claude's capabilities by providing specialized knowledge that auto-triggers when relevant. Unlike agents (separate contexts) or output-styles (behavior transformation), skills add domain expertise to the main conversation and are invoked automatically by Claude when appropriate.

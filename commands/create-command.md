---
description: Guide for authoring slash commands that delegate to agents or skills
---

# create-command

Guides you through creating a new slash command with simple delegation.

## Usage

```bash
/create-command [command-name]
```

- **With command-name**: Creates guidance for a specific command (e.g., `/create-command deploy-app`)
- **Without args**: General guidance on command creation

## What It Does

This command invokes the **command-authoring** skill to guide you through:

- **Purpose Definition**: Clarifying what the command should do
- **Delegation Target**: Choosing which agent or skill to delegate to
- **Argument Handling**: Designing optional/required arguments
- **Documentation Level**: Simple (6-10 lines) vs documented (30-80 lines)
- **Description Writing**: Crafting clear frontmatter description
- **Testing**: Verifying command works with `/help` and invocation

## Command Patterns Supported

- **Simple Delegator** - Minimal (6-10 lines), direct delegation
- **Documented Delegator** - Full documentation with usage, examples
- **Multi-Agent Orchestrator** - Coordinates multiple agents

## Examples

```bash
# Create a deployment command
/create-command deploy-app

# General command creation guidance
/create-command
```

## Delegation

This command delegates to the **command-authoring** skill, which uses read-only tools (Read, Grep, Glob, Bash) to examine existing commands and provide guidance. The skill may use AskUserQuestion to clarify requirements.

## Philosophy

Commands should be simple and delegate to agents or skills rather than containing complex logic. The command-authoring skill emphasizes this golden rule and helps you create focused, maintainable commands.

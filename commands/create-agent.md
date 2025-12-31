---
description: Guide for authoring specialized AI agents with focused expertise and tool restrictions
---

# create-agent

Guides you through creating a new AI agent with specialized expertise.

## Usage

```bash
/create-agent [agent-name]
```

- **With agent-name**: Creates guidance for a specific agent (e.g., `/create-agent python-expert`)
- **Without args**: General guidance on agent creation

## What It Does

This command invokes the **agent-authoring** skill to guide you through:

- **Purpose Definition**: Clarifying what the agent should do
- **Model Selection**: Choosing between Sonnet, Haiku, or Opus
- **Tool Restrictions**: Determining minimal tool set needed
- **Focus Areas**: Writing specific areas of expertise
- **Approach**: Documenting methodology and processes
- **Description**: Crafting comprehensive description with triggers
- **Validation**: Testing and validating the new agent

## Agent Types Supported

- **Read-only analyzers** - Code auditing, evaluation, reporting
- **Code generators** - Creating and modifying code files
- **Workflow orchestrators** - Coordinating multi-step processes

## Examples

```bash
# Create a Python testing agent
/create-agent python-test-expert

# General agent creation guidance
/create-agent
```

## Delegation

This command delegates to the **agent-authoring** skill, which uses read-only tools (Read, Grep, Glob) to examine existing agents and provide guidance. The skill may use AskUserQuestion to clarify requirements.

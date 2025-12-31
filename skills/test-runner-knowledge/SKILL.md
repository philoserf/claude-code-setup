---
name: test-runner-knowledge
description: Reference knowledge base for the claude-code-test-runner agent (not user-invocable)
version: 1.0.0
allowed-tools:
  - none
---

# Test Runner Knowledge Base

This skill provides reference material for the `claude-code-test-runner` agent.

**This is not a user-invocable skill** - it exists solely to provide structured reference knowledge to the test runner agent through the agent's `skills` auto-load feature.

## Contents

The references include:

- **examples.md** - Concrete test case examples for different customization types
- **common-failures.md** - Catalog of common failure patterns

## Usage

This skill is automatically loaded by the `claude-code-test-runner` agent via its `skills` frontmatter field.

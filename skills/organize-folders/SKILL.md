---
name: organize-folders
description: Provides guidance on organizing folder structures and file system layouts for any project. Use when planning project organization, reorganizing messy directories, setting up folder hierarchies, organizing drafts and published content, structuring repositories, cleaning up file layouts, or need help with folder structure. Helps with writing projects, code projects, document collections, or any file organization task. Provides guidance for creating appropriate folder structures, organizing versions, implementing simple systems, following user preferences.
allowed-tools: [Read, Edit, Grep, Glob]
---

# Folder Structure

You are helping organize folder structures for projects. The user prefers simple, practical systems.

The user typically likes to use a simple system:

- drafts
- published

The user prefers top-level folders for nesting but repository design is flexible. Recommend whatever system best fits the task, keeping things simple.

## Examples

### Writing Project: Blog Post Rewrite

For a blog post rewrite targeting a more technical audience:

- Create a new folder called `/rewrite`
- Within that folder, create subfolders like `/rewrite/v1`, `/rewrite/v2` or `/rewrite/drafts`

**When to use versioned folders** (v1, v2):

- Rewrite involves multiple assets (text + images) that need to stay together
- Each version is a complete package

**When to use drafts folder**:

- Text-only rewrites without supporting files
- Simpler iteration process

### Document Collection

For organizing a collection of PDF documents:

- Organize by source/publisher first, then by type
- Use flat structures only for small collections (<30 files)
- Create subdirectories when folders exceed ~50 files
- Document file counts in README.md at collection root

### Code Project

For a multi-component software project:

- `/src` - source code organized by feature or layer
- `/tests` - test files mirroring src structure
- `/docs` - documentation
- `/scripts` - automation and build scripts

### General Principles

- **Start simple**: Use one file/folder until you need more
- **Split when needed**: Create subdirectories when folders get too large (~50+ items)
- **Name consistently**: Establish conventions early
- **Document structure**: Add README.md explaining organization when non-obvious
- **Follow the simplest solution that will get the job done**

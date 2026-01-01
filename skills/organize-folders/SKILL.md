---
name: organize-folders
description: Provides guidance on organizing folder structures and file system layouts for any project. Use when planning project organization, reorganizing messy directories, setting up folder hierarchies, creating folder structures, designing directory layouts, organizing drafts and published content, structuring repositories, cleaning up file layouts, arranging files, or need help with folder structure or file organization. Helps with writing projects, code projects, document collections, or any file organization task. Provides guidance for creating appropriate folder structures, organizing versions, implementing simple systems, following user preferences.
allowed-tools: [Read, Edit, Grep, Glob]
---

# Folder Organization Guidance

This skill provides **guidance and recommendations** for organizing folder structures and file system layouts. It helps you design effective file organization but doesn't automatically reorganize files.

## User Preferences

The user prefers simple, practical systems with a typical pattern:

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

### Photo/Media Library

For organizing photos, videos, or media files:

- By date: `/2024/01-January`, `/2024/02-February` (chronological)
- By event: `/Vacation-Hawaii-2024`, `/Birthday-Party-2024` (event-based)
- Hybrid: `/2024/Hawaii-Vacation`, `/2024/Birthday` (year + event)

Choose based on retrieval patterns - date for large collections, events for memorable occasions.

### Research Project

For academic or research work with papers and notes:

- `/papers` - PDFs organized by topic or author
- `/notes` - Reading notes and annotations
- `/writing` - Drafts of your own work
- `/data` - Datasets and analysis results
- `/references` - Bibliography and citation management

## General Principles

- **Start simple**: Use one file/folder until you need more
- **Split when needed**: Create subdirectories when folders get too large (~50+ items)
- **Name consistently**: Establish conventions early
- **Document structure**: Add README.md explaining organization when non-obvious
- **Follow the simplest solution that will get the job done**

## Common Organization Problems

### Too Many Files in One Folder

When a folder exceeds ~50 items, it becomes hard to navigate:

- **Solution**: Create subdirectories by logical grouping (type, date, category)
- **Example**: Split `/documents` into `/documents/contracts`, `/documents/reports`, `/documents/invoices`

### Deeply Nested Structures

More than 3-4 levels of nesting makes files hard to find:

- **Solution**: Flatten by combining middle levels or using more descriptive names
- **Example**: `/projects/client/2024/Q1/reports` → `/projects/client-2024-Q1-reports`

### Inconsistent Naming

Mixed conventions (spaces vs dashes, capitalization) cause confusion:

- **Solution**: Pick one convention and apply consistently
- **Recommended**: kebab-case for code projects, Title Case for documents

# Claude Code Setup

A comprehensive, production-ready configuration for [Claude Code](https://claude.com/claude-code) demonstrating best practices for customization and automation.

## What's Included

- **9 Commands**: Common workflows (audit, create agents/skills, git automation)
- **3 Agents**: Specialized assistants (bash scripting, evaluator, test runner)
- **18 Skills**: Advanced capabilities (auditing, authoring, git, PDF processing)
- **6 Hooks**: Automation (validation, formatting, logging, notifications)
- **Complete Documentation**: Guides, references, and examples

## Installation

### Fresh Installation

Clone this repository to your `~/.claude` directory:

```bash
git clone https://github.com/philoserf/claude-code-setup.git ~/.claude
```

### Customization

After installation, review and customize:

1. **Edit `settings.json`** - Adjust tool permissions for your needs
2. **Modify `CLAUDE.md`** - Add your personal coding principles and preferences
3. **Adjust hooks** - Enable/disable automation in `hooks/` and `settings.json`
4. **Add your own** - Create custom commands, skills, and agents

### Personal Files

`CLAUDE.md` contains my personal coding principles and preferences as examples. Feel free to adapt these to your own style or replace with your own guidelines.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on submitting improvements, bug reports, or new customizations.

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Configuration Reference

This is the global configuration directory for Claude Code (`~/.claude`). Settings and customizations here apply across all projects unless overridden by project-specific configurations.

## Directory Structure

### Configuration Files

| File             | Purpose                                                               |
| ---------------- | --------------------------------------------------------------------- |
| `settings.json`  | Global permissions, MCP servers, cleanup policies, and tool approvals |
| `~/.config.json` | User preferences and application state (not tracked in git)           |
| `CLAUDE.md`      | Instructions for Claude Code when working in this repository          |
| `.gitignore`     | Git ignore rules for this configuration directory                     |

### Extension Directories

| Directory     | Purpose                                            | Tracked in Git |
| ------------- | -------------------------------------------------- | -------------- |
| `agents/`     | Specialized AI agents for specific tasks           | Yes            |
| `commands/`   | Custom slash commands (e.g., `/commit`, `/review`) | Yes            |
| `skills/`     | Custom skills and capabilities                     | Yes            |
| `hooks/`      | Event-driven automation hooks                      | Yes            |
| `references/` | Shared reference files for customizations          | Yes            |

### Session Data (Not Tracked)

| Directory          | Purpose                                        |
| ------------------ | ---------------------------------------------- |
| `projects/`        | Per-project metadata (encoded directory names) |
| `todos/`           | Session todo lists (UUID-named JSON files)     |
| `plans/`           | Implementation plans from plan mode            |
| `file-history/`    | Change tracking for edited files               |
| `session-env/`     | Environment snapshots per session              |
| `logs/`            | Session logs and commit history                |
| `debug/`           | Session debug logs                             |
| `shell-snapshots/` | Zsh environment captures                       |
| `ide/`             | IDE connection state                           |
| `statsig/`         | Feature flag evaluation cache                  |
| `history.jsonl`    | Conversation history across sessions           |

## Key Concepts

### Permission Model

Claude Code uses a permission system defined in `settings.json`:

- **Allowed Operations**: Tools and file patterns that don't require user approval
- **Denied Operations**: Blocked operations (e.g., reading `.env` files, `sudo` commands)
- **Ask First**: Everything else requires explicit user approval

### Project Tracking

Claude Code tracks projects in the `projects/` directory using encoded directory names (e.g., `-Users-markayers-source-mine-go`). Each project stores:

- Session costs and token usage
- File counts and modification stats
- Cache performance metrics

### Session Management

- Sessions are identified by UUIDs
- Session data persists for 30 days (configurable via `cleanupPeriodDays`)
- Todos, plans, and file history are session-scoped
- Shell snapshots capture environment state per session

## Customization

### Adding Slash Commands

1. Create a markdown file in `commands/` (e.g., `commands/mycommand.md`)
2. Define the command behavior in the markdown content
3. Restart Claude Code to register the command
4. Use with `/mycommand` in any session

### Adding Skills

1. Create a directory in `skills/` with skill name (verb-noun format)
2. Create `SKILL.md` as the main skill file with frontmatter metadata
3. Add reference files in `references/` subdirectory if needed
4. Skills auto-register on restart

Example structure:

```text
skills/fix-typos/
|-- SKILL.md           # Main skill with frontmatter (name: fix-typos)
+-- references/        # Optional supporting docs
    +-- examples.md
```

### Adding Hooks

1. Create a hook definition in `hooks/` directory
2. Configure trigger events (e.g., before tool calls, after file changes)
3. Hooks execute automatically on matching events

## Active Hooks

This configuration includes 6 active hooks that automate workflows and enforce quality standards:

### PreToolUse Hooks

Run before tool execution and can block operations if needed.

#### log-git-commands.sh

**Trigger**: Before any `Bash` command
**Purpose**: Logs all git, gh, and dot (dotfiles) commands to stderr for tracking
**Behavior**: Informational only - never blocks execution
**Timeout**: 5 seconds

Example output: `[Hook] Git command: git status`

#### validate-bash-commands.py

**Trigger**: Before any `Bash` command
**Purpose**: Suggests better alternatives when using bash for operations that have dedicated tools
**Behavior**: Informational only - never blocks execution
**Timeout**: 5 seconds

Examples:

- Suggests `Read` tool instead of `cat`, `head`, `tail`
- Suggests `Grep` tool instead of `grep`, `rg`
- Suggests `Edit` tool instead of `sed`, `awk`
- Suggests `Glob` tool instead of `find` for file searches

#### validate-config.py

**Trigger**: Before any `Edit` or `Write` operation
**Purpose**: Validates YAML frontmatter in Claude Code customization files
**Behavior**: **Can block** operations if YAML is invalid in agents, skills, or commands
**Timeout**: 5 seconds

Checks:

- YAML frontmatter syntax in `agents/*.md`, `skills/*/SKILL.md`, `commands/*.md`
- Required fields presence (name, description, etc.)
- Proper frontmatter delimiters (`---`)

### PostToolUse Hooks

Run after tool execution completes successfully.

#### auto-format.sh

**Trigger**: After any `Edit` or `Write` operation
**Purpose**: Automatically formats code files using appropriate formatters
**Behavior**: Silent formatting - never blocks or reports errors
**Timeout**: 10 seconds

Supported formatters:

- `gofmt` for `.go` files
- `prettier` for `.js`, `.jsx`, `.ts`, `.tsx`, `.json`, `.md` files

### Notification Hooks

Run when specific events occur during the session.

#### notify-idle.sh

**Trigger**: When Claude is idle and waiting for user input
**Purpose**: Sends macOS desktop notification when prompt is ready
**Behavior**: Uses `osascript` to display notification
**Timeout**: 5 seconds

Notification: "Claude Code" - "Ready for your input"

### SessionStart Hooks

Run once when a new Claude Code session starts.

#### load-session-context.sh

**Trigger**: At session startup
**Purpose**: Injects git repository context for awareness
**Behavior**: Checks for `.git` directory and outputs repository status
**Timeout**: 10 seconds

Provides:

- Current git branch
- Working tree status
- Recent commit information

### Hook Configuration

All hooks are configured in `settings.json` with:

- **Matchers**: Regular expressions to determine when hooks run
- **Timeouts**: Maximum execution time before hook is killed
- **Exit codes**: 0 = allow operation, 2 = block operation

Hooks are designed to fail gracefully - if a hook errors, it exits with code 0 to avoid blocking operations.

### Modifying Permissions

Edit `settings.json` to add tool or file pattern permissions:

```json
{
  "permissions": {
    "allowed": ["Read", "Bash(git:*)", "Write(*.md)"],
    "denied": ["Read(.env*)", "Bash(sudo:*)"]
  }
}
```

For project-specific permissions, create `settings.local.json` in the project directory.

## Security Considerations

- `.env*` files are blocked from reading via permissions
- Lock files (`go.sum`, `package-lock.json`, etc.) are write-protected
- `sudo` commands are denied by default
- **Sensitive Data**: `.mcp.json` contains API credentials (GitHub token) - not tracked in git
- **History**: `history.jsonl` may contain sensitive conversation context - not tracked in git

## Common Operations

### Review Recent Activity

```bash
# Check recent session logs
tail -n 50 logs/session-log.txt

# View commit history
cat logs/commit-log.txt
```

### Inspect Project Metadata

```bash
# List tracked projects
ls -l projects/

# View specific project stats
cat projects/-Users-markayers-source-mine-go/meta.json | jq
```

### Manual Cleanup

Claude Code automatically cleans data older than 30 days. For manual cleanup:

```bash
# Remove old session data
find todos/ -name "*.json" -mtime +30 -delete
find debug/ -name "*.txt" -mtime +30 -delete
```

## Resources

- [Claude Code Documentation](https://claude.com/code)
- [MCP Server Specification](https://modelcontextprotocol.io)
- [GitHub Issues](https://github.com/anthropics/claude-code/issues)

---

**Last Updated**: 2025-12-30

# Hook Examples

Concrete examples of good and bad hook patterns with before/after comparisons.

## Good Examples

### validate-config.py (187 lines) - Perfect PreToolUse Hook

**Purpose**: Validate YAML frontmatter in Claude Code customization files

**File**: `/Users/markayers/.claude/hooks/validate-config.py`

**Why It's Good**:

- ✓ Safe JSON parsing with try/except
- ✓ Correct exit codes (0 on error, 2 to block, never 1)
- ✓ Dependency checking (PyYAML with graceful degradation)
- ✓ Clear error messages with helpful hints
- ✓ File type validation before processing
- ✓ Early exits for non-matching files
- ✓ Fast performance (<100ms for most cases)

**Key Patterns**:

```python
#!/usr/bin/env python3
# 1. Clear header comment
# Config validation hook - validates YAML frontmatter in .claude/ files
# Runs on PreToolUse for Write/Edit operations
# Exit codes: 0 = allow, 2 = block

# 2. Dependency checking
try:
    import yaml
except ImportError:
    print("Warning: PyYAML not installed, skipping config validation", file=sys.stderr)
    sys.exit(0)  # Don't block

# 3. Safe JSON parsing
try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")
    content = data.get("tool_input", {}).get("content", "")

    # 4. Early exits for non-matching files
    if not file_path or not content:
        sys.exit(0)

    if "/.claude/" not in file_path and not file_path.startswith(".claude/"):
        sys.exit(0)

    if not file_path.endswith(".md"):
        sys.exit(0)

    # 5. File type detection
    if "/agents/" in file_path:
        file_type = "agent"
    elif "/skills/" in file_path and "SKILL.md" in file_path:
        file_type = "skill"
    else:
        sys.exit(0)  # Not our file type

    # 6. Validation logic
    frontmatter = extract_frontmatter(content)

    if frontmatter is None:
        print(f"Error: No YAML frontmatter found in {file_type} file", file=sys.stderr)
        sys.exit(2)  # Block

    if errors:
        print(f"Validation errors:", file=sys.stderr)
        for error in errors:
            print(f"  • {error}", file=sys.stderr)
        sys.exit(2)  # Block

    # 7. Success
    sys.exit(0)

# 8. Error handling - don't block on hook errors
except Exception as e:
    print(f"Error in config validation hook: {e}", file=sys.stderr)
    sys.exit(0)
```

**Performance**: <1ms for non-matching files, <100ms for validation

### log-git-commands.sh (13 lines) - Simple Informational Hook

**Purpose**: Log git, gh, and dotfile commands to stderr

**File**: `/Users/markayers/.claude/hooks/log-git-commands.sh`

**Why It's Good**:

- ✓ Simple and focused
- ✓ Safe jq parsing with `// empty` default
- ✓ Always exits 0 (informational only)
- ✓ Clear purpose
- ✓ Very fast (<5ms)

**Complete Implementation**:

```bash
#!/usr/bin/env bash
# Log git, gh, and dot commands to stderr

stdin_data=$(cat)
command=$(echo "$stdin_data" | jq -r '.tool_input.command // empty')

if [[ "$command" =~ ^(git|gh|dot) ]]; then
    echo "[Hook] Git command: $command" >&2
fi

exit 0
```

**Pattern Analysis**:

1. Shebang line for bash
2. Clear header comment
3. Read stdin to variable
4. Safe jq parsing with default
5. Simple regex matching
6. Clear output to stderr
7. Always exits 0

## Before/After Refactorings

### Example 1: Missing try/except

**Before** (✗ Bad):

```python
#!/usr/bin/env python3
import json
import sys

# Will crash on invalid JSON!
data = json.load(sys.stdin)
file_path = data["tool_input"]["file_path"]  # Will crash if key missing

if not file_path.endswith(".py"):
    sys.exit(0)

# Validation logic...
if errors:
    sys.exit(2)
else:
    sys.exit(0)
```

**Problems**:

- No try/except wrapper
- Will crash on invalid JSON
- Direct key access (crashes if keys don't exist)
- No error handling for hook failures

**After** (✓ Good):

```python
#!/usr/bin/env python3
import json
import sys

try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")

    if not file_path:
        sys.exit(0)

    if not file_path.endswith(".py"):
        sys.exit(0)

    # Validation logic...
    if errors:
        sys.exit(2)
    else:
        sys.exit(0)

except Exception as e:
    print(f"Error in hook: {e}", file=sys.stderr)
    sys.exit(0)  # Don't block on hook error
```

**Improvements**:

- Added try/except wrapper
- Safe JSON parsing with `.get()`
- Exit 0 on hook errors
- Clear error message

### Example 2: Wrong Exit Codes

**Before** (✗ Bad):

```python
#!/usr/bin/env python3
import json
import sys

try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")

    if not file_path.endswith(".md"):
        sys.exit(1)  # Wrong! Should be 0

    errors = validate_file(file_path)

    if errors:
        print("Validation failed", file=sys.stderr)
        sys.exit(1)  # Wrong! Should be 2

    sys.exit(0)

except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)  # Wrong! Should be 0
```

**Problems**:

- Uses exit 1 instead of 0 for non-matching files
- Uses exit 1 instead of 2 for validation failures
- Uses exit 1 instead of 0 for hook errors

**After** (✓ Good):

```python
#!/usr/bin/env python3
import json
import sys

try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")

    if not file_path.endswith(".md"):
        sys.exit(0)  # Not our file type, allow

    errors = validate_file(file_path)

    if errors:
        print("Validation failed:", file=sys.stderr)
        for error in errors:
            print(f"  • {error}", file=sys.stderr)
        sys.exit(2)  # Block operation

    sys.exit(0)  # Allow operation

except Exception as e:
    print(f"Error in hook: {e}", file=sys.stderr)
    sys.exit(0)  # Don't block on hook error
```

**Improvements**:

- Exit 0 for non-matching files
- Exit 2 for validation failures
- Exit 0 for hook errors
- Better error messages

### Example 3: Missing Dependency Check

**Before** (✗ Bad):

```python
#!/usr/bin/env python3
import json
import sys
import yaml  # Crashes if PyYAML not installed!

try:
    data = json.load(sys.stdin)
    content = data.get("tool_input", {}).get("content", "")

    config = yaml.safe_load(content)

    # Validation...
    if errors:
        sys.exit(2)
    else:
        sys.exit(0)

except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(0)
```

**Problems**:

- No dependency checking
- Crashes if PyYAML not installed
- Blocks user on missing dependency

**After** (✓ Good):

```python
#!/usr/bin/env python3
import json
import sys

# Check for optional dependency
try:
    import yaml
except ImportError:
    print("Warning: PyYAML not installed, skipping validation", file=sys.stderr)
    sys.exit(0)  # Don't block

try:
    data = json.load(sys.stdin)
    content = data.get("tool_input", {}).get("content", "")

    config = yaml.safe_load(content)

    # Validation...
    if errors:
        sys.exit(2)
    else:
        sys.exit(0)

except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(0)
```

**Improvements**:

- Check dependency before use
- Exit 0 if missing (don't block)
- Clear warning message

### Example 4: No Early Exit

**Before** (✗ Bad):

```python
#!/usr/bin/env python3
import json
import sys
import yaml

try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")
    content = data.get("tool_input", {}).get("content", "")

    # Expensive parsing BEFORE checking file type!
    config = yaml.safe_load(content)  # Slow for all files

    # Finally check if we need this
    if not file_path.endswith(".yaml"):
        sys.exit(0)

    # Now validate...
    if errors:
        sys.exit(2)

    sys.exit(0)

except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(0)
```

**Problems**:

- No early exit
- Parses all files before checking type
- Slow performance (<500ms missed)

**After** (✓ Good):

```python
#!/usr/bin/env python3
import json
import sys

try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")
    content = data.get("tool_input", {}).get("content", "")

    # Early exit for non-matching files
    if not file_path:
        sys.exit(0)

    if not file_path.endswith(".yaml"):
        sys.exit(0)  # Fast exit (<1ms)

    # Only import and parse if needed
    import yaml
    config = yaml.safe_load(content)

    # Now validate...
    if errors:
        sys.exit(2)

    sys.exit(0)

except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(0)
```

**Improvements**:

- Early exit for non-matching files
- Lazy import (only import yaml if needed)
- Fast for non-matching files (<1ms)
- Expensive operations only when necessary

## Bad Examples (Anti-Patterns)

### Anti-Pattern 1: Blocking Hook (Worst Possible)

```python
#!/usr/bin/env python3
import json
import sys
import yaml

# Will crash on invalid JSON (blocks user)
data = json.load(sys.stdin)
file_path = data["tool_input"]["file_path"]  # Crashes if key missing
content = data["tool_input"]["content"]

# Will crash if PyYAML not installed (blocks user)
config = yaml.safe_load(content)

# Wrong exit code (blocks user on validation failure)
if not validate(config):
    sys.exit(1)  # Wrong! Should be 2

sys.exit(0)
```

**Problems** (Fatal):

- No try/except
- No dependency checking
- Direct key access
- Wrong exit code
- Will crash and block user

### Anti-Pattern 2: Silent Hook

```python
#!/usr/bin/env python3
import json
import sys

try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")

    if not file_path.endswith(".md"):
        sys.exit(0)

    errors = validate(file_path)

    if errors:
        # Silent! No error message
        sys.exit(2)

    sys.exit(0)

except Exception:
    # Silent! No error message
    sys.exit(0)
```

**Problems**:

- No error messages
- User doesn't know why operation blocked
- Hard to debug

### Anti-Pattern 3: Slow Hook

```python
#!/usr/bin/env python3
import json
import sys
import requests
import time

try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")

    # Network request (1-5 seconds!) in PreToolUse hook
    response = requests.get("https://api.example.com/validate")
    if not response.json()["valid"]:
        sys.exit(2)

    # Unnecessary sleep
    time.sleep(1)

    sys.exit(0)

except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(0)
```

**Problems**:

- Network request in PreToolUse (blocks user for 1-5s)
- Unnecessary delays
- > 500ms target missed

## Settings.json Registration Examples

### PreToolUse Hook

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "command": "python3 ~/.claude/hooks/validate-config.py",
            "timeout": 5000
          }
        ]
      }
    ]
  }
}
```

### PostToolUse Hook

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "command": "~/.claude/hooks/auto-format.sh",
            "timeout": 10000
          }
        ]
      }
    ]
  }
}
```

### Multiple Hooks on Same Trigger

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "command": "~/.claude/hooks/log-git-commands.sh",
            "timeout": 5000
          },
          {
            "command": "~/.claude/hooks/validate-bash-commands.py",
            "timeout": 5000
          }
        ]
      }
    ]
  }
}
```

## Summary

**Good Hook Characteristics**:

1. ✓ Safe JSON parsing (try/except, .get())
2. ✓ Correct exit codes (0=allow, 2=block, never 1)
3. ✓ Dependency checking (exit 0 if missing)
4. ✓ Clear error messages to stderr
5. ✓ Early exits for non-matching files
6. ✓ Fast performance (<500ms PreToolUse)
7. ✓ Proper shebang and header comments
8. ✓ Registered correctly in settings.json

**Bad Hook Characteristics**:

1. ✗ No error handling (crashes block user)
2. ✗ Wrong exit codes (exit 1)
3. ✗ No dependency checking (import failures block)
4. ✗ Silent failures (no error messages)
5. ✗ No early exits (slow performance)
6. ✗ Network requests in PreToolUse (slow)
7. ✗ Direct key access (crashes if key missing)
8. ✗ Blocks user on hook errors

Study the good examples (validate-config.py, log-git-commands.sh) and avoid the anti-patterns!

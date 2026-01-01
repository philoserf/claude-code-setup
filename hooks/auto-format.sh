#!/bin/bash
# Auto-format hook - runs after Edit|Write operations
# Formats Go, JS/TS, JSON, YAML files using gofmt and prettier
#
# Note: Intentionally no 'set -euo pipefail' - hooks must always exit 0

# Read tool input JSON from stdin and extract file path
if ! file_path=$(jq -r '.tool_input.file_path // empty' 2>/dev/null); then
	exit 0 # Graceful exit if JSON parsing fails
fi

if [ -z "$file_path" ]; then
	exit 0
fi

# Format based on file extension
case "$file_path" in
*.go)
	command -v gofmt &>/dev/null && gofmt -w "$file_path" 2>/dev/null
	;;
*.ts | *.tsx | *.js | *.jsx | *.json | *.yaml | *.yml)
	command -v prettier &>/dev/null && prettier --write "$file_path" 2>/dev/null
	;;
*.md)
	command -v prettier &>/dev/null && prettier --write "$file_path" 2>/dev/null
	command -v markdownlint &>/dev/null && markdownlint --fix "$file_path" 2>/dev/null
	;;
esac

exit 0

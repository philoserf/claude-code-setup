#!/bin/bash
# Git command logging hook - logs all git/gh commands with timestamps

command=$(jq -r '.tool_input.command // empty')
description=$(jq -r '.tool_input.description // "No description"')

# Only log git/gh/dot commands
if echo "$command" | grep -qE '^(git|gh|dot)\s'; then
	timestamp=$(date '+%Y-%m-%d %H:%M:%S')
	echo "[$timestamp] $command | $description" >>~/.claude/logs/git-commands.log
fi

exit 0 # Never block, just log

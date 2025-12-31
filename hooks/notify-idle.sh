#!/bin/bash
# Desktop notification hook - alerts when Claude needs input

# Use macOS native notification system
osascript -e 'display notification "Claude is waiting for your input" with title "Claude Code" sound name "Glass"'

exit 0

#!/bin/bash
# Session context loading hook - injects recent git activity and issues

cd "$CLAUDE_PROJECT_DIR" || exit 0

# Only run if in a git repository
if [ ! -d .git ]; then
	exit 0
fi

echo "## Recent Activity Context"
echo ""
echo "### Last 5 Commits"
git log --oneline -5 2>/dev/null || echo "No git history"
echo ""

# Check if gh is available and repo has GitHub remote
if command -v gh &>/dev/null && gh repo view &>/dev/null 2>&1; then
	echo "### Open GitHub Issues"
	gh issue list --state open --limit 5 2>/dev/null || echo "No open issues"
	echo ""
fi

exit 0

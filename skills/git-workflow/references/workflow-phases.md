# Workflow Phase Details

This document provides detailed instructions for each phase of the git-workflow skill.

## Phase 0: Branch Management

**Goal**: Ensure work is happening on an appropriate branch.

**Steps**:

1. Check current branch: `git branch --show-current`
2. If on main/master/develop (protected branches):
   - Analyze changes to understand the type of work
   - Suggest appropriate branch name:
     - `feature/<description>` for new features
     - `fix/<description>` for bug fixes
     - `refactor/<description>` for refactoring
     - `docs/<description>` for documentation
     - `test/<description>` for test additions
   - Use kebab-case for descriptions
   - Ask user if they want to create a new branch
3. If confirmed: `git checkout -b <branch-name>`

**Skip this phase if**:

- User is already on a feature branch
- User explicitly wants to commit to current branch

## Phase 1: Repository Analysis

**Goal**: Thoroughly understand the current repository state and changes.

**Steps**:

1. Run these commands in parallel:
   - `git status --short` - See changed files compactly
   - `git diff` - See unstaged changes
   - `git diff --staged` - See staged changes (if any)
   - `git log --oneline -n 10` - See recent commit history

2. Analyze the changes to identify:
   - Types of changes (feature, fix, refactor, docs, config, tests)
   - Affected files and their relationships
   - Logical groupings for atomic commits
   - Any untracked files that might need attention

**Safety Checks**:

- Check for merge conflict markers in diff output
- Check for rebase in progress (look for `.git/rebase-merge` or `.git/rebase-apply`)
- Alert user and stop if conflicts or rebase in progress

## Phase 2: Organize into Atomic Commits

**Goal**: Group changes into logical, atomic commits that each represent a single coherent change.

**Atomic Commit Principles**:

- Each commit should represent ONE logical change
- Commits should be self-contained and compilable
- Related changes stay together (e.g., code + its tests)
- Unrelated changes should be in separate commits

**Grouping Strategy** (in priority order):

1. **Bug fixes** - Fixes to existing functionality
2. **Tests** - New or updated tests
3. **Refactoring** - Code improvements without behavior change
4. **Features** - New functionality
5. **Documentation** - README, comments, docs
6. **Configuration** - Build configs, dependencies, settings

**Steps**:

1. Analyze all changed files
2. Group files by the categories above
3. Within each category, identify sub-groups if changes are independent
4. Create a commit plan showing:
   - Each proposed commit
   - Files included
   - Brief description of what the commit will represent
5. Present plan to user for approval/adjustment

**Use TodoWrite** to track commits to be created if there are 3+ commits.

## Phase 3: Create Commits

**Goal**: Create each commit with a properly formatted commit message.

**For each commit in the plan**:

1. Stage the files: `git add <file1> <file2> ...`

2. Generate commit message following these rules:
   - **Summary line**: ≤72 characters, imperative mood, capitalize, no period
   - **Body**: Wrap at 72 characters, explain WHY not WHAT
   - Use bullet points for multiple aspects
   - Provide context that code can't convey

3. Execute commit using heredoc:

   ```bash
   git commit -m "$(cat <<'EOF'
   Summary line here

   Detailed body here if needed.

   - Bullet points if needed
   - Additional context
   EOF
   )"
   ```

4. Verify commit succeeded: `git log -1 --oneline`

**Commit Message Format**:

For detailed formatting rules, examples, and templates, see [commit-format.md](commit-format.md). Key rules:

- **Imperative mood**: "Add feature" not "Added feature"
- **Be specific**: "Fix null pointer in login" not "Fix bug"
- **Explain WHY**: Body should explain motivation and context
- **72 characters**: Summary ≤72 chars, body wrapped at 72

Good examples:

- "Add retry logic for failed API requests"
- "Fix race condition in payment processing"
- "Refactor database connection pooling for efficiency"

Bad examples:

- "fixed bug" (not imperative, not descriptive)
- "WIP" (never commit work-in-progress messages)
- "Added new feature for users." (past tense, has period)

## Phase 4: Commit History Cleanup (Optional)

**Goal**: Optionally reorganize recent commits for a cleaner history before pushing.

**When to offer cleanup**:

- Multiple commits exist that could be squashed
- Recent commit messages could be improved
- Commits would make more sense in different order
- Found "WIP" or "fix" commits that should be squashed

**When NOT to cleanup**:

- Commits have already been pushed to remote (unless user explicitly wants to force push)
- User is on shared branch with other developers
- Only one commit to push

**Safety First**:

1. Check if commits have been pushed: `git log origin/<branch>..HEAD`
2. If commits are pushed, warn about force push requirement
3. Ask user for explicit confirmation before proceeding

**Important**: NEVER use `git rebase -i` - it requires interactive input. Instead, explain to the user what commands they need to run manually, or use non-interactive git commands to achieve the same result (like `git reset --soft` followed by recommitting).

**For detailed rebase safety guidelines, commands, and examples, see [rebase-guide.md](rebase-guide.md).**

## Phase 5: Push with Confirmation

**Goal**: Push commits to remote safely after user approval.

**Steps**:

1. **CRITICAL: Protected Branch Detection** (MUST BE FIRST):

   ```bash
   CURRENT_BRANCH=$(git branch --show-current)
   PROTECTED_BRANCHES=("main" "master" "develop" "production" "staging")

   # Check if current branch is protected
   if [[ " ${PROTECTED_BRANCHES[@]} " =~ " ${CURRENT_BRANCH} " ]]; then
     # STOP - Do NOT proceed with normal push flow
     # Enter Protected Branch Push Protocol
     # See references/protected-branch-protocol.md
   fi
   ```

   **If protected branch detected:**
   - **BLOCK the push** - do not show confirmation dialog
   - Display blocking message explaining why
   - Present 3 options using AskUserQuestion:
     1. Create feature branch and migrate commits (recommended)
     2. Rename current branch to feature branch
     3. Emergency override with reason (logged)
   - Execute chosen option from protocol
   - See **[protected-branch-protocol.md](protected-branch-protocol.md)** for complete details

2. **Check for force push requirement:**

   ```bash
   # Detect if force push would be needed
   if git push --dry-run 2>&1 | grep -q "rejected.*non-fast-forward"; then
     # Force push required

     # If current branch is protected - ABSOLUTELY BLOCK
     if [[ " ${PROTECTED_BRANCHES[@]} " =~ " ${CURRENT_BRANCH} " ]]; then
       echo "🛑 ABSOLUTELY BLOCKED: Force push to protected branch"
       # See protected-branch-protocol.md for blocking message
       # Exit - do not allow
     fi
   fi
   ```

3. Show summary of commits to be pushed:

   ```bash
   git log origin/<branch>..HEAD --oneline
   ```

   (or just `git log --oneline -n <count>` if new branch)

4. Present summary to user:
   - Number of commits
   - Branch name
   - First line of each commit message
   - Whether this is a new branch or existing branch

5. Ask user for confirmation to push using AskUserQuestion

6. If user confirms:
   - For new branch: `git push -u origin <branch-name>`
   - For existing branch: `git push`

7. Verify push succeeded and show result

**Safety Checks** (in order):

1. **Protected branch check** - MUST be first, blocks if protected
2. **Force push to protected branch** - Absolutely blocked, no override
3. Verify remote exists: `git remote -v`
4. If no remote, help user set one up before pushing
5. Handle push failures gracefully (show error, suggest fixes)

**Key Principle**: Always check for protected branch BEFORE showing push confirmation. The user should never get to confirmation if on a protected branch.

## Phase 6: Pull Request Creation (Optional)

**Goal**: Optionally create a pull request after successful push.

**Steps**:

1. After successful push, ask if user wants to create a PR

2. If yes:
   - Verify `gh` CLI is available: `gh --version`
   - If not available, provide GitHub web URL for PR creation

3. Get base branch (default: main/master)
   - Detect default branch: `git remote show origin | grep "HEAD branch"`
   - Ask user if different base is needed

4. Generate PR title and description:
   - Title: Use first commit message summary (if single commit) or create from all commits
   - Description:

     ```markdown
     ## Summary

     [Brief overview of changes]

     ## Changes

     - [Bullet points from commits]

     ## Testing

     [Mention any test additions]
     ```

5. Show generated PR content to user for review

6. Create PR:

   ```bash
   gh pr create --title "<title>" --body "$(cat <<'EOF'
   <description>
   EOF
   )"
   ```

7. Show PR URL to user

**Alternative if gh not available**:

- Provide direct GitHub URL: `https://github.com/<owner>/<repo>/compare/<branch>`

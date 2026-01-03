# Protected Branch Push Protocol

This document details the protocol for preventing direct pushes to protected branches (main/master/develop/production/staging).

## Overview

**Philosophy**: It's easier to override when you know what you're doing than to undo a bad push to main.

Direct pushes to protected branches are dangerous because they:

1. **Bypass code review** - No PR means no review process
2. **Break CI/CD** - Many projects protect main in GitHub but not locally
3. **Risk production** - Main often auto-deploys to production
4. **Lose history** - Can't easily revert without force push
5. **Team disruption** - Unexpected changes appear in main

## Detection Logic

**Before pushing, check if the current branch is protected:**

```bash
CURRENT_BRANCH=$(git branch --show-current)
PROTECTED_BRANCHES=("main" "master" "develop" "production" "staging")

# Check if current branch is in protected list
if [[ " ${PROTECTED_BRANCHES[@]} " =~ " ${CURRENT_BRANCH} " ]]; then
  # STOP - Enter protected branch push protocol
  # Do NOT push - block the operation
fi
```

**When to check**:

- In Phase 5, before showing the push confirmation dialog
- After user has created commits, before actually pushing

## Protected Branch Push Protocol

When a push to a protected branch is detected, **BLOCK** the operation and present this message:

```
🛑 BLOCKED: Cannot push directly to `{branch}` branch

Direct pushes to protected branches are not allowed.

Why this is blocked:
• Bypasses code review process
• Risk of breaking production
• No opportunity for team feedback
• Makes history harder to track

What you should do instead:

Option 1: Create a feature branch (Recommended)
  Move your commits to a new feature branch, then create a PR

Option 2: Rename current branch
  If you meant to be on a feature branch, rename it

Option 3: Emergency override (hotfix only)
  Only for critical hotfixes - requires explicit reason

Which option would you like? [1/2/3]
```

Use **AskUserQuestion** to present these options with descriptions.

## Option 1: Create Feature Branch (Recommended)

**Steps to automate**:

1. **Suggest branch name based on commits:**
   - Analyze recent commits not in origin/{branch}
   - Determine type of work (fix, feature, refactor, docs, test)
   - Generate descriptive name following convention
   - Example: `fix/login-validation`, `feature/user-dashboard`

2. **Show the migration plan:**

   ```
   I'll help you move these commits to a feature branch:

   1. Create new branch: {suggested-name}
   2. Cherry-pick commits from {protected-branch}
   3. Reset {protected-branch} to origin/{protected-branch}
   4. Push {suggested-name} to remote
   5. Offer to create PR

   Commits to migrate:
   - {commit-hash} {commit-message}
   - {commit-hash} {commit-message}

   Proceed with this plan?
   ```

3. **Execute the migration:**

   ```bash
   # Get commits to migrate (not in origin)
   COMMITS=$(git log origin/{protected-branch}..HEAD --format="%H" | tac)

   # Create feature branch from origin/{protected-branch}
   git checkout -b {feature-branch} origin/{protected-branch}

   # Cherry-pick commits to feature branch
   for commit in $COMMITS; do
     git cherry-pick $commit
   done

   # Switch back to protected branch and reset to origin
   git checkout {protected-branch}
   git reset --hard origin/{protected-branch}

   # Switch to feature branch for push
   git checkout {feature-branch}
   ```

4. **Push feature branch:**
   - Use `git push -u origin {feature-branch}`
   - Confirm success
   - Proceed to Phase 6 (PR creation)

**Edge case - origin doesn't exist:**

- If `origin/{protected-branch}` doesn't exist, branch from current HEAD instead
- Warn user that protected branch isn't tracking remote

## Option 2: Rename Current Branch

**Use when:** User forgot to create a feature branch and has been working on main by mistake.

**Steps to automate:**

1. **Ask for new branch name:**
   - Suggest name based on commits
   - Allow user to customize

2. **Show the plan:**

   ```
   I'll rename your current branch and recreate {protected-branch}:

   1. Rename {protected-branch} → {feature-branch}
   2. Recreate {protected-branch} from origin/{protected-branch}
   3. Push {feature-branch} to remote
   4. Offer to create PR

   This preserves all your work on {feature-branch} and resets
   {protected-branch} to match the remote.

   Proceed?
   ```

3. **Execute the rename:**

   ```bash
   # Rename current protected branch to feature branch
   git branch -m {protected-branch} {feature-branch}

   # Recreate protected branch from origin
   git checkout -b {protected-branch} origin/{protected-branch}

   # Switch to feature branch for push
   git checkout {feature-branch}
   ```

4. **Push renamed branch:**
   - Use `git push -u origin {feature-branch}`
   - Confirm success
   - Proceed to Phase 6 (PR creation)

**Edge case - uncommitted changes:**

- If there are uncommitted changes, offer to stash them first
- After rename, offer to restore stashed changes

## Option 3: Emergency Override

**Use ONLY for:** Critical hotfixes that must go directly to protected branch.

**Valid reasons:**

- Security vulnerability fix needed immediately
- Production is down and this fixes it
- Critical data loss prevention

**Invalid reasons:**

- "I forgot to branch"
- "It's just a small change"
- "I don't want to make a PR"

**Steps:**

1. **Explain the severity:**

   ```
   ⚠️ EMERGENCY OVERRIDE REQUIRED

   This should ONLY be used for critical hotfixes that must go
   directly to {protected-branch}.

   Examples of VALID reasons:
   ✓ Security vulnerability fix needed immediately
   ✓ Production is down and this fixes it
   ✓ Critical data loss prevention

   Examples of INVALID reasons:
   ✗ "I forgot to branch"
   ✗ "It's just a small change"
   ✗ "I don't want to make a PR"

   This override will be logged for audit purposes.
   ```

2. **Collect reason and confirmation:**

   Use **AskUserQuestion** to ask:
   - "What is the emergency that requires direct push to {protected-branch}?"
     (text input required)
   - "Type 'I UNDERSTAND THE RISKS' to confirm"
     (must match exactly)

3. **Log the override:**

   ```bash
   # Log to git note for audit trail
   git notes append -m "EMERGENCY OVERRIDE: Direct push to {protected-branch}
   Reason: {user-reason}
   Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
   User: $(git config user.email)"
   ```

4. **Proceed with push:**
   - Show final warning
   - Execute `git push`
   - **Still recommend creating a PR for documentation:**

   ```
   Push completed.

   ⚠️ IMPORTANT: Even though you pushed directly, please create a
   PR for documentation and tracking purposes:

   This PR won't require approval (already merged), but provides:
   • Visible record of changes
   • Place for discussion
   • Better commit visibility

   Create documentation PR now?
   ```

## Force Push Protection

Force pushing to protected branches is **ABSOLUTELY BLOCKED** with no override:

```bash
# Detect force push requirement
if git push --dry-run 2>&1 | grep -q "rejected.*non-fast-forward"; then
  NEEDS_FORCE_PUSH=true
fi
```

**If force push needed to protected branch:**

```
🛑 ABSOLUTELY BLOCKED: Force push to {protected-branch}

Force pushing to protected branches is extremely dangerous:
• Rewrites shared history
• Breaks other developers' work
• Can lose commits permanently

This is blocked without exception.

If you absolutely need to do this:
1. Contact your team lead
2. Notify all team members
3. Use git directly (outside this skill)
4. Document what happened and why

For now, please use Option 1 or Option 2 above to safely
handle your changes.
```

**Do NOT proceed** - exit the workflow and require user to handle manually.

## Edge Cases

### Hotfix Branches

Some teams use `hotfix/*` branches that merge to main:

```bash
# Check if current branch is a hotfix branch
if [[ $CURRENT_BRANCH =~ ^hotfix/ ]]; then
  # Allow push to hotfix branch (not protected)
  # But warn that this will merge to main
  # Require PR creation to main
fi
```

**Message:**

```
This is a hotfix branch that will merge to {protected-branch}.

Allowing push to {current-branch}, but you MUST:
1. Push this hotfix branch
2. Create PR to {protected-branch}
3. Get it reviewed before merging

Proceed with push to {current-branch}?
```

### Release Branches

Similar to hotfix:

```bash
# Check if current branch is a release branch
if [[ $CURRENT_BRANCH =~ ^release/ ]]; then
  # Allow push to release branch
  # Suggest PR to main for tracking
fi
```

### Already Pushed Commits

If some commits already exist on `origin/{protected-branch}`:

```bash
# Check if any commits already pushed
git log origin/{protected-branch}..HEAD
```

**If some commits are new, some already pushed:**

```
⚠️ WARNING: Some commits already pushed to origin/{protected-branch}

This is unusual. You have {n} commits:
• {x} already on remote
• {y} new commits not pushed

Options:
1. Continue with Option 1/2 (migrate new commits only)
2. Stop and investigate why some commits are already remote
3. Contact team lead

What would you like to do?
```

### Detached HEAD

If in detached HEAD state:

```
⚠️ You are in detached HEAD state

Before proceeding with protected branch protocol, let's
get you onto a proper branch.

Would you like to:
1. Create new branch from current commit
2. Return to {protected-branch}
3. Investigate current state
```

### No Remote Configured

If no remote exists:

```
⚠️ No remote repository configured

Cannot determine if branch is behind remote.

Would you like to:
1. Add remote repository (recommended)
2. Proceed without remote verification (risky)
```

## Configuration

Protected branches can be configured in the skill. Default list:

```
PROTECTED_BRANCHES=("main" "master" "develop" "production" "staging")
```

**Future enhancement**: Could read from:

- Git config: `git config --get-regexp branch.*.protected`
- `.gitprotected` file in repo root
- GitHub branch protection API

## Summary

**Protection flow:**

1. **Phase 5 begins** → Check if current branch is protected
2. **If protected** → BLOCK push, show protocol message
3. **User chooses option:**
   - Option 1: Automate feature branch migration
   - Option 2: Automate branch rename
   - Option 3: Require emergency justification + confirmation
4. **Execute chosen option** → Resolve safely
5. **Continue workflow** → Push to feature branch or log override

**Key principles:**

- **Block first, explain second** - Don't let the push happen
- **Educate the user** - Explain why it's dangerous
- **Provide easy alternatives** - Make doing the right thing easy
- **Allow emergencies** - But make them explicit and logged
- **No force push** - Absolutely blocked, no exceptions

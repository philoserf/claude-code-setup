---
disable-model-invocation: true
description: "Executes the release workflow for Obsidian plugins after obsidian-release-gate passes. Use when tagging, cutting, or shipping a plugin release. Follows the prep-PR pattern: version bump, CHANGELOG, and walkthrough ship in one PR before tagging."
allowed-tools:
  - Bash
  - Read
  - Edit
  - Skill
---

# Release (Obsidian Plugin)

Final step in the release pipeline. Assumes `obsidian-release-gate` has already passed and the target version has been decided.

This skill follows the **prep-PR pattern**: version bump + CHANGELOG + walkthrough ship as one atomic PR. The tag is applied **after merge**, pointing at the merged commit. Do **not** use `bun version` or `npm version` with auto-tag — they tag immediately and skip the CHANGELOG/walkthrough step.

The workflow is a single linear pass — run the phases in order:

1. Prep branch → 2. Version bump → 3. CHANGELOG → 4. Walkthrough → 5. Commit & open PR → **(merge)** → 6. Tag after merge → 7. Push tag → 8. Update release notes → 9. Verify

## Prerequisites

Before starting, confirm:

- `obsidian-release-gate` passed with no FAIL status, **or** exited `3` (NOT STARTED),
  which is the normal state before a release: it means the current version is already
  tagged and phases 1-5 below are exactly what it is asking for. Re-run the gate after
  the prep PR merges and require a clean pass before Phase 6.
- Working tree is clean and on `main`
- Target version decided
- Target version is not already tagged (`git tag -l <version>`)
- `jq` and `gh` are on `PATH`; `yq` is optional (Phase 7 documents a grep fallback)

If any prerequisite is unclear, ask rather than proceeding.

## Workflow

### Phase 1: Prep Branch

Create a feature branch off `main`:

```bash
git checkout -b release/<version>
```

### Phase 2: Version Bump

Edit `package.json` directly (do not run `npm version` / `bun version` — they auto-tag):

1. Edit the `version` field in `package.json` to `<version>`.
2. Sync `manifest.json` and `versions.json` by running the version script with the env var:

   ```bash
   npm_package_version=<version> bun run version
   ```

   (`version` is the `package.json` script that invokes `version-bump.ts`.)

3. Verify all three files agree:

   ```bash
   jq -r '.version' package.json
   jq -r '.version' manifest.json
   jq -r 'keys[-1]' versions.json
   ```

   If they don't match, stop and surface the discrepancy.

### Phase 3: CHANGELOG

Add a `## <version>` section to `CHANGELOG.md` **above** the previous version entry. Draft the entry from `git log <last-tag>..HEAD` and present to the user for review before committing.

Example entry:

```markdown
## 1.4.0

### Added

- Support for nested callouts in preview mode

### Fixed

- Frontmatter properties no longer duplicate on save
```

Verify: `grep -n "^## " CHANGELOG.md | head -3` shows the new `## <version>` section above the previous release's.

### Phase 4: Walkthrough

If `walkthrough.md` exists, regenerate it via the `walkthrough` skill so code blocks reflect the release state.

**Regenerating the blocks is not enough.** `showboat verify` only re-executes code
blocks and diffs their output — it never reads the surrounding prose. A release that
renames or deletes an identifier leaves the commentary describing something that no
longer exists, and the gate still goes green. After regenerating, grep the prose for
what this release changed:

```bash
# identifiers the release touched, outside fenced blocks
git diff <last-tag>..HEAD --name-only -- 'src/*' \
  | xargs -I{} basename {} .ts | sort -u
grep -n '<renamed-or-deleted-identifier>' walkthrough.md
```

Fix the prose in the same commit. Stale commentary is the failure mode the walkthrough
exists to prevent.

### Phase 5: Commit and Open PR

One atomic commit for the whole prep:

```bash
git add package.json manifest.json versions.json CHANGELOG.md
[ -f walkthrough.md ] && git add walkthrough.md
git commit -m "chore: prepare release <version>"
```

Confirm with the user before pushing, then:

```bash
git push -u origin release/<version>
gh pr create --title "chore: prepare release <version>" --body "..."
```

Draft the PR body from the CHANGELOG entry.

Verify: `git show --stat HEAD` lists exactly the files staged above (nothing extra), and `gh pr view --json state,url` reports the PR as `OPEN`.

Before handing off, confirm CI is green on the PR head:

```bash
gh pr checks <num>
```

Stop here and wait for the PR to merge — the user reviews and merges it (possibly after CI runs and feedback).

### Phase 6: Tag After Merge

Once the PR is merged, sync local `main` and tag the merged commit. Tags use bare version numbers (no `v` prefix):

```bash
git checkout main
git pull --ff-only origin main
MERGED_SHA=$(gh pr list --state merged --head "release/<version>" \
  --json mergeCommit --jq '.[0].mergeCommit.oid')
if [ -z "$MERGED_SHA" ]; then
  echo "No merged PR found for branch release/<version>."
  echo "Find it with 'gh pr list --state merged --limit 5' and read its mergeCommit."
  exit 1
fi
git tag -a <version> -m "Release <version>" "$MERGED_SHA"
```

Keyed on the **prep branch**, not on a commit message. An earlier version of this
skill grepped `git log` for `chore: prepare release <version>`, which finds nothing
the moment anyone words the subject differently — and the skill cannot enforce its
own suggested wording once a human edits the squash-merge dialog. The branch name is
set by Phase 1 and survives squash, rebase, and subject rewrites.

Confirm with the user before pushing the tag.

### Phase 7: Push Tag

```bash
git push origin <version>
```

The tag push triggers `.github/workflows/release.yml`, which builds the plugin and creates a GitHub release whose assets are whatever that workflow's `files:` block lists. Common combinations: `main.js + manifest.json`, or `main.js + manifest.json + styles.css`. Extract the actual list before producing the final output:

```bash
yq '.jobs.build.steps[] | select(.uses == "softprops/action-gh-release*") | .with.files' .github/workflows/release.yml
```

If `yq` is unavailable, grep for the `files:` block and read the lines that follow.

### Phase 8: Update Release Notes

Wait for the release workflow to complete, then read its conclusion. The poll
is bounded by a script that ships with this skill (no `timeout`(1) dependency —
macOS BSD userland doesn't ship it):

```bash
~/.claude/skills/obsidian-release-ship/scripts/wait-for-release.sh <version>
```

- Prints the run's conclusion (e.g. `success`, `failure`) on stdout and exits 0 when the run finishes.
- Exits 1 on timeout or if no run is found — report that and stop.
- Optional args override the defaults: `wait-for-release.sh <TAG> [MAX_SECONDS] [INTERVAL_SECONDS]` (default `600 15`).
- **The tag argument is required.** There is a gap between pushing the tag and the run
  appearing in the API; without the tag filter the script polls whichever release run
  is newest, which during that gap is the *previous* release — already
  `completed/success`. It would print `success` for a release that never started.

If the printed conclusion is not `success`, report the failure and stop.

Once the release exists, extract this version's CHANGELOG section and update the
GitHub release. A script ships with this skill so the extraction is not hand-rolled
each time:

```bash
~/.claude/skills/obsidian-release-ship/scripts/extract-changelog.sh <version> > /tmp/notes.md
gh release edit <version> --notes-file /tmp/notes.md
```

It prints everything between `## <version>` and the next `## ` heading, trimmed, and
exits 1 if that section does not exist. Avoid `sed -n '/^## X/,/^## /p'` — it prints
the next release's heading, and the version's dots act as regex wildcards.

### Phase 9: Verify

Confirm the release is live and report:

```bash
gh release view <version> --json tagName,name,body,assets
```

## Output

```text
Release: <version>
====================
Prep PR:        #<num> (merged <sha>)
Files bumped:   package.json, manifest.json, versions.json
CHANGELOG:      ## <version> added
Walkthrough:    regenerated
Tag:            <version> → <sha>
GitHub release: <url>
Assets:         <list extracted from release.yml — e.g. main.js, manifest.json>
Release notes:  updated from CHANGELOG.md
```

## Do not use when

- Project is not an Obsidian plugin — use language-native release tooling
- Pre-tag validation hasn't run — use `obsidian-release-gate` first

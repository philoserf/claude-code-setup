# CLAUDE.md

## Tests

`tests/exit-codes.sh` is the only test suite in the `~/.claude` repo. It covers both halves of the
release pair — `obsidian-release-gate`'s version/tag state machine and `obsidian-release-ship`'s
changelog extractor — by building throwaway git repos in temp dirs, so it never touches a real
project.

```sh
skills/obsidian-release-gate/tests/exit-codes.sh
```

Assertions are row-level rather than on the aggregate exit code: a fixture repo cannot satisfy
every gate check (no remote for `gh`, no lockfile for `bun audit`), so an exit-code-only test
would pass for the wrong reason. There is **no single-test filter** — the script runs all three
labeled sections top to bottom and prints a pass/fail tally. To narrow a run, edit the script.

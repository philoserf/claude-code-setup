#!/bin/sh
# Claude Code status line — mirrors ~/.config/starship.toml
# Directory (repo-relative truncation, cyan) + git branch (yellow) +
# git status (compact symbols, red) + prompt-cache health (dim) + model display name

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')

trunc_len=3

# --- Directory: last N components, truncated to repo root when in a repo
repo_root=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)

if [ -n "$repo_root" ]; then
  repo_name=$(basename "$repo_root")
  rel=$(git -C "$cwd" --no-optional-locks rev-parse --show-prefix 2>/dev/null)
  rel=${rel%/}
  if [ -n "$rel" ]; then
    full_path="$repo_name/$rel"
  else
    full_path="$repo_name"
  fi
else
  case "$cwd" in
    "$HOME") full_path="~" ;;
    "$HOME"/*) full_path="~/${cwd#"$HOME"/}" ;;
    *) full_path="$cwd" ;;
  esac
fi

dir=$(printf '%s' "$full_path" | awk -F/ -v n="$trunc_len" '{
  count = NF
  start = (count > n) ? count - n + 1 : 1
  out = ""
  for (i = start; i <= count; i++) out = out (out == "" ? "" : "/") $i
  print out
}')

line=$(printf '\033[1;36m%s\033[0m' "$dir")

# --- Git branch (yellow) --------------------------------------------------
if [ -n "$repo_root" ]; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

  if [ -n "$branch" ]; then
    line="$line $(printf '\033[33m[%s]\033[0m' "$branch")"
  fi

  # --- Git status: compact symbols (starship defaults), bold red ---------
  porcelain=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
  staged=$(printf '%s\n' "$porcelain" | grep -c '^[MADRC]')
  modified=$(printf '%s\n' "$porcelain" | grep -c '^.[MT]')
  untracked=$(printf '%s\n' "$porcelain" | grep -c '^??')
  conflicted=$(printf '%s\n' "$porcelain" | grep -Ec '^(UU|AA|DD|AU|UA|UD|DU)')
  stashed=$(git -C "$cwd" --no-optional-locks stash list 2>/dev/null | wc -l | tr -d ' ')

  ahead=0
  behind=0
  upstream=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
  if [ -n "$upstream" ]; then
    counts=$(git -C "$cwd" --no-optional-locks rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null)
    ahead=$(printf '%s' "$counts" | awk '{print $1+0}')
    behind=$(printf '%s' "$counts" | awk '{print $2+0}')
  fi

  symbols=""
  [ "$conflicted" -gt 0 ] && symbols="$symbols="
  [ "$stashed" -gt 0 ] && symbols="$symbols\$"
  [ "$modified" -gt 0 ] && symbols="$symbols!"
  [ "$staged" -gt 0 ] && symbols="$symbols+"
  [ "$untracked" -gt 0 ] && symbols="$symbols?"
  [ "$ahead" -gt 0 ] && symbols="$symbols⇡$ahead"
  [ "$behind" -gt 0 ] && symbols="$symbols⇣$behind"

  if [ -n "$symbols" ]; then
    line="$line $(printf '\033[1;31m%s\033[0m' "$symbols")"
  fi
fi

# --- Prompt cache: hit ratio, warm/cold, last miss cause -------------------
cache=$(printf '%s' "$input" | jq -r '
  .prompt_cache // empty
  | select(.caching_observed == true and .hit_ratio != null)
  | [ (.hit_ratio * 100 | round),
      (if .warm then "warm" else "cold" end),
      (.misses // 0),
      ((.last_miss_cause.causes // [])
        | map(sub("^likely_"; "") | gsub("_"; " ")) | join("/"))
    ] | @tsv')

if [ -n "$cache" ]; then
  pct=$(printf '%s' "$cache" | cut -f1)
  warm=$(printf '%s' "$cache" | cut -f2)
  misses=$(printf '%s' "$cache" | cut -f3)
  cause=$(printf '%s' "$cache" | cut -f4)

  if [ "$warm" = "warm" ]; then
    glyph="⚡"
  else
    glyph="❄"
  fi
  line="$line $(printf '\033[2m%s%s%%\033[0m' "$glyph" "$pct")"

  if [ "$misses" -gt 0 ]; then
    if [ -n "$cause" ]; then
      miss="✗$misses $cause"
    else
      miss="✗$misses"
    fi
    line="$line $(printf '\033[35m%s\033[0m' "$miss")"
  fi
fi

printf '%s  %s' "$line" "$model"

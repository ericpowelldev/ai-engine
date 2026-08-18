#!/bin/bash
# Commit and push every module repo (never the baseline — engine commits are
# hand-written). Per module: dirty tree -> stage everything, commit, push;
# clean but ahead -> push only; clean and synced -> skip. Current branch only,
# never force. Usage: push.sh [commit message]

set -uo pipefail

AI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MSG="${1:-sync: $(date +%Y-%m-%d)}"

push_module() { # dir label
  local dir="$1" label="$2"
  if [ ! -d "$dir/.git" ]; then
    echo "skipped: $label (not a git repo — git init + add a remote to include it in backups)"
    return 0
  fi
  if [ -z "$(git -C "$dir" remote 2>/dev/null)" ]; then
    echo "skipped: $label (no remote configured)"
    return 0
  fi

  local branch
  branch="$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)"
  if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
    echo "skipped: $label (detached HEAD — check out a branch first)"
    return 0
  fi

  local committed=""
  if [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]; then
    git -C "$dir" add -A
    if git -C "$dir" commit -q -m "$MSG"; then
      committed=" (committed: \"$MSG\")"
    else
      echo "FAILED: $label — commit failed"
      return 0
    fi
  fi

  # Anything to push? (No upstream counts as ahead.)
  local ahead
  if git -C "$dir" rev-parse --abbrev-ref --symbolic-full-name "@{u}" > /dev/null 2>&1; then
    ahead="$(git -C "$dir" rev-list --count "@{u}..HEAD" 2>/dev/null || echo 0)"
    if [ "$ahead" = "0" ]; then
      echo "skipped: $label (nothing to commit or push)"
      return 0
    fi
    if out=$(git -C "$dir" push 2>&1); then
      echo "pushed: $label -> $branch$committed"
    else
      echo "FAILED: $label — $(echo "$out" | head -1)"
    fi
  else
    if out=$(git -C "$dir" push -u origin "$branch" 2>&1); then
      echo "pushed: $label -> $branch (upstream set)$committed"
    else
      echo "FAILED: $label — $(echo "$out" | head -1)"
    fi
  fi
}

for MODULE in "$AI_DIR"/modules/*/; do
  NAME="$(basename "$MODULE")"
  [ "$NAME" = "_template" ] && continue
  push_module "$MODULE" "module: $NAME"
done

#!/bin/bash
# Pull the baseline repo and every module repo, then re-run setup so pulled
# wiring/rules take effect. Safe: ff-only, never touches a dirty tree.

set -uo pipefail

AI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

pull_repo() { # dir label
  local dir="$1" label="$2"
  if [ ! -d "$dir/.git" ]; then
    # The baseline is always a repo (it was cloned); only modules can lack one.
    echo "skipped: $label (not a git repo)"
    return 0
  fi
  if [ -z "$(git -C "$dir" remote 2>/dev/null)" ]; then
    echo "skipped: $label (no remote configured)"
    return 0
  fi
  if [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]; then
    echo "skipped: $label (uncommitted changes — commit or stash first)"
    return 0
  fi
  local out
  if out=$(git -C "$dir" pull --ff-only 2>&1); then
    case "$out" in
      *"Already up to date"*) echo "up to date: $label" ;;
      *) echo "pulled: $label" ;;
    esac
  else
    echo "FAILED: $label — $(echo "$out" | head -1)"
  fi
}

pull_repo "$AI_DIR" "baseline"
for MODULE in "$AI_DIR"/modules/*/; do
  NAME="$(basename "$MODULE")"
  [ "$NAME" = "_template" ] && continue
  pull_repo "$MODULE" "module: $NAME"
done

echo "--- refreshing wiring ---"
bash "$AI_DIR/hooks/setup.sh"

#!/bin/bash
# PostToolUse hook (Write|Edit): an example check (replace with your own, or delete this
# file and its hooks.json entry). A hook enforces a rule mechanically: it reads the
# agent's hook payload (JSON) on stdin, exits 0 to stay quiet, or exits 2 with a message
# on stderr to feed a finding back to the agent. Keep it fast, side-effect-free, and
# coreutils-only so it runs on macOS, Linux, and Git Bash on Windows; a hook that needs
# an interpreter (python, node) fails open when that interpreter is missing.

INPUT=$(cat)

# The edited file's path, from the payload's first "file_path" field.
FILE_PATH=$(printf '%s' "$INPUT" \
  | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
  | head -n1 | sed 's|\\\\|/|g')

[ -f "$FILE_PATH" ] || exit 0

# <The check: e.g. flag a TODO left in a markdown file.>
if grep -q 'TODO' "$FILE_PATH" 2>/dev/null; then
  echo "TODO left in $FILE_PATH: resolve it or move it to the work's tracking (<the rule this enforces>)." >&2
  exit 2
fi

exit 0

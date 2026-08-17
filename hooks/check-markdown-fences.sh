#!/bin/bash
# PostToolUse hook (Write|Edit): flag indented code fences in markdown files.
# Enforces documenting-fences-column-zero. Exit 2 feeds the finding back to the agent.
# Pure coreutils (no python/node) so it runs on macOS, Linux, and Git Bash on Windows.

INPUT=$(cat)

# Extract tool_input.file_path from the hook JSON (first "file_path" occurrence),
# then normalize escaped Windows backslashes to forward slashes.
FILE_PATH=$(printf '%s' "$INPUT" \
  | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
  | head -n1 \
  | sed 's|\\\\|/|g')

case "$FILE_PATH" in
  *.md) ;;
  *) exit 0 ;;
esac

[ -f "$FILE_PATH" ] || exit 0

LINES=$(grep -nE '^[[:space:]]+(```|~~~)' "$FILE_PATH" | cut -d: -f1 | tr '\n' ' ')

if [ -n "$LINES" ]; then
  echo "Indented code fence(s) at line(s) ${LINES}in $FILE_PATH — fences must sit at column 0 (documenting-fences-column-zero). End the list or restructure, then flatten the fence." >&2
  exit 2
fi

exit 0

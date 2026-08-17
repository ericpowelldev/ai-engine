#!/bin/bash
# Mechanical half of /setup. Idempotent — safe to re-run after git pull or module changes.
# Installs: baseline import, global /orient command, rule skills, hook registration,
# and each present module's wiring. Never overwrites unrelated user config.

set -euo pipefail

AI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_USER_DIR="$HOME/.claude"
MANIFEST="$CLAUDE_USER_DIR/.ai-wiring-manifest"

mkdir -p "$CLAUDE_USER_DIR/commands" "$CLAUDE_USER_DIR/skills"

# --- 1. Baseline import in user-level CLAUDE.md ---
USER_CLAUDE_MD="$CLAUDE_USER_DIR/CLAUDE.md"
IMPORT_LINE="@$AI_DIR/CLAUDE.md"
touch "$USER_CLAUDE_MD"
if ! grep -qF "$IMPORT_LINE" "$USER_CLAUDE_MD"; then
  printf '\n%s\n' "$IMPORT_LINE" >> "$USER_CLAUDE_MD"
  echo "installed: baseline import in $USER_CLAUDE_MD"
else
  echo "ok: baseline import already present"
fi

# --- 2. Track-and-sync wiring (records installs so removed modules clean up) ---
NEW_MANIFEST="$(mktemp)"

install_file() { # src dst — resolves the {{AI_DIR}} placeholder in installed copies
  mkdir -p "$(dirname "$2")"
  sed "s|{{AI_DIR}}|$AI_DIR|g" "$1" > "$2"
  echo "$2" >> "$NEW_MANIFEST"
}

install_dir() { # srcdir dstdir
  [ -d "$1" ] || return 0
  ( cd "$1" && find . -type f ) | while read -r rel; do
    install_file "$1/${rel#./}" "$2/${rel#./}"
  done
}

# Global commands + skills (work in sessions booted anywhere).
# All root commands install globally except /setup, which only makes sense
# run from inside the baseline folder.
for CMD in "$AI_DIR"/.claude/commands/*.md; do
  [ "$(basename "$CMD")" = "setup.md" ] && continue
  install_file "$CMD" "$CLAUDE_USER_DIR/commands/$(basename "$CMD")"
done
install_dir "$AI_DIR/.claude/skills" "$CLAUDE_USER_DIR/skills"

# Module wiring -> user-level only (global commands/skills cover every session,
# and the committed .claude/ stays module-agnostic)
for MODULE in "$AI_DIR"/modules/*/; do
  [ -d "$MODULE/wiring" ] || continue
  install_dir "$MODULE/wiring/commands" "$CLAUDE_USER_DIR/commands"
  install_dir "$MODULE/wiring/skills"   "$CLAUDE_USER_DIR/skills"
  echo "synced module wiring: $(basename "$MODULE")"
done

# Remove files installed by a previous run that no longer exist in any source
if [ -f "$MANIFEST" ]; then
  while read -r OLD; do
    if [ -n "$OLD" ] && ! grep -qFx "$OLD" "$NEW_MANIFEST"; then
      rm -f "$OLD" && echo "removed stale wiring: $OLD"
    fi
  done < "$MANIFEST"
fi
sort -u "$NEW_MANIFEST" > "$MANIFEST"
rm -f "$NEW_MANIFEST"

# --- 3. Hook registration in user-level settings.json ---
# Registered as `bash <path>` so it runs regardless of the OS shell.
# Requires python3 for the JSON merge; degrades gracefully to the /setup agent.
if command -v python3 > /dev/null 2>&1; then
python3 - "$AI_DIR" "$CLAUDE_USER_DIR/settings.json" << 'PYEOF'
import json, os, sys

ai_dir, settings_path = sys.argv[1], sys.argv[2]
script = os.path.join(ai_dir, "hooks", "check-markdown-fences.sh").replace("\\", "/")
hook_cmd = f'bash "{script}"'

settings = {}
if os.path.exists(settings_path):
    with open(settings_path) as f:
        settings = json.load(f)

hooks = settings.setdefault("hooks", {})
post = hooks.setdefault("PostToolUse", [])

# Self-healing: drop any prior registration of this script (old path or old form),
# then append the canonical one if a matching entry isn't already present.
def is_ours(entry):
    return any("check-markdown-fences.sh" in h.get("command", "") for h in entry.get("hooks", []))

kept = [e for e in post if not is_ours(e)]
kept.append({"matcher": "Write|Edit", "hooks": [{"type": "command", "command": hook_cmd}]})
changed = kept != post
hooks["PostToolUse"] = kept

if changed:
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    print(f"installed: fence-check hook in {settings_path}")
else:
    print("ok: fence-check hook already registered")
PYEOF
else
  echo "SKIPPED: python3 not found — register the fence-check hook via /setup instead"
  echo "  (add to ~/.claude/settings.json hooks.PostToolUse: matcher \"Write|Edit\","
  echo "   command: bash \"$AI_DIR/hooks/check-markdown-fences.sh\")"
fi

echo "setup.sh complete"

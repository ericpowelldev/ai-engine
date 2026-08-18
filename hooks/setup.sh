#!/bin/bash
# Mechanical half of /setup. Idempotent — safe to re-run after git pull or module changes.
# Installs: the always-on import block (baseline + each always-scoped module's global
# rules), global commands/skills, module wiring (commands, skills, hooks.json), all
# manifest-tracked so removed modules clean up. Never overwrites unrelated user config.

set -euo pipefail

AI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && { pwd -W 2>/dev/null || pwd; })"
CLAUDE_USER_DIR="$HOME/.claude"
MANIFEST="$CLAUDE_USER_DIR/.ai-wiring-manifest"
BLOCK_START="<!-- ai-baseline:start -->"
BLOCK_END="<!-- ai-baseline:end -->"

mkdir -p "$CLAUDE_USER_DIR/commands" "$CLAUDE_USER_DIR/skills"

# --- 1. Always-on import block in user-level CLAUDE.md ---
# Baseline import + one global-rules import per always-scoped module (README begins
# its scope with the exact line "Scope: always"). Managed block, rebuilt every run.
USER_CLAUDE_MD="$CLAUDE_USER_DIR/CLAUDE.md"
touch "$USER_CLAUDE_MD"

BLOCK="$BLOCK_START
@$AI_DIR/CLAUDE.md"
for MODULE in "$AI_DIR"/modules/*/; do
  NAME="$(basename "$MODULE")"
  [ "$NAME" = "_template" ] && continue
  if [ -f "$MODULE/README.md" ] && grep -q '^Scope: always' "$MODULE/README.md" \
     && [ -f "$MODULE/rules/rules-global.md" ]; then
    BLOCK="$BLOCK
@$AI_DIR/modules/$NAME/rules/rules-global.md"
  fi
done
BLOCK="$BLOCK
$BLOCK_END"

TMP="$(mktemp)"
NEW="$(mktemp)"
# Drop any existing managed block and any legacy bare baseline import line
awk -v s="$BLOCK_START" -v e="$BLOCK_END" '
  $0 == s {skip=1; next}
  $0 == e {skip=0; next}
  !skip {print}
' "$USER_CLAUDE_MD" | grep -vF "@$AI_DIR/CLAUDE.md" > "$TMP" || true
printf '%s\n\n%s\n' "$(cat "$TMP")" "$BLOCK" > "$NEW"
if cmp -s "$NEW" "$USER_CLAUDE_MD"; then
  echo "ok: always-on import block already current"
else
  cp "$NEW" "$USER_CLAUDE_MD"
  echo "installed: always-on import block in $USER_CLAUDE_MD"
fi
rm -f "$TMP" "$NEW"

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

# Global commands (work in sessions booted anywhere).
# All root commands install globally except /setup, which only makes sense
# run from inside the baseline folder.
for CMD in "$AI_DIR"/.claude/commands/*.md; do
  [ "$(basename "$CMD")" = "setup.md" ] && continue
  install_file "$CMD" "$CLAUDE_USER_DIR/commands/$(basename "$CMD")"
done

# --- Typed-rule skill generation from the rule-types registry ---
# The registry (registries/rule-types.md) defines the types and their triggers;
# a skill is generated only for types some module actually uses. The type
# "global" is reserved (always-on via the import block, never a skill).
REGISTRY="$AI_DIR/registries/rule-types.md"

# Discover the types in use across modules (skip _template, skip global)
USED_TYPES="$(
  for M in "$AI_DIR"/modules/*/; do
    [ "$(basename "$M")" = "_template" ] && continue
    for F in "$M"rules/rules-*.md; do
      [ -f "$F" ] || continue
      basename "$F" | sed 's/^rules-//; s/\.md$//'
    done
  done | grep -v '^global$' | sort -u || true
)"

if [ -n "$USED_TYPES" ] && [ ! -f "$REGISTRY" ]; then
  echo "WARNING: typed rules files exist but no registry — copy registries/rule-types.template.md to registries/rule-types.md"
fi

if [ -f "$REGISTRY" ]; then
  GENERATED=""
  for TYPE in $USED_TYPES; do
    TRIGGER="$(grep -m1 "^- \*\*$TYPE\*\* — Load when: " "$REGISTRY" | sed "s/^- \*\*$TYPE\*\* — Load when: //" || true)"
    if [ -z "$TRIGGER" ]; then
      echo "WARNING: type \"$TYPE\" has rules files but no registry entry — register it in registries/rule-types.md or rename the files"
      continue
    fi
    SKILL_FILE="$CLAUDE_USER_DIR/skills/$TYPE-rules/SKILL.md"
    mkdir -p "$(dirname "$SKILL_FILE")"
    cat > "$SKILL_FILE" << SKILLEOF
---
name: $TYPE-rules
description: Load when $TRIGGER Loads the $TYPE rules from every active module.
---

The baseline folder is \`$AI_DIR\`.

1. Identify the active modules under \`modules/\`: every module whose README declares \`Scope: always\`, plus any whose declared scope matches the current work. (Skip \`_template\`.)
2. Read \`rules/rules-$TYPE.md\` from each active module that has one.
3. Apply them together — on conflict, the more specifically-scoped module's rule wins for its own work.
SKILLEOF
    echo "$SKILL_FILE" >> "$NEW_MANIFEST"
    GENERATED="$GENERATED$TYPE "
  done
  if [ -n "$GENERATED" ]; then
    echo "generated: typed-rule skills (${GENERATED%% })"
  fi

  # Info: registered types nobody uses yet
  grep -oE '^\- \*\*[a-z-]+\*\* — Load when:' "$REGISTRY" | sed 's/^- \*\*//; s/\*\*.*//' | while read -r RT; do
    echo "$USED_TYPES" | grep -qx "$RT" || echo "info: registered type \"$RT\" has no rules files yet (no skill generated)"
  done
fi

# Module wiring -> user-level only (global commands/skills cover every session,
# and the committed .claude/ stays module-agnostic)
for MODULE in "$AI_DIR"/modules/*/; do
  NAME="$(basename "$MODULE")"
  [ "$NAME" = "_template" ] && continue
  [ -d "$MODULE/wiring" ] || continue
  install_dir "$MODULE/wiring/commands" "$CLAUDE_USER_DIR/commands"
  install_dir "$MODULE/wiring/skills"   "$CLAUDE_USER_DIR/skills"
  echo "synced module wiring: $NAME"
done

# Remove files installed by a previous run that no longer exist in any source
if [ -f "$MANIFEST" ]; then
  while read -r OLD; do
    if [ -n "$OLD" ] && ! grep -qFx "$OLD" "$NEW_MANIFEST"; then
      rm -f "$OLD" && echo "removed stale wiring: $OLD"
      rmdir "$(dirname "$OLD")" 2>/dev/null || true
    fi
  done < "$MANIFEST"
fi
sort -u "$NEW_MANIFEST" > "$MANIFEST"
rm -f "$NEW_MANIFEST"

# --- 3. Module hook registration in user-level settings.json ---
# Merges each module's wiring/hooks.json (entries: {event, matcher, command} with
# {{AI_DIR}} placeholders). Managed: entries referencing this baseline folder are
# rebuilt from current sources every run, so removed modules unregister.
# Requires python3 for the JSON merge; degrades gracefully to the /setup agent.
if command -v python3 > /dev/null 2>&1; then
python3 - "$AI_DIR" "$CLAUDE_USER_DIR/settings.json" << 'PYEOF'
import json, os, sys, glob

ai_dir, settings_path = sys.argv[1], sys.argv[2]
ai_dir_fwd = ai_dir.replace("\\", "/")

settings = {}
if os.path.exists(settings_path):
    with open(settings_path) as f:
        settings = json.load(f)
hooks = settings.setdefault("hooks", {})

# Collect desired entries from every module's wiring/hooks.json
desired = {}  # event -> list of {matcher, command}
for hj in sorted(glob.glob(os.path.join(ai_dir, "modules", "*", "wiring", "hooks.json"))):
    if os.sep + "_template" + os.sep in hj:
        continue
    with open(hj) as f:
        for entry in json.load(f):
            cmd = entry["command"].replace("{{AI_DIR}}", ai_dir_fwd)
            desired.setdefault(entry["event"], []).append(
                {"matcher": entry.get("matcher", ""), "command": cmd})

def is_ours(hook_entry):
    return any(ai_dir_fwd in h.get("command", "") for h in hook_entry.get("hooks", []))

changed = False
events = set(hooks) | set(desired)
for event in events:
    existing = hooks.get(event, [])
    kept = [e for e in existing if not is_ours(e)]
    for d in desired.get(event, []):
        kept.append({"matcher": d["matcher"],
                     "hooks": [{"type": "command", "command": d["command"]}]})
    if kept != existing:
        changed = True
    if kept:
        hooks[event] = kept
    elif event in hooks:
        del hooks[event]
        changed = True

if changed:
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    print(f"installed: module hook registrations in {settings_path}")
else:
    print("ok: module hooks already registered")
PYEOF
else
  echo "SKIPPED: python3 not found — register module hooks via /setup instead"
  echo "  (merge each modules/*/wiring/hooks.json entry into ~/.claude/settings.json"
  echo "   as hooks.<event>: {matcher, command}, with {{AI_DIR}} = $AI_DIR)"
fi

echo "setup.sh complete"

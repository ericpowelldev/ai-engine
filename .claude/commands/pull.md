---
description: Pull the baseline repo and every module repo, then refresh the wiring
---

Update the whole system from its remotes. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

1. Run `bash {{AI_DIR}}/scripts/pull.sh` — it pulls the baseline repo and each module repo (ff-only, skipping any with uncommitted changes or no remote), then re-runs `wire.sh` so pulled wiring, rules, and hooks take effect.
2. Report the per-repo results to the user. For anything **skipped** or **FAILED**, say why and what would unblock it (commit/stash the dirty tree, set a remote, resolve the non-fast-forward by hand) — but don't take those actions yourself without a go-ahead.
3. If the pull brought in changes, note anything that affects the current session (new rules, changed commands) and suggest `/orient` if re-orientation would help.

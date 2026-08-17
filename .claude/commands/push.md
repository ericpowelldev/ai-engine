---
description: Commit and push every module repo (never the baseline); optional argument is the commit message
---

Back up the modules to their remotes. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

Optional commit message: $ARGUMENTS

1. Run `bash {{AI_DIR}}/hooks/push.sh "$ARGUMENTS"` (omit the argument if none was given — the script defaults to `sync: <date>`). Per module it: stages everything and commits when the tree is dirty, pushes any unpushed commits (setting the upstream on a first push), and skips modules that are clean and synced or have no remote. Current branch only, never force, and **never the baseline repo** — engine commits are hand-written by the user.
2. Report the per-module results. For anything **skipped** or **FAILED**, say why and what would unblock it (set a remote, check out a branch, resolve a rejected push by pulling first) — but don't take those actions yourself without a go-ahead.

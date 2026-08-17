---
description: <What this command produces, in one line — commands are named for the DELIVERABLE, prefixed with the module name (e.g. acme-release-notes)>
---

<!-- A module command is a THIN wrapper: it reads a guide (or knowledge doc) and follows
     it for the current work. Installed to ~/.claude/commands/ by /setup; {{AI_DIR}}
     resolves to the baseline folder's absolute path at install time. -->

Read `{{AI_DIR}}/modules/<Module>/guides/how-to-<produce-the-thing>.md` (if the placeholder is literal, the baseline folder is the current project root) and follow it to produce the deliverable for: $ARGUMENTS

If no target is given, ask what this is for. Read `{{AI_DIR}}/modules/<Module>/README.md` first if this session hasn't loaded the module yet.

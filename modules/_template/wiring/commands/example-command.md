---
description: <What this command produces, in one line. Commands are named for what they produce, carrying the module's command prefix when it has one (e.g. acme-release-notes)>
---

<!-- A module command is a THIN wrapper: it reads a guide and follows it for the current
     work. The procedure lives in the guide (content/guides/), never here, so it stays
     agent-agnostic. Installed to ~/.claude/commands/ by /setup; {{AI_DIR}} resolves to
     the baseline folder's absolute path at install time. Rename this file to the
     command's name (e.g. acme-release-notes.md) and point it at the real guide. -->

Read `{{AI_DIR}}/modules/<Module>/content/guides/how-to-write-release-notes.md` (if the placeholder is literal, the baseline folder is the current project root) and follow it for: $ARGUMENTS

If no target is given, ask what this is for. Read `{{AI_DIR}}/modules/<Module>/README.md` first if this session hasn't loaded the module yet.

---
description: Add an entry — rule or knowledge — to the baseline or a module; determines its shape, tier, and file, then reports the placement and reasoning
---

Add an entry to the rules/knowledge system. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

The entry, as the user stated it: $ARGUMENTS

If nothing was given, ask for it. Then:

## 1. Classify the shape

The content determines the shape — not how the user's request was phrased:

- **Rule** — instruction-shaped: "do X", "never Y", "prefer Z".
- **Knowledge** — fact-shaped: "X works like Y", "Z has no trigger".
- **Personal** — about the user rather than a system.

A fact with a rule-shaped consequence is captured as knowledge, with a companion rule offered when the consequence deserves standalone enforcement. **An explicit user override wins**: if the input says "as a rule" / "make this a hard rule" / "just a fact", honor it — the override is legitimate; classifying is only your job when the user hasn't.

## 2. Determine the tier

- **Module** — the entry involves a specific organization's systems, repos, conventions, or domain in any way. Match against each `modules/<Org>/README.md` declared scope. When org-related at all, it goes in the module (a generic version can be extracted later).
- **Generic** — org-independent → the baseline's `rules/` or `knowledge/`.
- **General rule + generic** → the baseline `CLAUDE.md`. High bar: every line there costs every session. Confirm with the user before adding to the baseline, offering the closest typed rules file as the alternative.
- **Personal** → if always-on, the user-level `~/.claude/CLAUDE.md`; otherwise `personal/`. Never committed files.

## 3. Determine the file

- **Rules**: the type — `coding`, `testing`, `planning`, `documenting`, `designing` — picks `rules/rules-<type>.md` (or the module's). A rule spanning two types goes in the primary one, repeated in the other only if each doc must stand alone without it.
- **Knowledge**: pick by kind — a system trap → the gotchas file, a term → the glossary, a repo fact → the repo map, workspace/process → the workspace doc. An existing file that fits beats a new one; create a new topically-named file only when none fits.

## 4. Check for overlap

Read the target file (and its counterpart in the other tier) first. If an existing entry already covers this, update or extend it instead of adding a duplicate — facts change, so stale versions get corrected in place, not appended beside. Say so in the report.

## 5. Write it in house style

- **Rules**: domain-prefixed kebab-case name (`coding-modular`), brief, direct, imperative. One line of why only when it changes how the rule is applied.
- **Knowledge**: fact-shaped, present tense, standalone — include the consequence that makes the fact worth knowing ("…so streaming subscriptions never see the change").
- Both: no paragraphs, no war stories, no status snapshots; user-neutral in any committed or module file.
- If the entry is mechanically checkable, note that a hook in `hooks/` could enforce it deterministically and offer to write one.

## 6. Report back

Give the user: **the classification** (rule vs. knowledge, especially when it differs from how they phrased the request — "you said rule, but this is fact-shaped, so it went to the gotchas file"), the entry's final name/text, the exact file it landed in, and the reasoning for the tier and file (one or two sentences each). Flag anything notable — an existing entry updated instead, a companion rule offered, a baseline addition, or a hook candidate.

---
description: Add an entry — rule or knowledge — to the owning module; determines its shape, module, and file, then reports the placement and reasoning
---

Add an entry to the rules/knowledge system. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

The entry, as the user stated it: $ARGUMENTS

If nothing was given, ask for it. Then:

## 1. Classify the shape

The content determines the shape — not how the user's request was phrased:

- **Rule** — instruction-shaped: "do X", "never Y", "prefer Z".
- **Knowledge** — fact-shaped: "X works like Y", "Z has no trigger".

A fact with a rule-shaped consequence is captured as knowledge, with a companion rule offered when the consequence deserves standalone enforcement. **An explicit user override wins**: if the input says "as a rule" / "make this a hard rule" / "just a fact", honor it — the override is legitimate; classifying is only your job when the user hasn't.

## 2. Determine the owning module

All content lives in modules — the baseline holds none:

- **Scoped module** — the entry involves a specific organization's or context's systems, repos, conventions, or domain in any way. Match against each scoped module's declared scope.
- **Always-scoped module** — cross-context content: working style, universal conventions, identity. General behavioral rules go in its `rules/rules-general.md` (always-on via the `/setup` import — that's the expensive tier, so confirm before adding there and offer the closest typed file as the alternative).
- **No module fits** → offer `/add-module` to create one; don't force content into the wrong module.

## 3. Determine the file

- **Rules**: the type — `general`, `coding`, `testing`, `planning`, `documenting`, `designing` — picks `rules/rules-<type>.md` in the owning module. A rule spanning two types goes in the primary one, repeated in the other only if each doc must stand alone without it.
- **Knowledge**: pick by kind — a system trap → the gotchas file, a term → the glossary, identity → the about file, a repo fact → the repo map. An existing file that fits beats a new one; create a new topically-named file only when none fits.

## 4. Check for overlap

Read the target file (and the same-typed file in other active modules) first. If an existing entry already covers this, update or extend it instead of adding a duplicate — facts change, so stale versions get corrected in place, not appended beside. Say so in the report.

## 5. Write it in house style

- **Rules**: domain-prefixed kebab-case name (`coding-modular`), brief, direct, imperative. One line of why only when it changes how the rule is applied.
- **Knowledge**: fact-shaped, present tense, standalone — include the consequence that makes the fact worth knowing.
- Both: no paragraphs, no war stories, no status snapshots. Modules own their own privacy, so naming the user is fine in identity knowledge; rules still read imperative and person-free.
- If the entry is mechanically checkable, note that a module hook (registered via `wiring/hooks.json`) could enforce it deterministically and offer to write one.

## 6. Report back

Give the user: **the classification** (rule vs. knowledge, especially when it differs from how they phrased the request), the entry's final name/text, the exact module and file it landed in, and the reasoning for each choice (one or two sentences). Flag anything notable — an existing entry updated instead, a companion rule offered, a general-rules addition, or a hook candidate.

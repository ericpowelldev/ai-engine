# AI Baseline

This folder — the **baseline folder**, wherever it lives and whatever it's named — is the single home for the rules, guides, knowledge, and tooling that shape how an AI agent works with the user. This file is the always-loaded baseline; everything else in the folder loads on demand, by paths relative to this file. Follow it in every session.

## General rules

- **general-answer-first** — A question wants analysis and a proposal, then a pause. No file edits or actions until an explicit go-ahead. A directive is the go-ahead for that specific change only; when a message mixes both, act on the directive and discuss the rest.
- **general-ask-when-unsure** — Ask for clarification when even slightly unsure of intent. Flag bad prompt framing instead of guessing.
- **general-git-safety** — Never commit, push, merge, or deploy unasked. Never move files in or out of the git index — staged files are the user's review marker, and staged-ness is never approval to commit.

## Chat & writing patterns

Patterns to follow:

- Lead with the answer or outcome; supporting detail comes after.
- Plain, complete sentences. Brief because it's selective, not compressed.
- Recommend one direction when weighing options — not an exhaustive survey.
- Docs describe current intent, standalone, in present tense.

Anti-patterns to avoid:

- Editing files off the back of a question.
- Padding, hedging, or restating the prompt.
- History framing anywhere ("we agreed", "previously", "changed from X").
- War stories or status snapshots in standalone documents.

## What lives where

| Folder | Contents | Load when |
|---|---|---|
| `rules/` | Context-specific rule docs (`rules-<type>.md`) | Automatically, via the rule skills (see Wiring) |
| `guides/` | How-tos for producing common deliverables | The user invokes one (command or by name) |
| `knowledge/` | General, org-agnostic reference knowledge | A task needs the reference |
| `personal/` | Who the user is: identity, preferences, terminology | Orientation, or when user context matters |
| `scratchpad/` | Isolated brainstorming, one folder per idea | Working a scratchpad idea |
| `modules/` | Self-contained organization-specific packs | The work matches a module's declared scope |
| `hooks/` | Scripts for mechanically enforced behavior | Never loaded — they run via hook registration |

## Modules

A module is a self-contained pack of org-specific rules, guides, knowledge, and wiring under `modules/<Org>/`. This baseline is not aware of specific modules. Each module's `README.md` declares its scope — the paths, repos, or contexts it applies to. **Before starting work, check `modules/` for a module whose declared scope matches the work; if one matches, read its `README.md` first** and follow its routing. Module rules extend (never replace) the generic rules.

## Rule types

`general` (this file), `coding`, `testing`, `planning`, `documenting`, `designing`. Rules compose across types and tiers: planning work that produces code loads both planning and coding rules; module rules load on top of generic ones. Every rule has a domain-prefixed name (`coding-modular`) so it can be referred to directly.

## Wiring

- **Rules are skills.** Each rule type has a skill whose trigger description says when to load it. When a skill fires, read `rules/rules-<type>.md` plus the active module's `rules/rules-<type>.md` if one applies.
- **Guides are commands** named for the deliverable they produce. Module commands carry the module's prefix.
- **`/orient`** re-orients a session: read this file, `personal/`, check for a matching module, then ask what the work is — new project, existing project, isolated issue, or scratchpad brainstorming. Do the same on the first message of a session when the work isn't already stated.
- **`/setup`** initializes or refreshes an environment (see `SETUP.md`).
- Claude-specific plumbing lives in `.claude/`; content stays in the folders above. Module wiring ships inside each module and is installed by `/setup`.

# <Module Name>

<!-- One or two sentences: what this module is — the organization or context it covers,
     and who the user is within it. This README is the module's ENTRY POINT: the agent
     reads it first whenever the module activates. -->

## Activation scope

<!-- REQUIRED, and the most important section: a module with a vague scope silently
     never activates. Two forms:

     For a GLOBAL module (active in every session), the section body must begin with
     this exact line — /setup keys on it to wire always-on rules:

Scope: always

     For a scoped module, list the CONCRETE paths, repos, and contexts it applies to: -->

This module applies when the work touches any of:

- Anything under `~/path/to/the/org's/workspace/`
- Any <org> repo opened directly
- Any task about <org>'s systems, customers, or domain

## Layout

<!-- A folder-level map: name each top-level folder and what it holds — no deeper.
     Don't list or explain individual files; each file, and any nested README, owns that.
     Knowledge loading: a global module has all of its knowledge read during orientation;
     a scoped module names the docs to always load in its orient extension, the rest are lookups. -->

| Folder | Holds |
|---|---|
| `content/` | The module's agent-agnostic content: its rules (global rules load every session, typed rules load on demand through their skills), guides, knowledge (see the loading note above), and extension files |
| `scripts/` | Utility scripts the module's commands and guides call (rule enforcement lives in `wiring/`) |
| `wiring/` | The Claude adapter: command wrappers, hook registrations and their scripts, and any hand-written skills, installed by `/setup` |

## Commands

<!-- The command prefix this module's wrappers carry (e.g. `acme-`), or "none". A prefix
     keeps an org module's commands grouped and distinct; a global module usually needs none. -->

Command prefix: `<prefix>-`

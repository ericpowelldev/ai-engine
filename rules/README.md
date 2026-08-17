# rules/

Context-specific rule documents, one per rule type: `rules-coding.md`, `rules-testing.md`, `rules-planning.md`, `rules-documenting.md`, `rules-designing.md`. (`general` rules live in the root `CLAUDE.md` — they're always-on.)

## How they load

Each rule type has a skill in `.claude/skills/` with a trigger description ("Load before writing or editing any code"). The agent invokes the skill when a task matches; the skill reads the generic file here plus the active module's same-typed file. Contexts compose — planning work that produces code loads both planning and coding rules.

## Writing rules

- **Named**: every rule gets a short domain-prefixed name (`coding-modular`, `documenting-forward-only`) so it can be referred to directly.
- **Brief and direct**: a few lines each. Include one line of why only when it changes how the rule is applied. No paragraphs, no war stories.
- **Standalone docs**: repeating a rule across files is fine — each doc must stand alone.
- **User-neutral**: rules here never name the user; user-specific rules live in `personal/` or the user-level config.
- **Prefer hooks**: if a script could enforce the rule deterministically, write it in `hooks/` instead and keep only a one-line rule here pointing at it.
- **Org-specific rules** go in the owning module's `rules/`, not here.

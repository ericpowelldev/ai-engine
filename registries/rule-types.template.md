# Rule Types

<!-- The canonical registry of rule types: what exists and when each loads.
     One line per type: - **<type>** — Load when: <trigger>
     The trigger becomes the generated skill's description, so write it as the
     condition an agent should recognize: concrete, work-shaped, unambiguous.
     Setup generates a skill only for types some module actually uses.
     These entries are EXAMPLES — replace them with your own taxonomy. -->

- **global** — Reserved: always-on rules, loaded in every session via the user-level import; never skill-generated.
- **coding** — Load when: writing, editing, or reviewing any code, in any language or repo.
- **designing** — Load when: doing any UI, UX, mockup, styling, or visual design work — components, layouts, colors, typography, themes.
- **documenting** — Load when: writing or editing any document — markdown files, plans, READMEs, summaries, test plans, or any prose deliverable.
- **planning** — Load when: creating, editing, or executing a plan — project plans, implementation plans, phased work.
- **testing** — Load when: planning, writing, or running tests of any kind.

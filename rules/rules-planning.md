# Planning Rules

- **planning-execute-as-written** — When a plan names roles, phases, or steps, execute them as written or ask before deviating — never silently skip, merge, or substitute. Reviewer/verifier roles are never substitutable for the implementer's self-review; independent eyes exist to catch what the implementer can't see.
- **planning-followup-means-defer** — "As a follow-up" means record it in the plan's Follow-ups section and stop. Never execute it now, and never document unshipped behavior in delivery or test docs — those update only after the code lands.
- **planning-followups-implementation-only** — A plan's Follow-ups section holds only deferred implementation work the plan's owner will execute. Ops handoffs, rollout tasks, and other plans' scope are tracked by their owners, not here.

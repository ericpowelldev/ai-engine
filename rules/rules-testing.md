# Testing Rules

- **testing-unit-only** — Test only pure, easily-isolated functions (builders, formatters, reducers, helpers). No component/UI tests, no hook-render tests, no smoke/render tests — skip anything needing a rendering or provider harness. Logic worth testing but trapped in a component gets extracted into a pure helper and tested there. Exceptions must be explicit and project-scoped.

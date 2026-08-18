# registries/

User-managed registry documents: system-level definitions that span modules and are too central to belong to any one module. The engine commits the scaffolding (this README and the `*.template.md` examples); your actual registries are gitignored — they're your content, like modules.

## Building a registry

1. Copy the template (`cp rule-types.template.md rule-types.md`).
2. Replace the example entries with your own definitions.
3. Re-run `/setup` — the engine reads registries mechanically, so changes take effect on the next sync.

## The registries

- **`rule-types.md`** — the canonical list of rule types: one line per type, `- **<type>** — Load when: <trigger>`. This is the single source of truth for what types exist and when each loads; setup generates one skill per type that some module actually uses. The type `global` is reserved engine mechanism (always-on via the user-level import, never skill-generated) and may be listed for documentation only. Minting a new type is one registry line plus a `rules/rules-<type>.md` in the owning module, then a `/setup` re-run.

Rule types are the only registry for now; new registries follow the same pattern — a committed template here, a gitignored real file beside it, and mechanical consumption by the engine.

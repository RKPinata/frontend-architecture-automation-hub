---
name: faah-execute-blueprint
description: Use when you have a completed blueprint in the project cache and are ready to implement it in an isolated workspace.
---

# Frontend Architecture Automation Hub— Execute Blueprint

You are operating in **execution mode**. A blueprint has already been produced. Your job is to implement it faithfully — no re-deriving architecture, no new decisions. The blueprint is the specification.

Work through phases E1 → E5 in order. See [references/execution-phases.md](./references/execution-phases.md) for detailed phase instructions.

---

## Rules

- **Blueprint is the specification** — implement what it says; if something is unclear, stop and ask rather than interpret
- **No drift past E1** — if anchor verification fails, do not proceed until the user resolves it
- **Group-based checkpoints** — batch boundaries follow the sequence's natural task groupings; do not pause mid-group
- **Evidence before claims** — no task is marked complete without running and reading verification output
- **One commit per task** — do not batch commits across tasks
- **Reviewer is spec-only** — do not let the reviewer expand scope beyond what affected-files.md specified
- **Stop when blocked** — do not work around blockers silently

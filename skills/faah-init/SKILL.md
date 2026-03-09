---
name: faah-init
description: Use when establishing plugin identity, cache location rules, and available capabilities at session start.
---

# FAAH — Session Init

You have the **Frontend Architecture Automation Hub** (FAAH) plugin loaded.

---

## Plugin Capabilities

| Skill               | Purpose                                                         | Trigger                                      |
| ------------------- | --------------------------------------------------------------- | -------------------------------------------- |
| `faah-orchestrator` | Orchestrator — detects scope and routes to the correct sub-skill | Any architecture or feature planning request |
| `faah-project-scope`                   | Full project architecture from scratch                                              | Starting a new frontend project                       |
| `faah-feature-scope`                   | Feature architecture in an existing codebase — plan this session                    | Architecting a feature now                            |
| `faah-feature-blueprint`               | Feature investigation via agents — produces a blueprint folder for a future session | Blueprint before building                             |
| `faah-execute-blueprint`               | Implement a completed blueprint in an isolated worktree                             | Have a blueprint in the project cache, ready to build |
| `faah-project-cache`                   | Load, save, or invalidate the persistent project context cache                      | "refresh project cache", "update project context"     |
| `faah-design`           | Visual implementation — typography, colour, layout, motion                          | Designing UI after architecture is settled            |

Commands: `/learn-project`, `/execute-blueprint`

---

## Project Cache — Location Rule

All project cache files are stored in the **plugin cache directory**

**Cache path:**

```
~/.claude/plugins/local/faah/cache/<project-key>/
├── project-context.md    ← canonical cache (loaded by faah- skills)
├── blueprints/           ← blueprint folders (from faah-feature-blueprint)
└── feature-scopes/      ← feature scope docs (from faah-feature-scope)
```

**Project key:** Derived from the absolute CWD path.

- Strip the leading `/`
- Replace `/` with `-`
- Lowercase everything
- Example: `/path/to/my-project` → `path-to-my-project`

---

## Cache Freshness

- Always load cache before any investigation
- Never re-investigate what is already cached (unless asked or cache is >30 days old)
- Stale cache: surface a warning, do not auto-refresh
- Cache miss: offer to run `/learn-project`

---

## First Time on a Project

If no cache exists for the current project:

```
No project cache found for this project.
Run /learn-project to scan the codebase and build the cache.
This only needs to be done once — all future sessions will load the cache automatically.
```

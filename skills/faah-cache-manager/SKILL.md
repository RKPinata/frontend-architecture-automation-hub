---
name: faah-cache-manager
description: Use when you need to list, inspect, or clear cached project context, blueprints, or feature scopes.
---

# FAAH — Cache Manager

You manage the **FAAH project cache** for the current project. You do not investigate the codebase and you do not write code.

Work through the requested operation below.

---

## Cache Root

```
~/.claude/plugins/local/faah/cache/<project-key>/
```

Compute `<project-key>` from CWD: strip leading `/`, replace `/` with `-`, lowercase.
Example: `/path/to/my-project` → `path-to-my-project`

---

## Operations

### `show` — List all cached artifacts

Present a summary of everything stored for the current project:

```
## Project Cache: <project-key>

### Project Context
  [✓ Cached YYYY-MM-DD | ✗ Not cached]

### Blueprints ([N] total)
  [If blueprints/index.md exists, list each entry:]
  • YYYY-MM-DD-<feature-name>  [status: ready | in_progress]  — [one-line summary]
  [If no blueprints: "No blueprints cached."]

### Feature Scopes ([N] total)
  [If feature-scopes/index.md exists, list each entry:]
  • YYYY-MM-DD-<feature-name>  [complexity]  — [one-line summary]
  [If no scopes: "No feature scopes cached."]
```

---

### `inspect <artifact>` — Show details

When the user asks to inspect a specific blueprint or scope:

1. Locate the file/folder in the cache.
2. Present the contents of `README.md` (blueprint) or the scope file.
3. For in-progress blueprints, show the `.progress` file status.

---

### `clear project-context` — Clear project context only

1. Delete `project-context.md` from the cache directory.
2. Confirm: `Project context cleared. Next investigation will re-scan the codebase.`

---

### `clear blueprint <name>` — Clear a specific blueprint

1. Remove the blueprint folder matching `<name>` (partial match is fine).
2. Remove the entry from `blueprints/index.md`.
3. Confirm: `Blueprint <name> removed from cache.`

---

### `clear scope <name>` — Clear a specific feature scope

1. Remove `feature-scopes/YYYY-MM-DD-<name>.md`.
2. Remove the entry from `feature-scopes/index.md`.
3. Confirm: `Feature scope <name> removed from cache.`

---

### `clear all` — Clear entire project cache

Ask for confirmation first:

```
This will delete all cached artifacts for <project-key>:
  - project-context.md
  - [N] blueprint(s)
  - [N] feature scope(s)

Confirm? (yes / no)
```

On yes: delete the entire `<project-key>/` directory.
Confirm: `Project cache cleared. All artifacts removed.`

---

## Rules

- Always compute the project key from CWD before any operation.
- Never modify project source files.
- Never automatically clear anything without user confirmation for destructive operations.
- Index files (`blueprints/index.md`, `feature-scopes/index.md`) must be kept in sync after any delete.

---
name: faah-project-cache
description: Use when you need to load, save, refresh, or clear the persistent per-project context cache.
---

# Frontend Architecture Automation Hub— Project Cache

You manage the **project context cache** — a persistent file that stores the investigated patterns, conventions, and stack of a project. The goal: as the user uses FAAH more, the plugin understands the project better, and investigation is skipped when the cache is already reliable.

---

## Cache Location

All project artifacts are stored under a single project cache directory:

```
~/.claude/plugins/local/faah/cache/<project-key>/
├── project-context.md              — project patterns, stack, conventions (managed by faah-project-cache)
├── blueprints/                     — feature blueprints (managed by faah-feature-blueprint)
│   ├── index.md                    — index of all blueprints for this project
│   └── YYYY-MM-DD-<feature>/       — one folder per blueprint
│       ├── README.md
│       ├── requirements.md
│       ├── affected-files.md
│       ├── implementation-sequence.md
│       ├── investigation/
│       └── .progress
└── feature-scopes/                 — feature architecture scopes (managed by faah-feature-scope)
    ├── index.md                    — index of all scopes for this project
    └── YYYY-MM-DD-<feature>.md     — one file per feature scope
```

**Project key:** Derived from the absolute path of the current working directory.

- Take the CWD path, strip the leading `/`, replace `/` with `-`, lowercase.
- Example: `/path/to/my-project` → `path-to-my-project`

---

## Cache File Structure

See [references/cache-file-structure.md](./references/cache-file-structure.md) for the structured markdown format used for the project context cache.

---

## Operations

### Load Cache

1. Compute the project key from CWD.
2. Check if `~/.claude/plugins/local/faah/cache/<project-key>/project-context.md` exists.
3. If it exists, read it and return the cache.
4. If it does not exist, return: `CACHE_MISS`.

### Save Cache

After a successful project investigation (from faah-feature-scope Phase F1 or faah-feature-blueprint Phase B1):

1. Compute the project key.
2. Create the directory if it does not exist.
3. Write the structured cache file using the findings from the investigation.
4. Confirm: `Project context cached for future sessions.`

### Invalidate Cache

When the user says "refresh project cache", "re-investigate project", or "update project context":

1. Delete or overwrite the existing cache file.
2. Confirm: `Project cache cleared. Next investigation will re-scan the codebase.`
3. Trigger a fresh investigation (return to the calling skill's investigation phase).

---

## Freshness Rules

The cache is always used unless one of the following applies:

- The user explicitly requests a refresh.
- The cache file does not exist.
- The cache `**Cached:**` date is more than 30 days old.
- The user mentions a major refactor, framework upgrade, or restructuring happened.

If the cache is stale by date, surface it:

```
⚠️  Project cache is from [date] ([N] days ago). Using cached context — to refresh, say "refresh project cache".
```

Do not automatically re-investigate on staleness. Always prefer the cache unless told otherwise.

---

## Section Extraction

Other skills load only the sections relevant to their domain, not the full cache. Use this mapping:

| Agent domain                | Sections to extract                            |
| --------------------------- | ---------------------------------------------- |
| Components agent            | Stack, Component Patterns, File Naming         |
| State agent                 | Stack, State Patterns, Key Conventions         |
| Routing agent               | Stack, Routing Patterns, Folder Structure      |
| API / data fetching agent   | Stack, Data Fetching Patterns, Key Conventions |
| Full context (F1 / B1 scan) | All sections                                   |

When briefing an agent, paste only the relevant sections — not the entire cache file.

---

## Rules

- Always check for a cache before triggering any codebase investigation.
- Never re-investigate what is already cached unless explicitly asked.
- Save to cache after every new investigation — the cache is the persistent memory of the project.
- The cache is read-only input for agents — agents never write to the cache file directly; only the orchestrating skill writes it after validating agent findings.
